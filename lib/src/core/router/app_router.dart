import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/permissions_screen.dart';
import '../../features/profile_analysis/presentation/profile_input_screen.dart';
import '../../features/profile_analysis/presentation/dashboard_screen.dart';
import '../../features/profile_analysis/presentation/headline_analysis_screen.dart';
import '../constants/app_constants.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: AppConstants.routeWelcome,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // Initial welcome screen
      GoRoute(
        path: AppConstants.routeWelcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Permissions screen
      GoRoute(
        path: AppConstants.routePermissions,
        name: 'permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),

      // Profile input screen
      GoRoute(
        path: AppConstants.routeProfileInput,
        name: 'profileInput',
        builder: (context, state) => const ProfileInputScreen(),
      ),

      // Dashboard screen
      GoRoute(
        path: AppConstants.routeDashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Headline analysis screen
      GoRoute(
        path: AppConstants.routeAnalysis,
        name: 'analysis',
        builder: (context, state) => const HeadlineAnalysisScreen(),
      ),
    ],

    // Redirect logic for auth and onboarding
    redirect: (BuildContext context, GoRouterState state) async {
      // Check if user has completed onboarding
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding =
          prefs.getBool('has_completed_onboarding') ?? false;

      // If not on an onboarding route and hasn't completed onboarding, redirect to welcome
      final isOnboardingRoute =
          state.matchedLocation == AppConstants.routeWelcome ||
          state.matchedLocation == AppConstants.routePermissions;

      if (!hasCompletedOnboarding && !isOnboardingRoute) {
        return AppConstants.routeWelcome;
      }

      // No redirect needed
      return null;
    },

    // Error handling
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Page not found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(AppConstants.routeWelcome),
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
  );
}
