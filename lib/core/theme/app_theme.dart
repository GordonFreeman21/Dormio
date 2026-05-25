import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.moonGlow,
        secondary: AppColors.sleepPurple,
        surface: AppColors.surface,
        error: AppColors.snoreRed,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(fontSize: 32),
        displayMedium: AppTypography.display.copyWith(fontSize: 24),
        displaySmall: AppTypography.display.copyWith(fontSize: 20),
        bodyLarge: AppTypography.body.copyWith(fontSize: 16),
        bodyMedium: AppTypography.body.copyWith(fontSize: 14),
        labelLarge: AppTypography.label.copyWith(fontSize: 14),
        labelSmall: AppTypography.label.copyWith(fontSize: 10),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
