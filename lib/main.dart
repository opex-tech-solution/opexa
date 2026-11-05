import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/routes/widget.dart';
import 'theme/widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.init();
  runApp(const OpexAApp());
}

class OpexAApp extends StatelessWidget {
  const OpexAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.maybeInstance;
    if (themeController == null) {
      return _buildApp(context, ThemeMode.system);
    }

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => _buildApp(context, themeController.mode),
    );
  }

  Widget _buildApp(BuildContext context, ThemeMode themeMode) {
    return MaterialApp.router(
      title: 'OpexA',
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(false, context),
      darkTheme: Styles.themeData(true, context),
      themeMode: themeMode,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: (isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
