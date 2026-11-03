import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../theme/app_colors.dart';
import 'buttons.dart';
import 'info_widgets.dart';

class BrickFace extends StatelessWidget {
  const BrickFace(this.state, {super.key, this.width = 76, this.height = 40});
  final BrickState state;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(6);
    final fs = height * 0.42;
    switch (state) {
      case BrickState.unchecked:
      case BrickState.notSure:
        return Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: r,
            border: Border.all(color: C.outline),
          ),
          child: Text(
            state == BrickState.unchecked ? '?' : '···',
            style: TextStyle(
              fontSize: fs,
              fontWeight: FontWeight.w800,
              color: C.muted,
            ),
          ),
        );
      case BrickState.building:
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: r,
            border: Border.all(color: C.outline, width: 1),
          ),
          child: ClipRRect(
            borderRadius: r,
            child: Column(
              children: [
                Expanded(flex: 2, child: Container(color: C.surface)),
                Expanded(flex: 3, child: Container(color: C.building)),
              ],
            ),
          ),
        );
      case BrickState.solid:
      case BrickState.mastered:
      case BrickState.lockedIn:
        final locked = state == BrickState.lockedIn;
        return Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: locked ? C.peach : C.primary,
            borderRadius: r,
            boxShadow: [
              BoxShadow(
                color: locked ? const Color(0xFFC9A28C) : C.solidEdge,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: state == BrickState.mastered
              ? Icon(Icons.star, size: fs, color: C.bg)
              : locked
              ? Icon(
                  Icons.lock_outline,
                  size: fs,
                  color: const Color(0xFF7A4A33),
                )
              : null,
        );
    }
  }
}

class Brick extends StatelessWidget {
  const Brick(this.skill, {super.key, this.highlighted = false});
  final Skill skill;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    Widget face = Stack(
      clipBehavior: Clip.none,
      children: [
        BrickFace(skill.state),
        if (skill.trending)
          Positioned(
            top: -7,
            right: -5,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: C.bg,
                shape: BoxShape.circle,
                border: Border.all(color: C.outline),
              ),
              child: const Icon(Icons.trending_up, size: 11, color: C.text),
            ),
          ),
      ],
    );
    if (highlighted) {
      face = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: C.text, width: 2),
        ),
        child: face,
      );
    }
    return SizedBox(
      width: 84,
      child: Column(
        children: [
          face,
          const SizedBox(height: 6),
          Text(
            skill.name,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: const TextStyle(fontSize: 10, color: C.muted, height: 1.15),
          ),
        ],
      ),
    );
  }
}

class SkillWall extends StatelessWidget {
  const SkillWall({super.key, required this.data, this.highlight});
  final WallData data;
  final String? highlight;

  Widget _section(
    String title,
    String sub,
    List<List<Skill>> rows, {
    bool stagger = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SectionLabel(title),
            const Spacer(),
            Text(sub, style: const TextStyle(fontSize: 11, color: C.muted)),
          ],
        ),
        const SizedBox(height: 10),
        for (var r = 0; r < rows.length; r++)
          Padding(
            padding: EdgeInsets.only(
              bottom: 10,
              left: stagger && r == 1 ? 44 : 0,
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                for (final s in rows[r])
                  Brick(s, highlighted: s.name == highlight),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _section('Stretch', 'Blocks above your class', data.stretch),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: C.classPanel,
            borderRadius: BorderRadius.circular(14),
          ),
          child: _section('Your class', 'JSS2 blocks', data.klass),
        ),
        const SizedBox(height: 14),
        _section(
          'Foundations',
          'Blocks from earlier years',
          data.foundations,
          stagger: true,
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: C.outlineSoft,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your foundations start here',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: C.muted),
        ),
      ],
    );
  }
}

class BuildNextCard extends StatelessWidget {
  const BuildNextCard({
    super.key,
    this.compact = true,
    this.onStart,
    this.onWhy,
  });
  final bool compact;
  final VoidCallback? onStart;
  final VoidCallback? onWhy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.text.withOpacity(0.85)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Build next'),
          const SizedBox(height: 8),
          if (compact) ...[
            const Text(
              'Two-step equations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Fixing this makes harder equations and word problems easier.',
              style: TextStyle(fontSize: 12.5, color: C.muted, height: 1.35),
            ),
          ] else ...[
            Row(
              children: [
                const BrickFace(BrickState.building, width: 44, height: 28),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Two-step equations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fixing this makes harder equations and word problems easier.',
                        style: TextStyle(
                          fontSize: 12,
                          color: C.muted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: C.muted),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(label: 'Start', onPressed: onStart),
            Center(
              child: LinkButton(label: 'Why this block?', onPressed: onWhy),
            ),
          ],
        ],
      ),
    );
  }
}
