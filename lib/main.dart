import 'package:flutter/material.dart';
import 'screens/routes/widget.dart';
import 'theme/widget.dart';

void main() {
  runApp(const OpexAApp());
}

class OpexAApp extends StatelessWidget {
  const OpexAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OpexA',
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(false, context),
      darkTheme: Styles.themeData(true, context),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
