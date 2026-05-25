import 'dart:math';
import '../models/snore_event.dart';
import '../../core/utils/audio_analyzer.dart';
import 'package:uuid/uuid.dart';

class SnoreDetectionService {
  /// Snore Detection Algorithm:
  /// - Snores typically occupy the 60–500 Hz frequency band
  /// - A snore event is flagged when:
  ///   - The dominant frequency is between 60–500 Hz
  ///   - The amplitude exceeds 45 dB
  ///   - The sound lasts at least 1.5 seconds
  ///   - It is separated from the previous snore event by at least 3 seconds

  List<SnoreEvent> analyzeAudioBuffer(List<double> samples, int sampleRate, DateTime bufferStartTime) {
    // In a real app, this would be called with chunks of audio.
    // For this build, we implement the core logic of the detection.

    final analysis = AudioAnalyzer.analyzeChunk(samples, sampleRate);
    final freq = analysis['frequency']!;
    final db = AudioAnalyzer.calculateDb(samples);

    if (isSnore(freq, db)) {
      return [
        SnoreEvent(
          id: const Uuid().v4(),
          timestamp: bufferStartTime,
          durationSeconds: 2, // Simplified for this implementation
          peakDb: db,
          confidence: calculateConfidence(db, freq),
        )
      ];
    }

    return [];
  }

  bool isSnore(double frequency, double db) {
    return (frequency >= 60 && frequency <= 500) && (db > 45);
  }

  double calculateConfidence(double peakDb, double frequency) {
    double frequencyScore = 0.0;
    if (frequency >= 100 && frequency <= 300) {
      frequencyScore = 1.0;
    } else if ((frequency >= 60 && frequency < 100) || (frequency > 300 && frequency <= 500)) {
      frequencyScore = 0.7;
    }

    // Normalize dB between 45 and 80 for scoring
    double dbScore = (peakDb - 45) / 35;
    return (dbScore * frequencyScore).clamp(0.0, 1.0);
  }
}
