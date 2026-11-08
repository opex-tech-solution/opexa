import 'package:flutter/material.dart';
import '../../models/model.dart';
import '../../theme/widget.dart';
import '../../widgets/widget.dart';
import 'home_widget/home_widget.dart';

/// "This week": days learning, lessons, the last seven days, blocks moved up.
class WeekCard extends StatelessWidget {
  const WeekCard({super.key, required this.week, required this.today});

  final WeekProgress week;

  /// The last day box is this day.
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final initials = weekInitials(today);
    final days = week.daysLearning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$days',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: daysLearningSuffix(days),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                weekSummary(week),
                style: TextStyle(fontSize: 13, color: c.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: _DayCell(
                    initial: initials[i],
                    learned: week.learnedDays[i],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (week.blocksMovedUp.isEmpty)
            Text(
              'Blocks you move up this week will show here.',
              style: TextStyle(fontSize: 14, height: 1.4, color: c.textSecondary),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final block in week.blocksMovedUp)
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
                    decoration: BoxDecoration(
                      color: c.surfaceInset,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BrickFace(block.brick, width: 18, height: 12),
                        const SizedBox(width: 8),
                        Text(
                          block.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.initial, required this.learned});

  final String initial;
  final bool learned;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: learned ? c.accent : c.surfaceInset,
            borderRadius: BorderRadius.circular(10),
            border: learned
                ? null
                : Border.all(color: c.border.withValues(alpha: 0.55)),
          ),
          child: learned ? Icon(Icons.check, size: 20, color: c.onAccent) : null,
        ),
        const SizedBox(height: 6),
        Text(
          initial,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
      ],
    );
  }
}
