import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location.startsWith('/insights')) {
      currentIndex = 1;
    } else if (location.startsWith('/settings')) {
      currentIndex = 2;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.moonGlow,
      unselectedItemColor: AppColors.textMuted,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      onTap: (index) {
        switch (index) {
          case 0: context.go('/'); break;
          case 1: context.go('/insights'); break;
          case 2: context.go('/settings'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: 'Insights'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
      ],
    );
  }
}
