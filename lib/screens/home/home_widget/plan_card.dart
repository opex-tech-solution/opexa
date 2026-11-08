import 'package:flutter/material.dart';
import '../../../models/model.dart';
import '../../../theme/widget.dart';
import '../../../widgets/widget.dart';
import 'lesson_visuals.dart';
import 'section_heading.dart';

/// "Also today" / "Today's plan": one grouped card with a row per lesson.
class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.state, required this.onOpen});

  final TodayState state;
  final ValueChanged<PlanItem> onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          state.planHeading,
          trailing:
              '${state.lessonsDone} of ${state.lessonsTotal} lessons done',
        ),
        const SizedBox(height: 10),
        Material(
          color: c.surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: c.divider),
          ),
          child: Column(
            children: [
              for (var i = 0; i < state.plan.length; i++) ...[
                if (i > 0) Divider(height: 1, color: c.divider),
                _PlanRow(item: state.plan[i], onOpen: onOpen),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.item, required this.onOpen});

  final PlanItem item;
  final ValueChanged<PlanItem> onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final openable = item.status == LessonStatus.todo;

    final Widget leading = item.status == LessonStatus.needsTopic
        ? Container(
            width: 44,
            height: 32,
            decoration: BoxDecoration(
              color: c.accentContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.menu_book_outlined, size: 18, color: c.accent),
          )
        : BrickFace(item.brick, width: 44, height: 30);

    final Widget? trailing = switch (item.status) {
      LessonStatus.todo => Icon(Icons.chevron_right, color: c.textSecondary),
      LessonStatus.done => const _DoneChip(),
      LessonStatus.locked || LessonStatus.needsTopic => null,
    };

    return InkWell(
      onTap: openable ? () => onOpen(item) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonKindLabel(item.kind).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.caption,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing],
          ],
        ),
      ),
    );
  }
}

class _DoneChip extends StatelessWidget {
  const _DoneChip();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.accentContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 14, color: c.onAccentContainer),
          const SizedBox(width: 4),
          Text(
            'Done',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c.onAccentContainer,
            ),
          ),
        ],
      ),
    );
  }
}
