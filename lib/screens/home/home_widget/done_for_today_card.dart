import 'package:flutter/material.dart';

import '../../../models/model.dart';
import '../../../theme/widget.dart';
import '../../../widgets/widget.dart';

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
          const Center(child: _RestIllustration()),
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

/// A drawn stand-in for the artwork (blocks and a cup). Swap for an
/// Image.asset when you have the final illustration.
class _RestIllustration extends StatelessWidget {
  const _RestIllustration();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    Widget tile(IconData icon, double size, {Color? fill}) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill ?? c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.divider),
      ),
      child: Icon(icon, size: size * 0.5, color: c.accent),
    );

    return SizedBox(
      width: 230,
      height: 118,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 96,
            decoration: BoxDecoration(
              color: c.accentContainer,
              borderRadius: BorderRadius.circular(48),
            ),
          ),
          Positioned(left: 28, top: 10, child: tile(Icons.auto_awesome, 34)),
          Positioned(right: 52, top: 4, child: tile(Icons.coffee_outlined, 54)),
          Positioned(
            right: 14,
            top: 36,
            child: tile(Icons.star_outline, 34, fill: c.brickLocked),
          ),
          const Positioned(
            left: 64,
            bottom: 12,
            child: BrickFace(BrickState.solid, width: 64, height: 26),
          ),
          const Positioned(
            left: 92,
            bottom: 38,
            child: BrickFace(BrickState.solid, width: 52, height: 24),
          ),
          const Positioned(
            right: 70,
            bottom: 12,
            child: BrickFace(BrickState.mastered, width: 54, height: 26),
          ),
        ],
      ),
    );
  }
}
