import 'package:flutter/material.dart';
import '../theme/widget.dart';

/// The Phone / Light / Dark control. Tapping a segment applies the theme
/// right away and saves it (see [ThemeController]).
///
///   Phone -> ThemeMode.system (follow the phone's light/dark setting)
///   Light -> ThemeMode.light
///   Dark  -> ThemeMode.dark
///
/// All colours come from [AppColors], so it looks right in both themes.
class AppearanceSelector extends StatelessWidget {
  const AppearanceSelector({super.key, this.controller});

  /// Defaults to [ThemeController.instance]. Pass one in tests.
  final ThemeController? controller;

  static const _segments = <_Segment>[
    _Segment(ThemeMode.system, 'Phone', Icons.phone_android),
    _Segment(ThemeMode.light, 'Light', Icons.wb_sunny_outlined),
    _Segment(ThemeMode.dark, 'Dark', Icons.nightlight_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = controller ?? ThemeController.instance;
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            for (final s in _segments)
              Expanded(
                child: _SegmentButton(
                  segment: s,
                  selected: themeController.mode == s.mode,
                  onTap: () => themeController.setMode(s.mode),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment {
  const _Segment(this.mode, this.label, this.icon);
  final ThemeMode mode;
  final String label;
  final IconData icon;
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final _Segment segment;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.onAccentContainer : colors.textSecondary;
    return Semantics(
      button: true,
      selected: selected,
      label: '${segment.label} appearance',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colors.accentContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(segment.icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                segment.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
