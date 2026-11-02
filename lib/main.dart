import 'package:flutter/material.dart';

import 'ui_implementation/common/widget.dart';
import 'ui_implementation/on_boarding/widget.dart';

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
      theme: Styles.themeData(false, context), // Light Theme
      darkTheme: Styles.themeData(true, context), // Dark Theme
      themeMode: ThemeMode.system, // Or control via your app's state
      home: const OpexaSplashScreen(),
    );
  }
}
