import 'dart:math';
import '../../data/models/sleep_session.dart';

class SleepScorer {
  static int calculateScore(SleepSession session) {
    if (session.endTime == null) return 0;

    int baseScore = 100;

    // deduct 2 points per snore event (max -30)
    int snoreDeduction = min(session.snoreEventCount * 2, 30);
    baseScore -= snoreDeduction;

    // deduct 1 point per dB above 55 average noise (max -20)
    if (session.averageNoiseDb > 55) {
      int noiseDeduction = min((session.averageNoiseDb - 55).toInt(), 20);
      baseScore -= noiseDeduction;
    }

    final duration = session.endTime!.difference(session.startTime);
    final hours = duration.inMinutes / 60.0;

    // deduct 5 points if session < 6 hours
    if (hours < 6) {
      baseScore -= 5;
    }
    // deduct 3 points if session < 7 hours
    else if (hours < 7) {
      baseScore -= 3;
    }
    // add 5 points if session >= 8 hours
    else if (hours >= 8) {
      baseScore += 5;
    }

    // add 3 points if zero snore events detected
    if (session.snoreEventCount == 0) {
      baseScore += 3;
    }

    return baseScore.clamp(0, 100);
  }

  static Map<String, double> estimateSleepStages(SleepSession session) {
    // This is a rough heuristic
    // First 20% of sleep = light sleep
    // Middle 50% with low noise = deep sleep candidate
    // Periods with moderate movement noise = REM candidate
    // Snore-heavy periods = light sleep

    // For now, let's just return some representative values
    // In a real app, this would be calculated based on the timeline of events

    if (session.snoreEventCount > 10) {
      return {
        'light': 0.6,
        'deep': 0.2,
        'rem': 0.2,
      };
    } else {
      return {
        'light': 0.3,
        'deep': 0.4,
        'rem': 0.3,
      };
    }
  }
}
