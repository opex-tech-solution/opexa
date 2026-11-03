// styles.dart
import 'package:flutter/material.dart';

abstract class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: const Color(0xff2D58A2),
      scaffoldBackgroundColor: isDarkTheme
          ? const Color(0xFF241A10) // Custom Dark mode scaffold background
          : const Color(0xFFF5EEEC), // Custom Light mode scaffold background
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
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme
            ? const Color(0xFF241A10)
            : const Color(0xFFF5EEEC),
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
      dividerColor: isDarkTheme
          ? const Color(0xFF4A3727)
          : const Color(0xFFDCD2CE),
    );
  }
}
