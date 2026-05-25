import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/insights_provider.dart';
import '../../widgets/insight_card.dart';
import '../../widgets/bottom_nav.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final insights = ref.watch(insightsProvider);
    final filteredInsights = _selectedFilter == 'All'
        ? insights
        : insights.where((i) => i.type.name.toLowerCase() == _selectedFilter.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Patterns', style: AppTypography.display.copyWith(fontSize: 24)),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: filteredInsights.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredInsights.length,
                  itemBuilder: (context, index) => InsightCard(insight: filteredInsights[index]),
                ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Calendar', 'Snore', 'Trends'];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = filter);
              },
              selectedColor: AppColors.sleepPurple,
              backgroundColor: AppColors.surfaceElevated,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insights_rounded, size: 80, color: AppColors.textMuted),
            const SizedBox(height: 24),
            Text(
              'Not enough data yet',
              style: AppTypography.display.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep tracking your sleep. Dormio needs at least 3 sessions to find patterns.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
