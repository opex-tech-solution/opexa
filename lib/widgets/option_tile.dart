import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.text,
    this.letter,
    this.icon,
    this.selected = false,
    this.loading = false,
    this.onTap,
  });
  final String text;
  final String? letter;
  final IconData? icon;
  final bool selected;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    Widget leading;
    if (selected) {
      leading = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: C.primary, borderRadius: BorderRadius.circular(6)),
        child: const Icon(Icons.check, size: 15, color: C.onPrimary),
      );
    } else if (letter != null) {
      leading = Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: C.outline),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(letter!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
      );
    } else {
      leading = Icon(icon ?? Icons.help_outline, size: 18, color: C.muted);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? C.selected : C.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: selected ? C.primary : C.outline),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                  child: Text(text,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600))),
              if (loading)
                const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: C.primary)),
            ]),
          ),
        ),
      ),
    );
  }
}
