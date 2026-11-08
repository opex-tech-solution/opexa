import 'package:flutter/material.dart';
import '../../../models/model.dart';
import '../../../theme/widget.dart';
import '../../../widgets/widget.dart';
import 'home_format.dart';
import 'lesson_visuals.dart';

/// The one lesson (or quick check) to do next, with a Start button.
class NextUpCard extends StatelessWidget {
  const NextUpCard({
    super.key,
    required this.nextUp,
    required this.onPrimary,
    this.onSecondary,
  });

  final NextUp nextUp;
  final VoidCallback onPrimary;

  /// "Not today". Only used when [NextUp.secondaryLabel] is set.
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final warm = nextUp.tone == NextUpTone.warm;
    final borderColor = warm ? c.panelBorder : c.accent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: warm ? 1.2 : 1.5),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(lessonKindIcon(nextUp.kind), size: 16, color: c.textSecondary),
              const SizedBox(width: 6),
              Text(
                lessonKindLabel(nextUp.kind).toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: c.textSecondary,
                ),
              ),
              const Spacer(),
              if (nextUp.badge != null) _Pill(nextUp.badge!),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrickFace(nextUp.brick, width: 60, height: 40),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextUp.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nextUp.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: c.textSecondary,
                      ),
                    ),
                    for (final reason in nextUp.reasons)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Icon(
                                reason.icon == ReasonIcon.topic
                                    ? Icons.track_changes
                                    : Icons.auto_awesome,
                                size: 15,
                                color: c.panelBorder,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                reason.text,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      lessonMeta(
                        minutes: nextUp.minutes,
                        worksOffline: nextUp.worksOffline,
                        downloadSize: nextUp.downloadSize,
                      ),
                      style: TextStyle(fontSize: 13, color: c.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: nextUp.primaryLabel, onPressed: onPrimary),
          if (nextUp.secondaryLabel != null)
            Center(
              child: LinkButton(
                label: nextUp.secondaryLabel!,
                color: c.accent,
                onPressed: onSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.surfaceInset,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
