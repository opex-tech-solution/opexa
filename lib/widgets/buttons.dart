import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: context.colors.accent,
          foregroundColor: context.colors.onAccent,
          disabledBackgroundColor: context.colors.disabledFill,
          disabledForegroundColor: context.colors.disabledText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        child: Text(label),
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({super.key, required this.label, this.onPressed, this.icon, this.color});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      foregroundColor: color ?? context.colors.textPrimary,
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
    );
    if (icon != null) {
      return TextButton.icon(
          onPressed: onPressed, style: style, icon: Icon(icon, size: 16), label: Text(label));
    }
    return TextButton(onPressed: onPressed, style: style, child: Text(label));
  }
}
