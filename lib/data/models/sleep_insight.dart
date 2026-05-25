import 'package:flutter/material.dart';

class SleepInsight {
  final String id;
  final InsightType type;
  final String headline; // "Early meetings wreck your sleep"
  final String explanation; // longer body text
  final double confidenceScore; // 0.0–1.0
  final List<String> sessionIds; // which sessions back this up
  final IconData icon;

  SleepInsight({
    required this.id,
    required this.type,
    required this.headline,
    required this.explanation,
    required this.confidenceScore,
    required this.sessionIds,
    required this.icon,
  });
}

enum InsightType { calendar, pattern, snore, streak, warning, celebration }
