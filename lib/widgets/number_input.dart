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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: has ? context.colors.accent : context.colors.border),
      ),
      child: Text(
        has ? text : hint,
        style: has
            ? const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)
            : TextStyle(fontSize: 13.5, color: context.colors.textSecondary),
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

  Widget _key(BuildContext context, Widget child, VoidCallback onTap, {bool dim = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: dim ? context.colors.background : context.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: dim ? context.colors.border : context.colors.divider),
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

  Widget _digit(BuildContext context, int d) => _key(
        context,
        Text('$d', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        () => onDigit(d),
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [_digit(context, 1), _digit(context, 2), _digit(context, 3)]),
      Row(children: [_digit(context, 4), _digit(context, 5), _digit(context, 6)]),
      Row(children: [_digit(context, 7), _digit(context, 8), _digit(context, 9)]),
      Row(children: [
        _key(
          context,
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('±', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Negative', style: TextStyle(fontSize: 8.5, color: context.colors.textSecondary)),
          ]),
          onNegative,
          dim: true,
        ),
        _digit(context, 0),
        _key(context, const Icon(Icons.backspace_outlined, size: 20), onBackspace, dim: true),
      ]),
    ]);
  }
}
