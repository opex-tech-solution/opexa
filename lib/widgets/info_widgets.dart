import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(
            fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1, color: context.colors.textSecondary),
      );
}

class InfoBanner extends StatelessWidget {
  const InfoBanner(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.info_outline, size: 14, color: context.colors.textSecondary),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(fontSize: 11.5, color: context.colors.textSecondary))),
        ]),
      );
}

class ToastPill extends StatelessWidget {
  const ToastPill(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(color: context.colors.textPrimary, borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: TextStyle(color: context.colors.background, fontSize: 12, fontWeight: FontWeight.w700)),
      );
}
