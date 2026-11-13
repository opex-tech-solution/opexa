import 'package:flutter/material.dart';

import '../../../models/model.dart';

/// A warm completion summary shown when the learner has finished today's plan.
///
/// The visual treatment follows the supplied Home-screen reference: a deep
/// cocoa card, compact learning illustration, clear heading and a short list
/// of progress changes from the learner's completed plan.
class DoneForTodayCard extends StatelessWidget {
  const DoneForTodayCard({super.key, required this.state});

  final TodayState state;

  static const _background = Color(0xFF38291D);
  static const _border = Color(0xFF5B4734);
  static const _muted = Color(0xFFE0D0BC);
  static const _blue = Color(0xFF8DBBFF);
  static const _blueDeep = Color(0xFF4D82D1);

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
          const Center(child: _DoneIllustration()),
          const SizedBox(height: 5),
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

    // Completed plan items are the source of truth for topic-level updates.
    for (final item in state.plan) {
      if (item.status != LessonStatus.done) continue;
      final label = _brickLabel(item.brick);
      final message = '${item.title} is now $label.';
      if (seen.add(message)) changes.add(message);
    }

    // A moved-up block is a separate map-level achievement, not another
    // duplicate of a completed lesson.
    if (state.week.blocksMovedUp.isNotEmpty) {
      const message =
          'One more Core Maths block in place, for every stream.';
      if (seen.add(message)) changes.add(message);
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

class _DoneIllustration extends StatelessWidget {
  const _DoneIllustration();

  static const _artBackground = Color(0xFF4B3928);
  static const _tileBlue = Color(0xFF8DBBFF);
  static const _tileBlueDeep = Color(0xFF4D82D1);
  static const _tileDark = Color(0xFF30271F);
  static const _line = Color(0xFFBDA68C);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 84,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 65,
            decoration: BoxDecoration(
              color: _artBackground,
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          Positioned(
            left: 30,
            top: 9,
            child: Transform.rotate(
              angle: -0.18,
              child: _iconTile(Icons.auto_awesome, 25),
            ),
          ),
          Positioned(
            right: 30,
            top: 6,
            child: Transform.rotate(
              angle: 0.12,
              child: _iconTile(Icons.coffee_outlined, 31),
            ),
          ),
          Positioned(
            right: 14,
            top: 40,
            child: Transform.rotate(
              angle: 0.18,
              child: _iconTile(Icons.star_outline, 23),
            ),
          ),
          const Positioned(
            left: 54,
            bottom: 8,
            child: _MathTile(width: 27, height: 15, color: _tileBlue),
          ),
          const Positioned(
            left: 80,
            bottom: 8,
            child: _MathTile(width: 27, height: 15, color: _tileBlueDeep),
          ),
          const Positioned(
            left: 67,
            bottom: 25,
            child: _MathTile(width: 27, height: 15, color: _tileBlue),
          ),
          const Positioned(
            left: 75,
            top: 1,
            child: _SparkDot(color: _tileBlue),
          ),
          const Positioned(
            left: 19,
            top: 23,
            child: _SparkDot(color: _line),
          ),
          const Positioned(
            right: 18,
            bottom: 13,
            child: _SparkDot(color: _line),
          ),
        ],
      ),
    );
  }

  Widget _iconTile(IconData icon, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: _tileDark,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: _line.withValues(alpha: 0.45)),
    ),
    child: Icon(icon, size: size * 0.58, color: const Color(0xFFF4E7D7)),
  );
}

class _MathTile extends StatelessWidget {
  const _MathTile({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
    ),
  );
}

class _SparkDot extends StatelessWidget {
  const _SparkDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
