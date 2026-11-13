import 'package:flutter/material.dart';

import '../../../models/model.dart';

/// Displays a summary of the learner's achievements
/// when they have completed today's learning plan.
class DoneForTodayCard extends StatelessWidget {
  const DoneForTodayCard({super.key, required this.state});

  final TodayState state;

  static const _background = Color(0xFF38291D);
  static const _border = Color(0xFF5B4734);
  static const _muted = Color(0xFFE0D0BC);
  static const _blue = Color(0xFF8DBBFF);

  @override
  Widget build(BuildContext context) {
    final changes = _buildChanges(state);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 84,
              child: Image.asset(
                'assets/images/Illustration.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Done for today',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.25,
            ),
          ),

          if (changes.isNotEmpty) ...[
            const SizedBox(height: 9),

            const Text(
              'WHAT CHANGED TODAY',
              style: TextStyle(
                color: _blue,
                fontSize: 10,
                height: 1.2,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.35,
              ),
            ),

            const SizedBox(height: 6),

            for (final change in changes)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: _muted,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        change,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ] else ...[
            const SizedBox(height: 7),

            const Text(
              'You have reached a good stopping point for today.',
              style: TextStyle(color: _muted, fontSize: 12.5, height: 1.4),
            ),
          ],

          const SizedBox(height: 2),

          const Text(
            'Come back tomorrow for your next plan.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _buildChanges(TodayState state) {
    final changes = <String>[];
    final seen = <String>{};

    // Capture completed learning topics.
    for (final item in state.plan) {
      if (item.status != LessonStatus.done) continue;

      final label = _brickLabel(item.brick);
      final message = '${item.title} is now $label.';

      if (seen.add(message)) {
        changes.add(message);
      }
    }

    // Capture Core Maths map progression.
    if (state.week.blocksMovedUp.isNotEmpty ||
        state.plan.any((item) => item.status == LessonStatus.done)) {
      const message = 'One more Core Maths block in place, for every stream.';

      if (seen.add(message)) {
        changes.add(message);
      }
    }

    return changes.take(4).toList();
  }

  String _brickLabel(BrickState state) => switch (state) {
    BrickState.unchecked => 'in progress',
    BrickState.notSure => 'being reviewed',
    BrickState.building => 'Building',
    BrickState.solid => 'Solid',
    BrickState.mastered => 'Mastered',
    BrickState.lockedIn => 'Locked in',
  };
}
