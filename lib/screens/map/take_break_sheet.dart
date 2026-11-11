import 'package:flutter/material.dart';

import '../../theme/widget.dart';
import '../../widgets/widget.dart';

/// "Take a break?" sheet shown when the learner closes a lesson part-way.
///
/// Resolves to true for "Stop for now" and false for "Keep going" (also when
/// the sheet is dismissed by tapping outside or dragging it down).
Future<bool> showTakeBreakSheet(BuildContext context) async {
  final stop = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => const _TakeBreakSheet(),
  );
  return stop ?? false;
}

class _TakeBreakSheet extends StatelessWidget {
  const _TakeBreakSheet();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Take a break?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your answers are saved on this phone. You can pick up from '
              'this exact question later.',
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Keep going',
              onPressed: () => Navigator.of(context).pop(false),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: c.surfaceInset,
                  foregroundColor: c.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Stop for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
