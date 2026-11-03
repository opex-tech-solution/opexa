import 'package:flutter/material.dart';
import '../../models/model.dart';
import '../../theme/widget.dart';
import '../../widgets/widget.dart';


enum NumericMode { diagnostic, practice }

/// Numeric keypad screen.
///  • diagnostic: type -> Done -> "How sure are you?" (or "I don't know")
///  • practice:   type -> Check (correct advances) + Hint
class NumericScreen extends StatefulWidget {
  const NumericScreen({
    super.key,
    required this.prompt,
    required this.onDone,
    this.mode = NumericMode.diagnostic,
    this.label,
    this.showBanner = true,
    this.correctAnswer,
    this.hint,
  });
  final String prompt; // the expression (diagnostic) or equation (practice)
  final ValueChanged<AnswerResult> onDone;
  final NumericMode mode;
  final String? label;
  final bool showBanner;
  final int? correctAnswer;
  final String? hint;

  @override
  State<NumericScreen> createState() => _NumericScreenState();
}

class _NumericScreenState extends State<NumericScreen> {
  String _digits = '';
  bool _neg = false;
  bool _confirmed = false;
  bool _dkBusy = false;
  int? _busyConf;
  String? _toast;
  String? _feedback;
  bool _locked = false;

  String get _shown =>
      _digits.isEmpty ? (_neg ? '−' : '') : '${_neg ? '−' : ''}$_digits';
  int? get _value =>
      _digits.isEmpty ? null : int.parse(_digits) * (_neg ? -1 : 1);

  void _digit(int d) {
    if (_locked || _digits.length >= 5) return;
    setState(() {
      _digits = _digits == '0' ? '$d' : '$_digits$d';
      _feedback = null;
    });
  }

  void _negative() {
    if (_locked) return;
    setState(() => _neg = !_neg);
  }

  void _backspace() {
    if (_locked) return;
    setState(() {
      if (_digits.isNotEmpty) {
        _digits = _digits.substring(0, _digits.length - 1);
      } else {
        _neg = false;
      }
    });
  }

  void _later(VoidCallback fn, int ms) {
    Future.delayed(Duration(milliseconds: ms), () {
      if (mounted) fn();
    });
  }

  void _dontKnow() {
    if (_locked) return;
    setState(() {
      _dkBusy = true;
      _locked = true;
    });
    _later(() => widget.onDone(const AnswerResult(choice: null)), 700);
  }

  void _pickConfidence(int c) {
    if (_locked) return;
    setState(() {
      _busyConf = c;
      _locked = true;
      _toast = c == 1 ? 'Noted' : 'Got it';
    });
    _later(() => widget.onDone(AnswerResult(choice: _value, confidence: c)), 800);
  }

  void _check() {
    final v = _value;
    if (v == null) return;
    if (v == widget.correctAnswer) {
      setState(() {
        _locked = true;
        _feedback = 'Nice – that’s right.';
      });
      _later(() => widget.onDone(AnswerResult(choice: v)), 900);
    } else {
      setState(() {
        _digits = '';
        _neg = false;
        _feedback = 'Not quite. Have another go.';
      });
    }
  }

  void _showHint() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Hint'),
            const SizedBox(height: 10),
            Text(widget.hint ?? 'Undo the adding first, then undo the multiplying.',
                style: const TextStyle(fontSize: 16, height: 1.4)),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.mode == NumericMode.practice ? _practice() : _diagnostic();
  }

  Widget _practice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.label != null) ...[
          SectionLabel(widget.label!),
          const SizedBox(height: 12),
        ],
        Text('Your turn: solve\n${widget.prompt}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
        const SizedBox(height: 16),
        AnswerBox(text: _shown),
        SizedBox(
          height: 26,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _feedback == null
                ? null
                : Text(_feedback!, style: const TextStyle(fontSize: 12.5, color: C.muted)),
          ),
        ),
        NumberPad(onDigit: _digit, onNegative: _negative, onBackspace: _backspace),
        const Spacer(),
        PrimaryButton(label: 'Check', onPressed: _value == null || _locked ? null : _check),
        Center(child: LinkButton(label: 'Hint', icon: Icons.lightbulb_outline, onPressed: _showHint)),
      ]),
    );
  }

  Widget _diagnostic() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.label != null) ...[
          SectionLabel(widget.label!),
          const SizedBox(height: 10),
        ],
        if (widget.showBanner)
          const InfoBanner('We don’t mark answers as you go. Your map comes at the end.'),
        Expanded(
          child: Stack(children: [
            Positioned.fill(child: QuestionCard(widget.prompt)),
            if (_toast != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 14), child: ToastPill(_toast!)),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        AnswerBox(text: _shown),
        if (!_confirmed) ...[
          const SizedBox(height: 8),
          NumberPad(onDigit: _digit, onNegative: _negative, onBackspace: _backspace),
          const SizedBox(height: 4),
          OptionTile(text: 'I don’t know', loading: _dkBusy, onTap: _dontKnow),
          PrimaryButton(
            label: 'Done',
            onPressed: _value == null || _locked ? null : () => setState(() => _confirmed = true),
          ),
        ] else ...[
          Align(
            alignment: Alignment.centerLeft,
            child: LinkButton(
              label: 'Change my answer',
              color: C.primary,
              onPressed: _locked ? null : () => setState(() => _confirmed = false),
            ),
          ),
          OptionTile(text: 'I don’t know', loading: _dkBusy, onTap: _dontKnow),
          const SizedBox(height: 4),
          ConfidenceRow(onPick: _pickConfidence, busy: _busyConf),
        ],
      ]),
    );
  }
}
