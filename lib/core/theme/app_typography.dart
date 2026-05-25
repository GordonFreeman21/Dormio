import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle get display => GoogleFonts.playfairDisplay(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        color: AppColors.textPrimary,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 12,
      );

  static TextStyle get stats => GoogleFonts.jetBrainsMono(
        color: AppColors.textPrimary,
      );
}
