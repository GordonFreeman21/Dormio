import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/sleep_session_provider.dart';
import '../../widgets/bottom_nav.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Recording'),
          _buildSwitchTile('Record full night audio', true, (v) {}),
          _buildSwitchTile('Auto-start at bedtime', false, (v) {}),
          ListTile(
            title: const Text('Snore Sensitivity'),
            subtitle: const Text('Medium'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          _buildSectionHeader('Calendar'),
          _buildSwitchTile('Connect Calendars', true, (v) {}),
          ListTile(
            title: const Text('Manage Calendars'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          _buildSectionHeader('Data'),
          ListTile(
            title: const Text('Storage Used'),
            trailing: const Text('142 MB', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ListTile(
            title: const Text('Export Data (JSON)'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Clear All Sessions', style: TextStyle(color: AppColors.snoreRed)),
            onTap: () => _showClearDialog(context, ref),
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.label.copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.sleepPurple,
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text('This will permanently delete all your sleep sessions and insights.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(sleepSessionsProvider.notifier).state = []; // Quick UI clear
              ref.read(sleepRepositoryProvider).clearAll();
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: AppColors.snoreRed)),
          ),
        ],
      ),
    );
  }
}
