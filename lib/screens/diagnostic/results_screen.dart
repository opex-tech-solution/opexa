import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/confidence_row.dart';
import '../../widgets/info_widgets.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.seen, required this.onFix});
  final List<String> seen;
  final VoidCallback onFix;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Here’s what we found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            const PanelCard(title: 'Here’s what you can already do', items: kStrengths),
            const SizedBox(height: 12),
            InfoCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.visibility_outlined, size: 16, color: context.colors.textSecondary),
                  SizedBox(width: 8),
                  Text('What we saw',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 10),
                for (final s in seen)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.chevron_right, size: 14, color: context.colors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      Expanded(child: Text(s, style: const TextStyle(fontSize: 13, height: 1.3))),
                    ]),
                  ),
              ]),
            ),
            const SizedBox(height: 12),
            InfoCard(
              border: context.colors.border,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionLabel('Our best guess'),
                const SizedBox(height: 8),
                const Text('Doing the two steps in the right order',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.2)),
                const SizedBox(height: 6),
                Text('This is the block underneath. Fixing it should make 2x + 9 = 3 easier too.',
                    style: TextStyle(fontSize: 12.5, color: context.colors.textSecondary, height: 1.35)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: context.colors.background, borderRadius: BorderRadius.circular(20)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    SignalBars(2),
                    SizedBox(width: 6),
                    Text('How sure we are: Moderate',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ]),
                ),
                const SizedBox(height: 8),
                Text('Most of your answers point this way, but not all.',
                    style: TextStyle(fontSize: 11.5, color: context.colors.textSecondary)),
              ]),
            ),
            const SizedBox(height: 12),
            InfoCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SectionLabel('What else it could be'),
                SizedBox(height: 8),
                Text('Taking away into negative numbers',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('We’ll keep an eye on it.',
                    style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
              ]),
            ),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: PrimaryButton(label: 'Let’s fix it', onPressed: onFix),
      ),
    ]);
  }
}
