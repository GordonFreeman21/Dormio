import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const background = Color(0xFF060B18); // near-black deep navy
  static const surface = Color(0xFF0D1526); // card surface
  static const surfaceElevated = Color(0xFF152035); // elevated card

  // Accents
  static const moonGlow = Color(0xFFB8C9E8); // soft steel blue — primary
  static const sleepPurple = Color(0xFF7B68EE); // medium slate purple
  static const snoreRed = Color(0xFFFF6B6B); // disturbance marker
  static const deepSleep = Color(0xFF4ECDC4); // teal — deep sleep indicator
  static const remGold = Color(0xFFFFD93D); // REM indicator

  // Text
  static const textPrimary = Color(0xFFEAEEF7);
  static const textSecondary = Color(0xFF7A8BAD);
  static const textMuted = Color(0xFF3D4F6B);

  // Gradients
  static const surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceElevated, surface],
  );

  static const arcGradient = LinearGradient(
    colors: [sleepPurple, deepSleep],
  );
}
