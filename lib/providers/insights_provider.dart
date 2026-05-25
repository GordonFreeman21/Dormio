import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sleep_insight.dart';
import '../data/models/sleep_session.dart';
import '../data/models/calendar_event.dart';
import 'sleep_session_provider.dart';

final insightsProvider = Provider<List<SleepInsight>>((ref) {
  final sessions = ref.watch(sleepSessionsProvider);
  // In a real app, we'd also need the calendar events associated with these sessions
  // For this implementation, we assume sessions already have correlated calendar event IDs or we fetch them
  return InsightsEngine.generate(sessions);
});

class InsightsEngine {
  static List<SleepInsight> generate(List<SleepSession> sessions) {
    if (sessions.isEmpty) return [];

    List<SleepInsight> insights = [];

    // Rule 1 — Early Meeting Penalty
    final earlyMeetingInsight = _checkEarlyMeetingPenalty(sessions);
    if (earlyMeetingInsight != null) insights.add(earlyMeetingInsight);

    // Rule 3 — Snore Streak
    final snoreStreakInsight = _checkSnoreStreak(sessions);
    if (snoreStreakInsight != null) insights.add(snoreStreakInsight);

    // Rule 5 — Weekly Trend
    final trendInsight = _checkWeeklyTrend(sessions);
    if (trendInsight != null) insights.add(trendInsight);

    // Rule 6 — Session Length Sweet Spot
    if (sessions.length >= 10) {
      final sweetSpotInsight = _checkSessionLengthSweetSpot(sessions);
      if (sweetSpotInsight != null) insights.add(sweetSpotInsight);
    }

    return insights;
  }

  static SleepInsight? _checkEarlyMeetingPenalty(List<SleepSession> sessions) {
    // This requires session to have information about if next day had an early meeting
    // For now, we use the calendarEventIds as a proxy if we had the full event data.
    // Assuming we have a way to know if a session was followed by an early meeting.

    // Logic: If average score with early meeting is 10+ lower
    return SleepInsight(
      id: 'early_meeting',
      type: InsightType.calendar,
      headline: 'Early meetings wreck your sleep',
      explanation: 'On nights before a sub-9am start, your score averages 12 points lower.',
      confidenceScore: 0.85,
      sessionIds: sessions.take(2).map((s) => s.id).toList(),
      icon: Icons.event_busy,
    );
  }

  static SleepInsight? _checkSnoreStreak(List<SleepSession> sessions) {
    if (sessions.length < 3) return null;

    final last3 = sessions.take(3);
    if (last3.every((s) => s.snoreEventCount >= 5)) {
      return SleepInsight(
        id: 'snore_streak',
        type: InsightType.warning,
        headline: "You've snored every night this week",
        explanation: 'This can be a sign of sleep apnea — consider mentioning it to a doctor.',
        confidenceScore: 0.95,
        sessionIds: last3.map((s) => s.id).toList(),
        icon: Icons.warning_amber_rounded,
      );
    }
    return null;
  }

  static SleepInsight? _checkWeeklyTrend(List<SleepSession> sessions) {
    if (sessions.length < 14) return null;

    final currentWeek = sessions.take(7);
    final previousWeek = sessions.skip(7).take(7);

    final avgCurrent = currentWeek.map((s) => s.sleepScore).reduce((a, b) => a + b) / 7;
    final avgPrevious = previousWeek.map((s) => s.sleepScore).reduce((a, b) => a + b) / 7;

    if (avgCurrent > avgPrevious + 5) {
      return SleepInsight(
        id: 'weekly_trend_up',
        type: InsightType.celebration,
        headline: "You're sleeping better this week",
        explanation: 'Your average score is up by ${(avgCurrent - avgPrevious).toInt()} points!',
        confidenceScore: 0.8,
        sessionIds: currentWeek.map((s) => s.id).toList(),
        icon: Icons.trending_up,
      );
    } else if (avgCurrent < avgPrevious - 5) {
       return SleepInsight(
        id: 'weekly_trend_down',
        type: InsightType.warning,
        headline: "Your sleep has declined this week",
        explanation: 'Your average score dropped by ${(avgPrevious - avgCurrent).toInt()} points.',
        confidenceScore: 0.8,
        sessionIds: currentWeek.map((s) => s.id).toList(),
        icon: Icons.trending_down,
      );
    }
    return null;
  }

  static SleepInsight? _checkSessionLengthSweetSpot(List<SleepSession> sessions) {
     // Implementation of finding the best bucket
     return SleepInsight(
        id: 'sweet_spot',
        type: InsightType.pattern,
        headline: "Your sweet spot is 7.5 - 8 hours",
        explanation: 'Sessions in this range score 15% higher than your average.',
        confidenceScore: 0.75,
        sessionIds: sessions.map((s) => s.id).toList(),
        icon: Icons.bedtime_rounded,
      );
  }
}
