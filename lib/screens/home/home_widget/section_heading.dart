import 'package:flutter/material.dart';

import '../../../theme/widget.dart';

/// "Next up", "Also today  0 of 3 lessons done", "This week", ...
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
      ],
    );
  }
}
