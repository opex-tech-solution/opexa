import 'package:flutter/material.dart';
import '../../models/model.dart';
import '../../theme/widget.dart';
import '../../widgets/widget.dart';

/// Multiple-choice screen. With [askConfidence] the "How sure are you?" row
/// appears after an option is picked and tapping it advances. Without it
/// (the "show your working" step) picking an option advances directly.
class McqScreen extends StatefulWidget {
  const McqScreen({
    super.key,
    required this.prompt,
    required this.options,
    required this.onDone,
    this.label,
    this.subtitle,
    this.showBanner = true,
    this.askConfidence = true,
    this.dontKnowLabel = 'I don’t know',
  });
  final String prompt;
  final List<String> options;
  final ValueChanged<AnswerResult> onDone;
  final String? label;
  final String? subtitle;
  final bool showBanner;
  final bool askConfidence;
  final String dontKnowLabel;

  @override
  State<McqScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<McqScreen> {
  int? _selected;
  bool _dontKnow = false;
  int? _busyConf;
  String? _toast;
  bool _locked = false;

  void _finish(AnswerResult r, int ms) {
    Future.delayed(Duration(milliseconds: ms), () {
      if (mounted) widget.onDone(r);
    });
  }

  void _pick(int i) {
    if (_locked) return;
    if (widget.askConfidence) {
      setState(() => _selected = i);
    } else {
      setState(() {
        _selected = i;
        _locked = true;
      });
      _finish(AnswerResult(choice: i), 300);
    }
  }

  void _pickDontKnow() {
    if (_locked) return;
    setState(() {
      _dontKnow = true;
      _locked = true;
    });
    _finish(const AnswerResult(choice: null), 700);
  }

  void _pickConfidence(int c) {
    if (_locked) return;
    setState(() {
      _busyConf = c;
      _locked = true;
      _toast = c == 1 ? 'Noted' : 'Got it';
    });
    _finish(AnswerResult(choice: _selected, confidence: c), 800);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.label != null) ...[
          SectionLabel(widget.label!),
          const SizedBox(height: 10),
        ],
        if (widget.subtitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(widget.subtitle!,
                style: const TextStyle(fontSize: 13, color: C.muted, height: 1.35)),
          ),
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
        for (var i = 0; i < widget.options.length; i++)
          OptionTile(
            letter: String.fromCharCode(65 + i),
            text: widget.options[i],
            selected: _selected == i,
            onTap: () => _pick(i),
          ),
        OptionTile(
          text: widget.dontKnowLabel,
          loading: _dontKnow,
          onTap: _pickDontKnow,
        ),
        if (widget.askConfidence && _selected != null && !_dontKnow) ...[
          const SizedBox(height: 4),
          ConfidenceRow(onPick: _pickConfidence, busy: _busyConf),
        ],
      ]),
    );
  }
}
