import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/sleep_session_provider.dart';
import '../../../providers/insights_provider.dart';
import '../../widgets/sleep_score_ring.dart';
import '../../widgets/insight_card.dart';
import '../../widgets/bottom_nav.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sleepSessionsProvider);
    final insights = ref.watch(insightsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sessions.isNotEmpty) ...[
                    _buildLastNightCard(context, sessions.first),
                    const SizedBox(height: 24),
                    _buildWeeklyChart(sessions),
                    const SizedBox(height: 24),
                  ],
                  if (insights.isNotEmpty) ...[
                    Text('Top Insight', style: AppTypography.display.copyWith(fontSize: 20)),
                    const SizedBox(height: 8),
                    InsightCard(insight: insights.first),
                    const SizedBox(height: 24),
                  ],
                  Text('Recent Sessions', style: AppTypography.display.copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  ...sessions.take(5).map((session) => _buildSessionRow(context, session)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/track'),
        backgroundColor: AppColors.sleepPurple,
        icon: const Icon(Icons.nights_stay_rounded),
        label: const Text('Sleep Now'),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppDateUtils.formatTime(DateTime.now()), style: AppTypography.stats.copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLastNightCard(BuildContext context, session) {
    return GestureDetector(
      onTap: () => context.push('/session/${session.id}'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SleepScoreRing(score: session.sleepScore, size: 120),
              const SizedBox(height: 16),
              Text(
                AppDateUtils.formatDuration(session.endTime!.difference(session.startTime)),
                style: AppTypography.display.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip('🎙 ${session.snoreEventCount} snores'),
                  _buildStatChip('🔊 ${session.averageNoiseDb.toInt()} dB avg'),
                  _buildStatChip('📅 ${session.calendarEventIds.length} events'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppTypography.label),
    );
  }

  Widget _buildWeeklyChart(List sessions) {
    final last7Sessions = sessions.take(7).toList().reversed.toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barGroups: List.generate(last7Sessions.length, (index) {
            final s = last7Sessions[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: s.sleepScore.toDouble(),
                  color: _getScoreColor(s.sleepScore),
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < last7Sessions.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(AppDateUtils.formatWeekday(last7Sessions[value.toInt()].startTime), style: AppTypography.label),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.deepSleep;
    if (score >= 60) return AppColors.moonGlow;
    if (score >= 40) return AppColors.remGold;
    return AppColors.snoreRed;
  }

  Widget _buildSessionRow(BuildContext context, session) {
    return ListTile(
      onTap: () => context.push('/session/${session.id}'),
      leading: SleepScoreRing(score: session.sleepScore, size: 40, animate: false),
      title: Text(AppDateUtils.formatFullDate(session.startTime)),
      subtitle: Text('🎙 ${session.snoreEventCount} snores · ${AppDateUtils.formatDuration(session.endTime!.difference(session.startTime))}'),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
    );
  }
}
