import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/features/auth/presentations/screens/help_support_screen.dart';
import 'package:language_app/features/auth/presentations/screens/login_screen.dart';
import 'package:language_app/features/auth/presentations/screens/signup_screen.dart';
import 'package:language_app/features/home/presentation/screens/home_screen.dart';
import 'package:language_app/translation/presentation/screens/translate_screen.dart';
import 'package:language_app/learning/presentation/screens/lesson_screen.dart';
import 'package:language_app/learning/presentation/screens/quiz_screen.dart';
import 'package:language_app/features/auth/presentations/screens/profile_screen.dart';
import 'package:language_app/features/providers/auth_provider.dart';
import 'package:language_app/features/auth/presentations/screens/edit-profile_screen.dart';
import 'package:language_app/features/auth/presentations/screens/language_preferences_screen.dart';
import 'package:language_app/features/auth/presentations/screens/notification_settings_screen.dart';
import '../learning/data/lesson_model.dart';
import 'package:language_app/chat/presentation/screens/chat_screen.dart';
import 'package:language_app/features/home/presentation/screens/splash_screen.dart';
import 'package:language_app/features/home/presentation/screens//welcome_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => MaterialPage(
          child: const SplashScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => MaterialPage(
          child: const WelcomeScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(
          child: LoginScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => MaterialPage(
          child: SignupScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => MaterialPage(
          child: HomeScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/translate',
        pageBuilder: (context, state) => MaterialPage(
          child: const TranslateScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/lessons',
        pageBuilder: (context, state) => MaterialPage(
          child: LessonsScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/quiz',
        pageBuilder: (context, state) {
          final lesson = state.extra as Lesson?;
          if (lesson == null) {
            return MaterialPage(
              child: Scaffold(
                body: Center(
                  child: Text(
                    'No Lesson Provided',
                    style: AppTheme.textTheme.displayMedium,
                  ),
                ),
              ),
            );
          }
          return MaterialPage(
            child: QuizScreen(
              lesson: lesson, // Pass the Lesson object as extra
            ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => MaterialPage(
          child: ProfileScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) => MaterialPage(
          child: EditProfileScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/language-preferences',
        pageBuilder: (context, state) => MaterialPage(
          child: LanguagePreferencesScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/notification-settings',
        pageBuilder: (context, state) => MaterialPage(
          child: const NotificationSettingsScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/help-support',
        pageBuilder: (context, state) => MaterialPage(
          child: const HelpSupportScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) => MaterialPage(
          child: ChatScreen(),
          key: state.pageKey,
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text(
            'Page Not Found',
            style: AppTheme.textTheme.displayMedium,
          ),
        ),
      ),
    ),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authProvider);
      final loggedIn = authState.user != null;
      final isSplash = state.uri.toString() == '/splash';
      final isWelcome = state.uri.toString() == '/welcome';
      final isAuthScreen = state.uri.toString() == '/login' || state.uri.toString() == '/signup';

      // Ensure the splash screen is always shown first when the app starts
      if (isSplash) {
        return null; // Stay on the splash screen
      }

      // After the splash screen, always go to the welcome screen
      if (!isWelcome && !loggedIn && !isAuthScreen) {
        return '/welcome';
      }

      // If the user is logged in, prevent them from going to auth screens
      if (loggedIn && isAuthScreen) {
        return '/home';
      }

      return null; // No redirection needed
    },

  );
});
