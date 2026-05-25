import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/sleep_insight.dart';

class InsightCard extends StatelessWidget {
  final SleepInsight insight;

  const InsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.moonGlow.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(insight.icon, color: _getColor(), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.headline,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.explanation,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: insight.confidenceScore,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (insight.type) {
      case InsightType.calendar: return AppColors.sleepPurple;
      case InsightType.snore: return AppColors.snoreRed;
      case InsightType.warning: return Colors.orange;
      case InsightType.celebration: return AppColors.deepSleep;
      default: return AppColors.moonGlow;
    }
  }
}
