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
    required this.brickMastered,
    required this.onBrickMastered,
    required this.brickNeutral,
    required this.brickNeutralBorder,
    required this.trackFoundation,
    required this.onTrackFoundation,
    required this.trackClass,
    required this.onTrackClass,
    required this.trackStretch,
    required this.onTrackStretch,
  });

  /// Page background (Scaffold).
  final Color background;

  /// Cards, grouped lists, option rows, segmented tracks.
  final Color surface;

  /// Recessed chips, tags, empty day boxes.
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

  /// Selected / tinted fill (segments, nav pill, "Done" chip, list icon tile).
  final Color accentContainer;

  /// Text/icons placed on [accentContainer].
  final Color onAccentContainer;

  /// Disabled button fill.
  final Color disabledFill;

  /// Disabled button text.
  final Color disabledText;

  /// Warm callout fill (offline banner, "not sure" brick, orange card).
  final Color panel;

  /// Warm border / bell badge / warm accents.
  final Color panelBorder;

  /// "Your class" band behind the skill bricks.
  final Color band;

  /// Skill brick: building (lower part).
  final Color brickBuilding;

  /// Skill brick: solid.
  final Color brickSolid;

  /// Skill brick: bottom edge.
  final Color brickSolidEdge;

  /// Skill brick: locked in.
  final Color brickLocked;

  /// Skill brick: mastered.
  final Color brickMastered;

  /// Star on a mastered brick.
  final Color onBrickMastered;

  /// Skill brick: not checked / top of a building brick.
  final Color brickNeutral;

  /// Border of a not-checked brick.
  final Color brickNeutralBorder;

  /// Foundation track badge fill.
  final Color trackFoundation;

  /// Icon on the Foundation badge.
  final Color onTrackFoundation;

  /// Class track badge fill.
  final Color trackClass;

  /// Icon on the Class badge.
  final Color onTrackClass;

  /// Stretch track badge fill.
  final Color trackStretch;

  /// Icon on the Stretch badge.
  final Color onTrackStretch;

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
    brickMastered: Color(0xFFB3CCF5),
    onBrickMastered: Color(0xFF0F1E38),
    brickNeutral: Color(0xFF382D24),
    brickNeutralBorder: Color(0xFF7D6C5A),
    trackFoundation: Color(0xFF45403F),
    onTrackFoundation: Color(0xFFC8D0DE),
    trackClass: Color(0xFF56361A),
    onTrackClass: Color(0xFFEADCCB),
    trackStretch: Color(0xFF4C3756),
    onTrackStretch: Color(0xFFC3AEE3),
  );

  static const light = AppColors(
    background: Color(0xFFF5EEEC),
    surface: Color(0xFFFFFFFF),
    surfaceInset: Color(0xFFEBE0DD),
    border: Color(0xFFB8AAA3),
    divider: Color(0xFFE3D9D5),
    textPrimary: Color(0xFF372D23),
    textSecondary: Color(0xFF55555A),
    accent: Color(0xFF2D58A2),
    onAccent: Color(0xFFFFFFFF),
    accentContainer: Color(0xFFE4EAF6),
    onAccentContainer: Color(0xFF2D58A2),
    disabledFill: Color(0xFFD9DDE6),
    disabledText: Color(0xFF9AA1B0),
    panel: Color(0xFFF6D8C6),
    panelBorder: Color(0xFFA05A22),
    band: Color(0xFFEAE1DD),
    brickBuilding: Color(0xFF1E72FC),
    brickSolid: Color(0xFF1E72FC),
    brickSolidEdge: Color(0xFF1558C8),
    brickLocked: Color(0xFFF4CDB8),
    brickMastered: Color(0xFF2A54A2),
    onBrickMastered: Color(0xFFFFFFFF),
    brickNeutral: Color(0xFFE4DED8),
    brickNeutralBorder: Color(0xFF8C7B73),
    trackFoundation: Color(0xFFE4EAF6),
    onTrackFoundation: Color(0xFF2D58A2),
    trackClass: Color(0xFFF8DFCB),
    onTrackClass: Color(0xFF9A5420),
    trackStretch: Color(0xFFE8E2F7),
    onTrackStretch: Color(0xFF6A4FB8),
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
    Color? brickMastered,
    Color? onBrickMastered,
    Color? brickNeutral,
    Color? brickNeutralBorder,
    Color? trackFoundation,
    Color? onTrackFoundation,
    Color? trackClass,
    Color? onTrackClass,
    Color? trackStretch,
    Color? onTrackStretch,
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
      brickMastered: brickMastered ?? this.brickMastered,
      onBrickMastered: onBrickMastered ?? this.onBrickMastered,
      brickNeutral: brickNeutral ?? this.brickNeutral,
      brickNeutralBorder: brickNeutralBorder ?? this.brickNeutralBorder,
      trackFoundation: trackFoundation ?? this.trackFoundation,
      onTrackFoundation: onTrackFoundation ?? this.onTrackFoundation,
      trackClass: trackClass ?? this.trackClass,
      onTrackClass: onTrackClass ?? this.onTrackClass,
      trackStretch: trackStretch ?? this.trackStretch,
      onTrackStretch: onTrackStretch ?? this.onTrackStretch,
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
      brickMastered: Color.lerp(brickMastered, other.brickMastered, t)!,
      onBrickMastered: Color.lerp(onBrickMastered, other.onBrickMastered, t)!,
      brickNeutral: Color.lerp(brickNeutral, other.brickNeutral, t)!,
      brickNeutralBorder: Color.lerp(brickNeutralBorder, other.brickNeutralBorder, t)!,
      trackFoundation: Color.lerp(trackFoundation, other.trackFoundation, t)!,
      onTrackFoundation: Color.lerp(onTrackFoundation, other.onTrackFoundation, t)!,
      trackClass: Color.lerp(trackClass, other.trackClass, t)!,
      onTrackClass: Color.lerp(onTrackClass, other.onTrackClass, t)!,
      trackStretch: Color.lerp(trackStretch, other.trackStretch, t)!,
      onTrackStretch: Color.lerp(onTrackStretch, other.onTrackStretch, t)!,
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
