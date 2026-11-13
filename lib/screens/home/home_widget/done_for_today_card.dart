import 'package:flutter/material.dart';

import '../../../theme/widget.dart';

/// Shown instead of "Next up" when the learner took the day off.
class DoneForTodayCard extends StatelessWidget {
  const DoneForTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset('assets/images/Illustration.png')),
          const SizedBox(height: 18),
          const Text(
            'Done for today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'You took today off. That’s fine.',
            style: TextStyle(fontSize: 14, height: 1.4, color: c.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Come back tomorrow for your next plan.',
            style: TextStyle(fontSize: 14, height: 1.4, color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}
