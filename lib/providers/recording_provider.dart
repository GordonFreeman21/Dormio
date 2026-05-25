import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/audio_recording_service.dart';
import '../data/services/snore_detection_service.dart';
import '../data/models/snore_event.dart';

final audioRecordingServiceProvider = Provider((ref) => AudioRecordingService());
final snoreDetectionServiceProvider = Provider((ref) => SnoreDetectionService());

final recordingProvider = StateNotifierProvider<RecordingNotifier, RecordingState>((ref) {
  return RecordingNotifier(
    ref.watch(audioRecordingServiceProvider),
    ref.watch(snoreDetectionServiceProvider),
  );
});

class RecordingState {
  final bool isRecording;
  final String? filePath;
  final DateTime? startTime;
  final double currentDb;
  final List<SnoreEvent> detectedSnores;

  RecordingState({
    this.isRecording = false,
    this.filePath,
    this.startTime,
    this.currentDb = 0,
    this.detectedSnores = const [],
  });

  RecordingState copyWith({
    bool? isRecording,
    String? filePath,
    DateTime? startTime,
    double? currentDb,
    List<SnoreEvent>? detectedSnores,
  }) {
    return RecordingState(
      isRecording: isRecording ?? this.isRecording,
      filePath: filePath ?? this.filePath,
      startTime: startTime ?? this.startTime,
      currentDb: currentDb ?? this.currentDb,
      detectedSnores: detectedSnores ?? this.detectedSnores,
    );
  }
}

class RecordingNotifier extends StateNotifier<RecordingState> {
  final AudioRecordingService _audioService;
  final SnoreDetectionService _snoreService;
  StreamSubscription? _amplitudeSubscription;
  final List<double> _buffer = [];

  RecordingNotifier(this._audioService, this._snoreService) : super(RecordingState());

  Future<void> start() async {
    final path = await _audioService.startRecording();
    state = state.copyWith(
      isRecording: true,
      filePath: path,
      startTime: DateTime.now(),
      detectedSnores: [],
    );

    _amplitudeSubscription = _audioService.amplitudeStream.listen((db) {
      state = state.copyWith(currentDb: db);

      // Live snore detection logic:
      // We simulate collecting samples and analyzing them
      // In a real app, 'db' and frequency data would be used
      _buffer.add(db);
      if (_buffer.length >= 25) { // ~5 seconds of data at 200ms intervals
        final avgDb = _buffer.reduce((a, b) => a + b) / _buffer.length;
        if (avgDb > 50) { // Threshold for a potential snore
          final newSnore = _snoreService.analyzeAudioBuffer([], 44100, DateTime.now());
          if (newSnore.isNotEmpty) {
            state = state.copyWith(detectedSnores: [...state.detectedSnores, ...newSnore]);
          }
        }
        _buffer.clear();
      }
    });
  }

  Future<String?> stop() async {
    await _audioService.stopRecording();
    _amplitudeSubscription?.cancel();
    final path = state.filePath;
    state = state.copyWith(isRecording: false);
    return path;
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    super.dispose();
  }
}
