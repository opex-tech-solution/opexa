import 'package:flutter/material.dart';
import '../on_boarding/widget.dart';

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
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Optional: Extract arguments if passing data between screens
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const OpexxaSplashScreen()); // Your splash widget
      
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      case AppRoutes.learningPath:
        return MaterialPageRoute(builder: (_) => const LearningPathScreen());

      case AppRoutes.schoolAboutYou:
        return MaterialPageRoute(builder: (_) => const SchoolAboutYouScreen());
      
      case AppRoutes.schoolCode:
        return MaterialPageRoute(builder: (_) => const SchoolCodeScreen());

      case AppRoutes.homeAboutYou:
        return MaterialPageRoute(builder: (_) => const HomeAboutYouScreen());

      case AppRoutes.homeCreateAccount:
        return MaterialPageRoute(builder: (_) => const HomeCreateAccountScreen());

      case AppRoutes.homeVerifyCode:
        return MaterialPageRoute(builder: (_) => const HomeVerifyCodeScreen());

      case AppRoutes.assessmentIntro:
        return MaterialPageRoute(builder: (_) => const AssessmentIntroScreen());

      default:
        // Error fallback route if route name doesn't exist
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
