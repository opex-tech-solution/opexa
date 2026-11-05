// styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    // The single source of truth for colours. Screens read the same values
    // with context.colors; this file feeds them into Flutter's own widgets.
    final colors = isDarkTheme ? AppColors.dark : AppColors.light;
    final brightness = isDarkTheme ? Brightness.dark : Brightness.light;

    // Flutter's Material 3 widgets (dialogs, menus, dropdowns, switches, text
    // fields, progress bars...) take their colours from the ColorScheme. Without
    // one they fall back to Flutter's default purple, so we set it from the
    // palette. The "surfaceContainer" roles tint dialogs, menus and sheets.
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xff2D58A2),
      brightness: brightness,
    ).copyWith(
      primary: colors.accent,
      onPrimary: colors.onAccent,
      surface: colors.background,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.border,
      outlineVariant: colors.divider,
      surfaceContainerLowest: colors.background,
      surfaceContainerLow: colors.surface,
      surfaceContainer: colors.surface,
      surfaceContainerHigh: colors.surface,
      surfaceContainerHighest: colors.surfaceInset,
    );

    return ThemeData(
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: const Color(0xff2D58A2),
      scaffoldBackgroundColor: colors.background,
      cardColor: isDarkTheme ? const Color(0xFF322418) : Colors.white,
      hoverColor: isDarkTheme
          ? const Color(0xFF3E2E20)
          : const Color(0xFFEBE2DE),
      canvasColor: const Color(0xFF7EB2FC),
      shadowColor: isDarkTheme ? const Color(0xFF7EB2FC) : const Color(0xFF2D58A2),
      splashColor: isDarkTheme
          ? const Color(0xFFBAD0F4)
          : const Color(0xFF2D58A2),
      hintColor: isDarkTheme ? const Color(0xFFE3E3E3) : Colors.black,
      brightness: brightness,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black87,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
        ),
        bodySmall: TextStyle(
          color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
        ),
        labelLarge: TextStyle(
          color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
        ),
        labelMedium: TextStyle(
          color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
        ),
        labelSmall: TextStyle(
          color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
        ),
        bodyMedium: TextStyle(
          color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
        ),
      ),
      dividerColor: colors.divider,
      // Dividers use the theme colour unless a screen overrides it.
      dividerTheme: DividerThemeData(color: colors.divider),
    );
  }
}
