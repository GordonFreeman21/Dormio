import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/sleep_scorer.dart';
import '../../../data/models/sleep_session.dart';
import '../../../providers/recording_provider.dart';
import '../../../providers/sleep_session_provider.dart';
import '../../../providers/calendar_provider.dart';
import '../../widgets/waveform_visualizer.dart';
import '../../widgets/star_field.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _starController;
  final List<double> _dbHistory = [];
  final List<Star> _stars = List.generate(150, (_) => Star.random());

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    WakelockPlus.enable();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recordingProvider.notifier).start();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _starController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingProvider);

    if (state.currentDb > 0) {
      _dbHistory.add(state.currentDb);
      if (_dbHistory.length > 50) _dbHistory.removeAt(0);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          CustomPaint(
            size: Size.infinite,
            painter: StarFieldPainter(stars: _stars, animationValue: _starController.value),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(state),
                const Spacer(),
                _buildMoon(),
                const SizedBox(height: 48),
                _buildTimer(),
                const SizedBox(height: 24),
                _buildRecordingStatus(),
                const Spacer(),
                _buildLiveDbMeter(state.currentDb),
                const SizedBox(height: 48),
                _buildWakeUpButton(context, state),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [AppColors.surface, AppColors.background],
        ),
      ),
    );
  }

  Widget _buildHeader(RecordingState state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('🎙 ${state.detectedSnores.length}', style: AppTypography.label),
          ),
        ],
      ),
    );
  }

  Widget _buildMoon() {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: const Icon(Icons.nights_stay, size: 100, color: AppColors.moonGlow),
    );
  }

  Widget _buildTimer() {
    return Text(
      AppDateUtils.formatTime(DateTime.now()),
      style: AppTypography.stats.copyWith(fontSize: 56, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecordingStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BlinkingDot(),
        const SizedBox(width: 8),
        Text('Recording...', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildLiveDbMeter(double currentDb) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          WaveformVisualizer(amplitudeSamples: _dbHistory, isLive: true),
          const SizedBox(height: 8),
          Text(
            '${currentDb.toInt()} dB',
            style: AppTypography.label,
          ),
        ],
      ),
    );
  }

  Widget _buildWakeUpButton(BuildContext context, RecordingState state) {
    return GestureDetector(
      onTap: () => _handleWakeUp(context, state),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.sleepPurple,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.sleepPurple.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          'Wake Up',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  void _handleWakeUp(BuildContext context, RecordingState state) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final path = await ref.read(recordingProvider.notifier).stop();
    final startTime = state.startTime!;
    final endTime = DateTime.now();

    // Fetch calendar events
    final events = await ref.read(calendarRepositoryProvider).getEventsForSession(startTime, endTime);

    final session = SleepSession(
      id: const Uuid().v4(),
      startTime: startTime,
      endTime: endTime,
      audioFilePath: path,
      snoreEventCount: state.detectedSnores.length,
      snoreEvents: state.detectedSnores,
      averageNoiseDb: 42.0, // Mock
      calendarEventIds: events.map((e) => e.id).toList(),
    );

    session.sleepScore = SleepScorer.calculateScore(session);
    session.sleepStages = SleepScorer.estimateSleepStages(session);

    await ref.read(sleepSessionsProvider.notifier).saveSession(session);

    if (context.mounted) {
      Navigator.pop(context); // hide loading
      context.go('/session/${session.id}');
    }
  }
}

class _BlinkingDot extends StatefulWidget {
  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: AppColors.snoreRed, shape: BoxShape.circle),
      ),
    );
  }
}
