import 'package:flutter/material.dart';
import '../../../models/model.dart';
import '../../../theme/widget.dart';

/// "Your learning list: 6 topics to learn. Next: ..." (tap opens the list).
class LearningListCard extends StatelessWidget {
  const LearningListCard({super.key, required this.summary, required this.onTap});

  final LearningListSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: c.divider),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: c.accentContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.format_list_numbered, color: c.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your learning list',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${summary.topicCount} topics to learn. '
                      'Next: ${summary.nextTopic}',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.35,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: c.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
