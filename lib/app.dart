import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/tracking/tracking_screen.dart';
import 'ui/screens/session_detail/session_detail_screen.dart';
import 'ui/screens/insights/insights_screen.dart';
import 'ui/screens/settings/settings_screen.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';

class DormioApp extends StatelessWidget {
  final bool showOnboarding;

  const DormioApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: showOnboarding ? '/onboarding' : '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/track', builder: (context, state) => const TrackingScreen()),
        GoRoute(
          path: '/session/:id',
          builder: (context, state) => SessionDetailScreen(sessionId: state.pathParameters['id']!),
        ),
        GoRoute(path: '/insights', builder: (context, state) => const InsightsScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'Dormio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
