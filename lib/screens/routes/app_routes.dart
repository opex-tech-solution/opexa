import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/model.dart';
import '../auth/widget.dart';
import '../diagnostic/widget.dart';
import '../home/widget.dart';
import '../home/home_widget/today_store.dart';
import '../me/widget.dart';
import '../readiness/widget.dart';
import 'main_shell.dart' as main_shell;
import '../on_boarding/widget.dart';

/// Every route path in the app. Use these constants, never string literals.
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String learningPath = '/learning-path';
  static const String schoolAboutYou = '/school-about-you';
  static const String homeAboutYou = '/home-about-you';
  static const String assessmentIntro = '/assessment-intro';
  static const String homeCreateAccount = '/home-create-account';
  static const String homeVerifyCode = '/home-verify-code';
  static const String schoolCode = '/school-code';

  // authentication screens
  static const String welcomeScreen = '/welcome-screen';
  static const String forgotPasswordScreen = '/forgot-password';

  // Math diagnostic check
  static const String mathDiagnostic = '/math-diagnostic';

  // Main screens (bottom navigation). Prefixed "main" so they cannot be
  // confused with homeAboutYou / homeCreateAccount (the "home user" sign-up).
  static const String mainHome = '/main-home';
  static const String mainMap = '/main-map';
  static const String mainReadiness = '/main-readiness';
  static const String mainMe = '/main-me';
  // Children of mainHome (relative, like the other child routes below).
  static const String mainHomeNotifications = 'main-notifications';
  static const String mainHomeNotificationSettings =
      'main-home-notification-settings';
  static const String mainMeWhatOpexAKnows = 'main-what-opexa-knows';
  static const String mainMeNotificationSettings = 'main-notification-settings';
  static const String mainMeEditProfile = 'main-edit-profile';
  static const String mainMeWhatsNew = 'main-whats-new';
  static const String mainMeHelpSupport = 'main-help-support';
  static const String mainHowOpexAWorks = 'main-how-opexa-works';
  static const String mainChangePassword = 'main-change-password';
  static const String mainOurPromise = 'main-our-promise';
  static const String mainMeWhoSeesProgress = 'main-who-sees-progress';
  static const String mainMeWhatGuardianSees = 'main-what-guradian-sees';
  static const String mainReadinessScience = 'main-readiness-science';

  // Opened above the bottom bar, from the Map tab. It is a child of mainMap in
  // the router below, so its path starts with mainMap.
  static const String mathLearningList = '/main-map/learning-list';
}

/// The app's single GoRouter. Built once (static final), never inside build().
///
/// Start somewhere else while developing, without editing code:
///   flutter run --dart-define=START_AT=/math-diagnostic
///   flutter run --dart-define=START_AT=/main-map
class AppRouter {
  AppRouter._();

  static const String _startAt = String.fromEnvironment(
    'START_AT',
    defaultValue: AppRoutes.splash,
  );

  /// Root navigator: screens that must cover the bottom bar use this key.
  static final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: _startAt,
    debugLogDiagnostics: kDebugMode,

    // Replaces the old "No route defined for ..." fallback.
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri}')),
    ),

    routes: [
      // ── Existing screens ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const OpexxaSplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.learningPath,
        builder: (context, state) => const LearningPathScreen(),
      ),
      GoRoute(
        path: AppRoutes.schoolAboutYou,
        builder: (context, state) => const SchoolAboutYouScreen(),
      ),
      GoRoute(
        path: AppRoutes.schoolCode,
        builder: (context, state) => const SchoolCodeScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeAboutYou,
        builder: (context, state) => const HomeAboutYouScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeCreateAccount,
        builder: (context, state) => const HomeCreateAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeVerifyCode,
        builder: (context, state) => const HomeVerifyCodeScreen(),
      ),
      GoRoute(
        path: AppRoutes.assessmentIntro,
        builder: (context, state) => const AssessmentIntroScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.welcomeScreen,
        builder: (context, state) => const WelcomeBackScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordScreen,
        builder: (context, state) => const ResetPasswordScreen(),
      ),

      // ── Math diagnostic check ───────────────────────────────────────────
      // Open with:
      //   context.go(AppRoutes.mathDiagnostic,
      //       extra: const MathFlowArgs(userName: 'Chineche')); // extra optional
      GoRoute(
        path: AppRoutes.mathDiagnostic,
        builder: (context, state) {
          final extra = state.extra;
          final args = extra is MathFlowArgs ? extra : const MathFlowArgs();
          return MathDiagnosticScreen(
            userName: args.userName,
            onOpenMap: (ctx, openLearningList) {
              TodayStore.instance.completeFirstCheck();
              // go (not push): after the test, Back must not return into it.
              ctx.go(
                openLearningList
                    ? AppRoutes.mathLearningList
                    : AppRoutes.mainMap,
              );
            },
          );
        },
      ),

      // ── Main screens with the bottom navigation bar ─────────────────────
      // Branch ORDER = tab order. Keep it identical to MainShell._tabs.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            main_shell.MainShell(navigationShell: navigationShell),
        branches: [
          // 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mainHome,
                builder: (context, state) => HomeScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.mainHomeNotifications,
                    builder: (context, state) => const NotificationsScreen(),
                    routes: [
                      GoRoute(
                        path: AppRoutes.mainHomeNotificationSettings,
                        builder: (context, state) =>
                            const NotificationSettingsScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // 1 — Map
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mainMap,
                builder: (context, state) => MathMapScreen(
                  onOpenLearningList: (ctx) =>
                      ctx.push(AppRoutes.mathLearningList),
                ),
                routes: [
                  GoRoute(
                    // Relative to mainMap. Full path = AppRoutes.mathLearningList
                    path: 'learning-list',
                    // Show above the bottom bar, not inside the tab.
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => const MathLearningListScreen(),
                  ),
                ],
              ),
            ],
          ),
          // 2 — Readiness
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mainReadiness,
                builder: (context, state) => const ReadinessDashboardScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.mainReadinessScience,
                    builder: (context, state) => const ScienceStreamScreen(),
                  ),
                ],
              ),
            ],
          ),
          // 3 — Me
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mainMe,
                builder: (context, state) => const MeProfileScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.mainMeWhoSeesProgress,
                    builder: (context, state) =>
                        const WhoSeesMyProgressScreen(),
                    routes: [
                      GoRoute(
                        path: AppRoutes.mainMeWhatGuardianSees,
                        builder: (context, state) =>
                            const WhatGuardianSeesScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: AppRoutes.mainMeEditProfile,
                    builder: (context, state) => const EditMeProfile(),
                  ),
                  GoRoute(
                    path: AppRoutes.mainMeNotificationSettings,
                    builder: (context, state) =>
                        const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.mainMeWhatOpexAKnows,
                    builder: (context, state) => const WhatOpexAKnowsScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.mainChangePassword,
                    builder: (context, state) => const ChangePasswordScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.mainOurPromise,
                    builder: (context, state) => const OurPromisesScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.mainMeHelpSupport,
                    builder: (context, state) => const HelpSupportScreen(),
                    routes: [
                      GoRoute(
                        path: AppRoutes.mainMeWhatsNew,
                        builder: (context, state) => const WhatsNew(),
                      ),
                      GoRoute(
                        path: AppRoutes.mainHowOpexAWorks,
                        builder: (context, state) =>
                            const HowOpexAWorksScreen(),
                        routes: [
                          GoRoute(
                            path: AppRoutes.mainMeWhatOpexAKnows,
                            builder: (context, state) =>
                                const WhatOpexAKnowsScreen(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
