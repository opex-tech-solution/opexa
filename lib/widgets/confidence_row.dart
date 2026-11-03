import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SignalBars extends StatelessWidget {
  const SignalBars(this.count, {super.key});
  final int count;
  @override
  Widget build(BuildContext context) {
    const heights = [5.0, 8.0, 11.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            width: 4,
            height: heights[i],
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: i < count ? C.text : C.outlineSoft,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
      ],
    );
  }
}

/// "How sure are you?" – Guessing / Fairly sure / Very sure.
class ConfidenceRow extends StatelessWidget {
  const ConfidenceRow({super.key, required this.onPick, this.busy});
  final ValueChanged<int> onPick;
  final int? busy;

  static const _labels = ['Guessing', 'Fairly sure', 'Very sure'];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [
        Text('How sure are you?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        Spacer(),
        Text('Tap one to go on', style: TextStyle(fontSize: 11, color: C.muted)),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Opacity(
              opacity: busy != null && busy != i ? 0.4 : 1,
              child: Material(
                color: busy == i ? C.selected : C.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: busy == i ? C.primary : C.outline),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: busy == null ? () => onPick(i) : null,
                  child: SizedBox(
                    height: 54,
                    child: Stack(alignment: Alignment.center, children: [
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SignalBars(i + 1),
                        const SizedBox(height: 5),
                        Text(_labels[i],
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      ]),
                      if (busy == i)
                        const Positioned(
                          top: 6,
                          right: 8,
                          child: SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2, color: C.primary)),
                        ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ]),
    ]);
  }
}
