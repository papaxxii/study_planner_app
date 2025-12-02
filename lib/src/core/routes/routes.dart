import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/user_authentication/presentation/providers/user_auth_providers.dart';
import '../../features/user_authentication/presentation/state/user_auth_state.dart';
import '../../features/user_authentication/domain/entities/user_entity.dart';
import '../../features/user_authentication/presentation/screens/login_screen.dart';
import '../../features/user_authentication/presentation/screens/signup_screen.dart';
import '../../features/user_authentication/presentation/screens/profile_screen.dart';
import '../../features/task&schedule_management/presentation/screens/task_list_screen.dart';
import '../../features/task&schedule_management/presentation/screens/add_task_screen.dart';
import '../../features/reminder/presentation/screens/reminder_list_screen.dart';
import '../../features/reminder/presentation/screens/add_reminder_screen.dart';
import '../../features/progress_tracking/presentation/screens/progress_dashboard_screen.dart';
import '../../features/more/presentation/screens/more_screen.dart';
import '../../features/more/presentation/screens/calendar_screen.dart';
import '../../features/more/presentation/screens/goals_screen.dart';
import '../../features/more/presentation/screens/settings_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../widgets/bottom_nav_shell.dart';
import '../../features/admin_user_management/presentation/screens/user_list_screen.dart';
import '../../features/admin_user_management/presentation/screens/edit_user_role_screen.dart';

/// A provider that exposes a configured [GoRouter].
///
/// This router uses the `authStateProvider` to guard routes based on
/// authentication status and the user's role.
final routerProvider = Provider<GoRouter>((ref) {
  // Helper to get current auth state synchronously where needed
  AuthState currentAuth() => ref.read(authStateProvider);

  // Simple ValueNotifier refresh that increments whenever auth state changes.
  final notifier = ValueNotifier<int>(0);
  ref.listen<AuthState>(authStateProvider, (previous, next) {
    notifier.value++;
  });
  ref.onDispose(() => notifier.dispose());

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    routes: [
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/tasks',
            name: 'tasks',
            builder: (context, state) => const TaskListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'add_task',
                builder: (context, state) => const AddTaskScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/reminders',
            name: 'reminders',
            builder: (context, state) => const ReminderListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'add_reminder',
                builder: (context, state) => const AddReminderScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/goals',
            name: 'goals',
            builder: (context, state) => const GoalsScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/progress',
            name: 'progress',
            builder: (context, state) => const ProgressDashboardScreen(),
          ),
          GoRoute(
            path: '/more',
            name: 'more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/users',
        name: 'users',
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: '/users/:id/edit',
        name: 'edit_user',
        builder: (context, state) {
          final userArg = state.extra;
          if (userArg is Map && userArg['user'] != null) {
            return EditUserRoleScreen(user: userArg['user']);
          }
          // If no user passed, redirect back to user list
          return const UserListScreen();
        },
      ),
    ],
    redirect: (context, state) {
      final auth = currentAuth();
      final isLoggingIn = (state.uri.path == '/login');
      final isSigningUp = (state.uri.path == '/signup');

      // If not authenticated, send to login unless already on login or signup
      if (auth is! AuthSuccess && !isLoggingIn && !isSigningUp) {
        return '/login';
      }

      // If authenticated and trying to go to login or signup, send to dashboard
      if (auth is AuthSuccess && (isLoggingIn || isSigningUp)) {
        return '/';
      }

      // If route requires admin and user is not admin, send to dashboard
      final requiresAdmin = state.uri.path.startsWith('/users');
      if (requiresAdmin) {
        if (auth is AuthSuccess) {
          final role = auth.user.role;
          if (role != UserRole.admin) return '/';
        } else {
          return '/login';
        }
      }

      return null;
    },
  );
});

// No additional adapters required; router is refreshed via a ValueNotifier wired to auth state.
