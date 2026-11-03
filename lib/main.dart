import 'package:flutter/material.dart';
import 'ui_implementation/common/widget.dart';

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
      
      // Integrating your custom dark/light theme definitions[cite: 2]
      theme: Styles.themeData(false, context),
      darkTheme: Styles.themeData(true, context),
      themeMode: ThemeMode.system, 

      // Set the initial entry point of your app
      initialRoute: AppRoutes.splash,

      // Hook up your centralized route generator
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
