import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.outlineSoft),
        ),
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.25)),
      );
}

const kStrengths = [
  'Solve one-step equations like x + 5 = 12',
  'Solve two-step equations like 3x − 4 = 11',
  'Subtract with negative numbers, like −3 − 5',
  'Take away into negative numbers, like 4 − 10',
];

class PanelCard extends StatelessWidget {
  const PanelCard({super.key, required this.title, required this.items});
  final String title;
  final List<String> items;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.panelBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: C.peach, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 8),
          for (final s in items)
            Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 6),
              child: Text(s, style: const TextStyle(fontSize: 13, height: 1.3)),
            ),
        ]),
      );
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.child, this.border});
  final Widget child;
  final Color? border;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border ?? C.outlineSoft),
        ),
        child: child,
      );
}
