import 'package:flutter/material.dart';
import 'screens/routes/widget.dart';
import 'theme/widget.dart';

/// Lets you jump straight into the math diagnostic while building/debugging,
/// without going through splash and onboarding:
///
///   flutter run --dart-define=START_AT_MATH=true
///
/// A normal `flutter run` (or a release build) still starts at the splash.
const bool _startAtMath = bool.fromEnvironment('START_AT_MATH');

void main() {
  runApp(const OpexAApp());
}

class OpexAApp extends StatelessWidget {
  const OpexAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpexA',
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(false, context),
      darkTheme: Styles.themeData(true, context),
      themeMode: ThemeMode.system,

      // Entry point of the app.
      initialRoute: _startAtMath ? AppRoutes.mathDiagnostic : AppRoutes.splash,

      onGenerateInitialRoutes: (String initialRoute) => [
        RouteGenerator.generateRoute(RouteSettings(name: initialRoute)),
      ],

      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}