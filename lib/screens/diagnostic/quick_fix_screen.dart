import 'package:flutter/material.dart';

import '../../theme/widget.dart';
import '../../widgets/widget.dart';

class QuickFixScreen extends StatelessWidget {
  const QuickFixScreen({super.key, required this.onTryOne});
  final VoidCallback onTryOne;

  @override
  Widget build(BuildContext context) {
    const steps = [
      '3x − 4 = 11',
      'Step 1: add 4 to both sides, so 3x = 15.',
      'Step 2: divide both sides by 3, so x = 5.',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionLabel('Quick fix'),
        const SizedBox(height: 12),
        const Text('Two steps, in the right order',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.15)),
        const SizedBox(height: 8),
        const Text('First undo the adding or taking away. Then undo the multiplying by dividing.',
            style: TextStyle(fontSize: 14, color: C.muted, height: 1.4)),
        const SizedBox(height: 16),
        InfoCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Worked example'),
            const SizedBox(height: 10),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('${i + 1}. ${steps[i]}',
                    style: const TextStyle(fontSize: 13.5, height: 1.3)),
              ),
          ]),
        ),
        const Spacer(),
        PrimaryButton(label: 'Try one', onPressed: onTryOne),
      ]),
    );
  }
}
