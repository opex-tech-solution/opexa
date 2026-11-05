import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/buttons.dart';
import '../../widgets/info_widgets.dart';

class WorkingTextScreen extends StatefulWidget {
  const WorkingTextScreen({
    super.key,
    required this.title,
    required this.onSend,
    required this.onSkip,
  });
  final String title;
  final ValueChanged<String> onSend;
  final VoidCallback onSkip;

  @override
  State<WorkingTextScreen> createState() => _WorkingTextScreenState();
}

class _WorkingTextScreenState extends State<WorkingTextScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: context.colors.border),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionLabel('Show your working'),
        const SizedBox(height: 12),
        Text(widget.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('There’s no wrong answer here. A few words is plenty, or skip it.',
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary, height: 1.35)),
        const SizedBox(height: 14),
        TextField(
          controller: _controller,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'e.g. I took 9 from 3…',
            hintStyle: TextStyle(color: context.colors.textSecondary),
            filled: true,
            fillColor: context.colors.surface,
            enabledBorder: border,
            focusedBorder: border.copyWith(borderSide: BorderSide(color: context.colors.accent)),
          ),
        ),
        const Spacer(),
        PrimaryButton(label: 'Send', onPressed: () => widget.onSend(_controller.text.trim())),
        Center(child: LinkButton(label: 'Skip', onPressed: widget.onSkip)),
      ]),
    );
  }
}
