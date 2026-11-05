import 'package:flutter/material.dart';

/// The app's colours, named by PURPOSE (not by shade), in a dark and a light set.
///
/// Use them from any build method:
///
///   color: context.colors.surface
///   style: TextStyle(color: context.colors.textSecondary)
///
/// No `isDark ? a : b` is needed: the right set is chosen by the active theme
/// (Phone / Light / Dark, see [ThemeController]). Add a new colour here ONCE,
/// with both values, and every screen can use it.
///
/// Registered on the ThemeData in Styles.themeData as a ThemeExtension, so
/// switching theme fades smoothly between the two sets ([lerp]).
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceInset,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.onAccent,
    required this.accentContainer,
    required this.onAccentContainer,
    required this.disabledFill,
    required this.disabledText,
    required this.panel,
    required this.panelBorder,
    required this.band,
    required this.brickBuilding,
    required this.brickSolid,
    required this.brickSolidEdge,
    required this.brickLocked,
  });

  /// Page background (Scaffold).
  final Color background;

  /// Cards, grouped lists, option rows, segmented tracks.
  final Color surface;

  /// Recessed chips and tags.
  final Color surfaceInset;

  /// Borders of interactive rows and inputs.
  final Color border;

  /// Hairlines, separators, quiet borders.
  final Color divider;

  /// Main text.
  final Color textPrimary;

  /// Supporting text, idle icons.
  final Color textSecondary;

  /// Brand blue: buttons, links, selected borders, progress.
  final Color accent;

  /// Text/icons placed on [accent].
  final Color onAccent;

  /// Selected state fill (segments, option rows, nav pill).
  final Color accentContainer;

  /// Text/icons placed on [accentContainer].
  final Color onAccentContainer;

  /// Disabled button fill.
  final Color disabledFill;

  /// Disabled button text.
  final Color disabledText;

  /// Orange callout card.
  final Color panel;

  /// Border of the orange callout card.
  final Color panelBorder;

  /// "Your class" band behind the skill bricks.
  final Color band;

  /// Skill brick: building.
  final Color brickBuilding;

  /// Skill brick: solid / mastered.
  final Color brickSolid;

  /// Skill brick: bottom edge.
  final Color brickSolidEdge;

  /// Skill brick: locked in.
  final Color brickLocked;

  static const dark = AppColors(
    background: Color(0xFF241A10),
    surface: Color(0xFF382D24),
    surfaceInset: Color(0xFF2A2017),
    border: Color(0xFF7D6C5A),
    divider: Color(0xFF4A3727),
    textPrimary: Color(0xFFF6EEE6),
    textSecondary: Color(0xFFBBAE9F),
    accent: Color(0xFF7EB2FC),
    onAccent: Color(0xFF0F1E38),
    accentContainer: Color(0xFF2C394B),
    onAccentContainer: Color(0xFFF6EEE6),
    disabledFill: Color(0xFF45546F),
    disabledText: Color(0xFF9AA3B5),
    panel: Color(0xFF4B2B11),
    panelBorder: Color(0xFF8C5120),
    band: Color(0xFF2E3037),
    brickBuilding: Color(0xFF2F66E8),
    brickSolid: Color(0xFF7EB2FC),
    brickSolidEdge: Color(0xFF5B8BDB),
    brickLocked: Color(0xFFF4CDB8),
  );

  static const light = AppColors(
    background: Color(0xFFF5EEEC),
    surface: Color(0xFFFFFFFF),
    surfaceInset: Color(0xFFEEE7E4),
    border: Color(0xFFB8AAA3),
    divider: Color(0xFFDCD2CE),
    textPrimary: Color(0xFF1A1A2E),
    textSecondary: Color(0xFF6E625C),
    accent: Color(0xFF2D58A2),
    onAccent: Color(0xFFFFFFFF),
    accentContainer: Color(0xFFE3EDFD),
    onAccentContainer: Color(0xFF1F4380),
    disabledFill: Color(0xFFD9DDE6),
    disabledText: Color(0xFF9AA1B0),
    panel: Color(0xFFFFE8D2),
    panelBorder: Color(0xFFDDA066),
    band: Color(0xFFEAE1DD),
    brickBuilding: Color(0xFF2F66E8),
    brickSolid: Color(0xFF7EB2FC),
    brickSolidEdge: Color(0xFF5B8BDB),
    brickLocked: Color(0xFFF4CDB8),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceInset,
    Color? border,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
    Color? onAccent,
    Color? accentContainer,
    Color? onAccentContainer,
    Color? disabledFill,
    Color? disabledText,
    Color? panel,
    Color? panelBorder,
    Color? band,
    Color? brickBuilding,
    Color? brickSolid,
    Color? brickSolidEdge,
    Color? brickLocked,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceInset: surfaceInset ?? this.surfaceInset,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentContainer: accentContainer ?? this.accentContainer,
      onAccentContainer: onAccentContainer ?? this.onAccentContainer,
      disabledFill: disabledFill ?? this.disabledFill,
      disabledText: disabledText ?? this.disabledText,
      panel: panel ?? this.panel,
      panelBorder: panelBorder ?? this.panelBorder,
      band: band ?? this.band,
      brickBuilding: brickBuilding ?? this.brickBuilding,
      brickSolid: brickSolid ?? this.brickSolid,
      brickSolidEdge: brickSolidEdge ?? this.brickSolidEdge,
      brickLocked: brickLocked ?? this.brickLocked,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceInset: Color.lerp(surfaceInset, other.surfaceInset, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentContainer: Color.lerp(accentContainer, other.accentContainer, t)!,
      onAccentContainer: Color.lerp(onAccentContainer, other.onAccentContainer, t)!,
      disabledFill: Color.lerp(disabledFill, other.disabledFill, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      panelBorder: Color.lerp(panelBorder, other.panelBorder, t)!,
      band: Color.lerp(band, other.band, t)!,
      brickBuilding: Color.lerp(brickBuilding, other.brickBuilding, t)!,
      brickSolid: Color.lerp(brickSolid, other.brickSolid, t)!,
      brickSolidEdge: Color.lerp(brickSolidEdge, other.brickSolidEdge, t)!,
      brickLocked: Color.lerp(brickLocked, other.brickLocked, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  /// The colours for the active theme. See [AppColors].
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppColors.dark
          : AppColors.light);
}
