import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnswerBox extends StatelessWidget {
  const AnswerBox({super.key, required this.text, this.hint = 'Type your answer'});
  final String text;
  final String hint;
  @override
  Widget build(BuildContext context) {
    final has = text.isNotEmpty;
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: has ? C.primary : C.outline),
      ),
      child: Text(
        has ? text : hint,
        style: has
            ? const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)
            : const TextStyle(fontSize: 13.5, color: C.muted),
      ),
    );
  }
}

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.onDigit,
    required this.onNegative,
    required this.onBackspace,
  });
  final ValueChanged<int> onDigit;
  final VoidCallback onNegative;
  final VoidCallback onBackspace;

  Widget _key(Widget child, VoidCallback onTap, {bool dim = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: dim ? C.bg : C.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: dim ? C.outline : C.outlineSoft),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: SizedBox(height: 48, child: Center(child: child)),
          ),
        ),
      ),
    );
  }

  Widget _digit(int d) => _key(
        Text('$d', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        () => onDigit(d),
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [_digit(1), _digit(2), _digit(3)]),
      Row(children: [_digit(4), _digit(5), _digit(6)]),
      Row(children: [_digit(7), _digit(8), _digit(9)]),
      Row(children: [
        _key(
          const Column(mainAxisSize: MainAxisSize.min, children: [
            Text('±', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Negative', style: TextStyle(fontSize: 8.5, color: C.muted)),
          ]),
          onNegative,
          dim: true,
        ),
        _digit(0),
        _key(const Icon(Icons.backspace_outlined, size: 20), onBackspace, dim: true),
      ]),
    ]);
  }
}
