import 'package:flutter/material.dart';

import '../../../models/model.dart';
import '../../../theme/widget.dart';

/// "What are you working on in Maths this week?" with a chip per topic.
class ClassTopicCard extends StatelessWidget {
  const ClassTopicCard({super.key, required this.prompt, required this.onSelect});

  final ClassTopicPrompt prompt;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are you working on in ${prompt.subject} this week?',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Class lesson follows this topic. You can change it any time.',
            style: TextStyle(fontSize: 14, height: 1.4, color: c.textSecondary),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              for (final topic in prompt.topics)
                _TopicChip(
                  label: topic,
                  selected: prompt.selected == topic,
                  onTap: () => onSelect(topic),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.accentContainer : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? c.accent : c.accent.withValues(alpha: 0.55),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
