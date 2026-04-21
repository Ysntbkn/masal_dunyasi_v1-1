import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievements/achievements_screen.dart';
import '../../features/auth/avatar_selection_screen.dart';
import '../../features/auth/loading_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/name_input_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/categories/category_detail_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/premium/premium_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/sleep/sleep_screen.dart';
import '../../features/story/audio_player_screen.dart';
import '../../features/story/reading_screen.dart';
import '../../features/story/story_detail_screen.dart';
import '../../features/trial/trial_screen.dart';
import '../../features/watch/watch_screen.dart';
import '../../shared/widgets/app_shell.dart';
import '../state/app_state.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorHomeKey = GlobalKey<NavigatorState>();
final shellNavigatorSleepKey = GlobalKey<NavigatorState>();
final shellNavigatorWatchKey = GlobalKey<NavigatorState>();
final shellNavigatorLibraryKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AppState appState) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    refreshListenable: appState,
    redirect: (context, state) {
      final path = state.uri.path;
      final isLogin = path == AppRoutes.login;
      final isOnboarding =
          path == AppRoutes.name ||
          path == AppRoutes.avatar ||
          path == AppRoutes.trial ||
          path == AppRoutes.loading;

      if (!appState.hasSession) {
        return isLogin ? null : AppRoutes.login;
      }

      if (!appState.onboardingComplete) {
        if (isLogin) return AppRoutes.name;
        return isOnboarding ? null : AppRoutes.name;
      }

      if (isLogin || isOnboarding) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.name,
        name: 'onboarding-name',
        builder: (context, state) => const NameInputScreen(),
      ),
      GoRoute(
        path: AppRoutes.avatar,
        name: 'onboarding-avatar',
        builder: (context, state) => const AvatarSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.trial,
        name: 'onboarding-trial',
        builder: (context, state) => const TrialScreen(),
      ),
      GoRoute(
        path: AppRoutes.loading,
        name: 'onboarding-loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorSleepKey,
            routes: [
              GoRoute(
                path: AppRoutes.sleep,
                name: 'sleep',
                builder: (context, state) => const SleepScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorWatchKey,
            routes: [
              GoRoute(
                path: AppRoutes.watch,
                name: 'watch',
                builder: (context, state) => const WatchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorLibraryKey,
            routes: [
              GoRoute(
                path: AppRoutes.library,
                name: 'library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.storyDetail,
        name: 'story-detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return StoryDetailScreen(storyId: state.pathParameters['storyId']!);
        },
      ),
      GoRoute(
        path: AppRoutes.reading,
        name: 'reading',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return ReadingScreen(storyId: state.pathParameters['storyId']!);
        },
      ),
      GoRoute(
        path: AppRoutes.audioPlayer,
        name: 'audio-player',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AudioPlayerScreen(),
      ),
      GoRoute(
        path: AppRoutes.categories,
        name: 'categories',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: AppRoutes.categoryDetail,
        name: 'category-detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return CategoryDetailScreen(
            categoryId: state.pathParameters['categoryId']!,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.achievements,
        name: 'achievements',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.premium,
        name: 'premium',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: AppRoutes.storyTrial,
        name: 'trial',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return TrialScreen(storyId: state.pathParameters['storyId']);
        },
      ),
    ],
  );
}
