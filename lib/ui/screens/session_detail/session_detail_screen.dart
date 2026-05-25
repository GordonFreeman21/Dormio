import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/sleep_session_provider.dart';
import '../../../providers/calendar_provider.dart';
import '../../widgets/sleep_score_ring.dart';
import '../../widgets/snore_timeline.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: sessionAsync.when(
        data: (session) {
          if (session == null) return const Center(child: Text('Session not found'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(session),
                const SizedBox(height: 32),
                Text('Snore Timeline', style: AppTypography.display.copyWith(fontSize: 18)),
                const SizedBox(height: 8),
                SnoreTimeline(
                  startTime: session.startTime,
                  endTime: session.endTime!,
                  events: session.snoreEvents,
                ),
                const SizedBox(height: 32),
                _buildStatsGrid(session),
                const SizedBox(height: 32),
                _buildCalendarSection(ref, session),
                const SizedBox(height: 32),
                _buildAudioPlayer(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildHeader(session) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppDateUtils.formatFullDate(session.startTime), style: AppTypography.display.copyWith(fontSize: 24)),
                Text(
                  '${AppDateUtils.formatTime(session.startTime)} - ${AppDateUtils.formatTime(session.endTime!)}',
                  style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            SleepScoreRing(score: session.sleepScore, size: 80),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          AppDateUtils.formatDuration(session.endTime!.difference(session.startTime)),
          style: AppTypography.display.copyWith(fontSize: 32, color: AppColors.moonGlow),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(session) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard('Snore Events', '${session.snoreEventCount}'),
        _buildStatCard('Avg Noise', '${session.averageNoiseDb.toInt()} dB'),
        _buildStatCard('Total Snore', '${session.totalSnoreMinutes}m'),
        _buildStatCard('Deep Sleep', '${(session.sleepStages['deep'] ?? 0 * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTypography.label),
          Text(value, style: AppTypography.stats.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(WidgetRef ref, session) {
    final eventsAsync = ref.watch(calendarEventsProvider((start: session.startTime, end: session.endTime!)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Correlated Calendar Events', style: AppTypography.display.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        eventsAsync.when(
          data: (events) {
            if (events.isEmpty) return const Text('No events found', style: TextStyle(color: AppColors.textMuted));
            return Column(
              children: events.map((event) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.event, color: _getCategoryColor(event.category)),
                title: Text(event.title),
                subtitle: Text(AppDateUtils.formatTime(event.start)),
                trailing: event.isEarlyMorning ? const Chip(label: Text('Early', style: TextStyle(fontSize: 10))) : null,
              )).toList(),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Error loading events'),
        ),
      ],
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'work': return AppColors.sleepPurple;
      case 'social': return AppColors.remGold;
      case 'health': return AppColors.deepSleep;
      default: return AppColors.textMuted;
    }
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_arrow_rounded, size: 40, color: AppColors.moonGlow),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                LinearProgressIndicator(value: 0.3, backgroundColor: AppColors.surface, valueColor: AlwaysStoppedAnimation(AppColors.moonGlow)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('02:14', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    Text('07:23', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Text('1x', style: TextStyle(color: AppColors.moonGlow, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
