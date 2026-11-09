import 'dart:async';
import 'package:flutter/material.dart';
import '../../api/services/widget.dart';
import '../../models/skill.dart';
import '../../theme/app_colors.dart';
import '../../widgets/info_widgets.dart';

class _WorkedStep {
  const _WorkedStep(this.heading, this.explanation);
  final String heading;
  final String explanation;
}

class _LessonStep {
  const _LessonStep({
    required this.section,
    required this.title,
    required this.body,
    this.equation,
    this.workedSteps = const [],
    this.calloutTitle,
    this.calloutBody,
    this.question,
    this.options = const [],
    this.answerIndex,
    this.answerExplanation,
  });

  final String section;
  final String title;
  final String body;
  final String? equation;
  final List<_WorkedStep> workedSteps;
  final String? calloutTitle;
  final String? calloutBody;
  final String? question;
  final List<String> options;
  final int? answerIndex;
  final String? answerExplanation;
}

class TeachingLessonPage extends StatefulWidget {
  const TeachingLessonPage({super.key, required this.skill});

  final Skill skill;

  @override
  State<TeachingLessonPage> createState() => _TeachingLessonPageState();
}

class _TeachingLessonPageState extends State<TeachingLessonPage> {
  late final List<_LessonStep> _steps = _buildSteps(widget.skill);
  int _stepIndex = 0;
  int? _selectedAnswer;
  bool _complete = false;
  bool _isSpeaking = false;
  final TextToSpeechService _speech = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _speech.initialize(
      onStart: () {
        if (mounted) setState(() => _isSpeaking = true);
      },
      onComplete: () {
        if (mounted) setState(() => _isSpeaking = false);
      },
      onError: (message) {
        if (mounted) setState(() => _isSpeaking = false);
      },
    ).catchError((Object error) {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  @override
  void dispose() {
    unawaited(_speech.dispose());
    super.dispose();
  }

  bool get _isWholeNumbers =>
      widget.skill.name.toLowerCase().contains('whole number');

  String get _topicName => _isWholeNumbers
      ? 'whole numbers'
      : widget.skill.name.toLowerCase().contains('simultaneous')
          ? 'simultaneous equations'
          : widget.skill.name.toLowerCase();

  List<_LessonStep> _buildSteps(Skill skill) {
    if (skill.name.toLowerCase().contains('whole number')) {
      return const [
        _LessonStep(
          section: 'What it is',
          title: 'Every digit has a place',
          body:
              'A number is made of digits. Where a digit sits tells you what it is worth.\n\nIn 345, the 3 is worth 3 hundreds, the 4 is worth 4 tens and the 5 is worth 5 ones.\n\nWe use place value every time we add, take away, multiply or divide.',
          equation: '345  =  300  +  40  +  5',
        ),
        _LessonStep(
          section: 'Why it matters',
          title: 'The position changes the value',
          body:
              'The digit 7 does not always mean seven. Its position tells us whether it is worth 7, 70 or 700.',
          equation: '572  =  500  +  70  +  2',
        ),
        _LessonStep(
          section: 'In everyday life',
          title: 'Counting money',
          body:
              'Imagine you have ₦345. You can split the amount into three hundreds, four tens and five ones. This makes it easier to add money or give the right change.',
          equation: '₦345  =  ₦300  +  ₦40  +  ₦5',
        ),
        _LessonStep(
          section: 'Step by step',
          title: 'Break a number into parts',
          body: 'Let us split 684 into hundreds, tens and ones.',
          workedSteps: [
            _WorkedStep('1   Look at the hundreds', '6 hundreds = 600.'),
            _WorkedStep('2   Look at the tens', '8 tens = 80.'),
            _WorkedStep('3   Look at the ones', '4 ones = 4.'),
            _WorkedStep('4   Put the parts together', '684 = 600 + 80 + 4.'),
          ],
        ),
        _LessonStep(
          section: 'Another example',
          title: 'Try 2,306',
          body:
              'The zero is important. It shows that there are no tens in this number.',
          equation: '2,306  =  2,000  +  300  +  6',
          workedSteps: [
            _WorkedStep('2 thousands', '2 × 1,000 = 2,000.'),
            _WorkedStep('3 hundreds', '3 × 100 = 300.'),
            _WorkedStep('0 tens and 6 ones', '0 × 10 + 6 × 1 = 6.'),
          ],
        ),
        _LessonStep(
          section: 'Watch out',
          title: 'A zero can hold a place',
          body:
              'Do not remove a zero just because there are no tens or hundreds. The zero keeps the other digits in the correct positions.',
          calloutTitle: 'NOT THIS',
          calloutBody: '2,306 = 236',
          equation: 'INSTEAD   2,306 = 2,000 + 300 + 6',
        ),
        _LessonStep(
          section: 'Quick check',
          title: 'In 572, what is the 7 worth?',
          body: 'Choose the value of the digit 7 in this number.',
          question: 'In 572, what is the 7 worth?',
          options: ['7', '70', '700'],
          answerIndex: 1,
          answerExplanation:
              'The 7 is in the tens place, so it is worth 7 tens, which is 70.',
        ),
      ];
    }

    if (skill.name.toLowerCase().contains('simultaneous')) {
      return const [
        _LessonStep(
          section: 'What it is',
          title: 'Two equations, two unknowns',
          body:
              'Simultaneous equations are two equations that are true at the same time.\n\nYou need to find values of x and y that work in both.\n\nOne way is to add or take away the equations so that one letter disappears.',
          equation: 'x + y = 10\nx − y = 4',
        ),
        _LessonStep(
          section: 'Why it matters',
          title: 'Why it matters',
          body:
              'You meet these in SS1 Maths.\n\nThey are used in Physics and Economics, whenever two facts share two unknowns.',
        ),
        _LessonStep(
          section: 'In everyday life',
          title: 'Buns and drinks',
          body:
              '2 buns and 1 drink cost ₦500. 1 bun and 1 drink cost ₦350.\n\nTake the second from the first: the drinks cancel, and 1 bun costs ₦150.\n\nThen 1 drink costs 350 − 150 = ₦200.',
          equation: '2 buns + 1 drink = ₦500\n1 bun + 1 drink = ₦350',
        ),
        _LessonStep(
          section: 'Step by step',
          title: 'Solve x + y = 10 and x − y = 4',
          body: 'Add the two equations to make y disappear.',
          workedSteps: [
            _WorkedStep('1   Add the equations', '2x = 14'),
            _WorkedStep('2   Divide both sides by 2', 'x = 7'),
            _WorkedStep('3   Put x = 7 into the first equation', '7 + y = 10'),
            _WorkedStep('4   Take 7 from both sides', 'y = 3'),
            _WorkedStep('5   Check the second equation', '7 − 3 = 4 ✓'),
          ],
        ),
        _LessonStep(
          section: 'Another example',
          title: 'Try another pair',
          body: 'Solve 2x + y = 11 and x + y = 7.',
          workedSteps: [
            _WorkedStep('1   Take the second equation from the first', 'x = 4'),
            _WorkedStep('2   Put x = 4 into the second equation', '4 + y = 7'),
            _WorkedStep('3   Take 4 from both sides', 'y = 3'),
            _WorkedStep('4   Check: 2 × 4 + 3 = 11', 'It works in the first equation too.'),
          ],
        ),
        _LessonStep(
          section: 'Watch out',
          title: 'A common mistake',
          body:
              'Finding x is only half the job. You need both x and y, and they must work in both equations.',
          calloutTitle: 'NOT THIS',
          calloutBody: 'x = 7 and stop there',
          equation: 'INSTEAD   x = 7 and y = 3',
        ),
        _LessonStep(
          section: 'Quick check',
          title: 'What is x?',
          body: 'Not marked. It just helps you see if the idea makes sense.',
          question: 'x + y = 9 and x − y = 1. What is x?',
          options: ['5', '4', '9', '10'],
          answerIndex: 0,
          answerExplanation:
              'Add the equations: 2x = 10, so x = 5. The y terms cancel out.',
        ),
      ];
    }

    // Reusable seven-part lesson layout for skills which do not yet have their
    // own authored lesson content. Replace this fallback with curriculum data.
    return [
      _LessonStep(
        section: 'What it is',
        title: skill.name,
        body:
            'This is one of the building blocks in your Mathematics map. Learn what it means, see an example, and try it for yourself.',
        equation: skill.name,
      ),
      _LessonStep(
        section: 'Why it matters',
        title: 'Why this skill matters',
        body:
            'This skill helps you understand the topics that come next. A strong foundation makes harder questions easier to solve.',
      ),
      _LessonStep(
        section: 'In everyday life',
        title: 'Where you may use it',
        body:
            'You can use this idea when solving everyday problems, comparing amounts or working something out step by step.',
        equation: 'Understand  →  Try  →  Check',
      ),
      _LessonStep(
        section: 'Step by step',
        title: 'Work through an example',
        body: 'Take your time and follow each step in order.',
        workedSteps: const [
          _WorkedStep('1   Read the question', 'Identify the information you already have.'),
          _WorkedStep('2   Choose a method', 'Use the rule that fits this problem.'),
          _WorkedStep('3   Work it out', 'Complete the calculation carefully.'),
          _WorkedStep('4   Check your answer', 'Make sure the result makes sense.'),
        ],
      ),
      _LessonStep(
        section: 'Another example',
        title: 'Try a second example',
        body:
            'The same idea works with a different set of numbers. Look for what stays the same and what changes.',
        equation: 'Try it with a new set of numbers',
      ),
      _LessonStep(
        section: 'Watch out',
        title: 'A common mistake',
        body:
            'Do not rush past the checking step. A small mistake can change the final answer.',
        calloutTitle: 'REMEMBER',
        calloutBody: 'Show your steps, then check your answer.',
      ),
      _LessonStep(
        section: 'Quick check',
        title: 'Quick check',
        body: 'Choose the answer that best fits the skill you just learned.',
        question: 'What should you do after working out an answer?',
        options: [
          'Stop immediately',
          'Check that it makes sense',
          'Skip the working',
          'Change the question',
        ],
        answerIndex: 1,
        answerExplanation:
            'Checking helps you catch small mistakes and confirm that your answer makes sense.',
      ),
    ];
  }

  void _next() {
    unawaited(_speech.stop());
    final current = _steps[_stepIndex];
    if (current.question != null && _selectedAnswer == null) return;

    if (_stepIndex == _steps.length - 1) {
      setState(() => _complete = true);
    } else {
      setState(() {
        _stepIndex++;
        _selectedAnswer = null;
      });
    }
  }

  void _back() {
    unawaited(_speech.stop());
    if (_complete) {
      setState(() => _complete = false);
      return;
    }
    if (_stepIndex == 0) return;
    setState(() {
      _stepIndex--;
      _selectedAnswer = null;
    });
  }

  String _speechTextForCurrentStep() {
    final step = _steps[_stepIndex];
    final parts = <String>[step.section, step.question ?? step.title, step.body];

    if (step.equation != null) {
      parts.add('Example. ${_makeSymbolsSpeakable(step.equation!)}');
    }

    for (final workedStep in step.workedSteps) {
      parts.add('${workedStep.heading}. ${workedStep.explanation}');
    }

    if (step.calloutTitle != null) {
      parts.add('${step.calloutTitle}. ${step.calloutBody ?? ''}');
    }

    if (step.question != null) {
      parts.add('The answer choices are:');
      for (var i = 0; i < step.options.length; i++) {
        parts.add('${String.fromCharCode(65 + i)}. ${step.options[i]}');
      }
      if (_selectedAnswer != null) {
        parts.add(_selectedAnswer == step.answerIndex ? 'That is right.' : 'Not quite.');
        if (step.answerExplanation?.isNotEmpty == true) {
          parts.add(step.answerExplanation!);
        }
      }
    }

    return _makeSymbolsSpeakable(parts.join('. '));
  }

  String _makeSymbolsSpeakable(String text) {
    return text
        .replaceAll('₦', ' naira ')
        .replaceAll('×', ' times ')
        .replaceAll('÷', ' divided by ')
        .replaceAll('−', ' minus ')
        .replaceAll('–', ' to ')
        .replaceAll('=', ' equals ')
        .replaceAll('+', ' plus ')
        .replaceAll('→', ' leads to ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<void> _listen() async {
    if (_isSpeaking) {
      await _speech.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }

    try {
      await _speech.speak(_speechTextForCurrentStep());
      if (mounted) setState(() => _isSpeaking = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSpeaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Text-to-speech is unavailable. Check that your device has a speech engine and voice installed.',
          ),
        ),
      );
    }
  }

  Widget _progressHeader() {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              tooltip: 'Close lesson',
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Row(
                children: [
                  for (var i = 0; i < _steps.length; i++)
                    Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i <= (_complete ? _steps.length : _stepIndex)
                              ? colors.accent
                              : colors.divider,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Text(
            _complete
                ? 'Teach me · Done'
                : 'Teach me · ${_stepIndex + 1} of ${_steps.length} · ${_steps[_stepIndex].section}',
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _listenPill() {
    return InkWell(
      onTap: _listen,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.colors.accentContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
              size: 16,
              color: context.colors.onAccentContainer,
            ),
            const SizedBox(width: 5),
            Text(
              _isSpeaking ? 'Stop' : 'Listen',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: context.colors.onAccentContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _equationCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.divider),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _workedSteps(List<_WorkedStep> steps) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: i == steps.length - 1
                    ? context.colors.accent
                    : context.colors.divider,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colors.accentContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: context.colors.onAccentContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].heading,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        steps[i].explanation,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _callout(_LessonStep step) {
    final isWarning = step.calloutTitle?.toUpperCase().contains('NOT') ?? false;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? context.colors.panelBorder : context.colors.accent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(step.calloutTitle ?? 'Remember'),
          const SizedBox(height: 7),
          Text(
            step.calloutBody ?? '',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _quickCheck(_LessonStep step) {
    final selected = _selectedAnswer;
    final isCorrect = selected != null && selected == step.answerIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        for (var i = 0; i < step.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedAnswer = i),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: selected == i
                      ? context.colors.accentContainer
                      : context.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected == i
                        ? context.colors.accent
                        : context.colors.border,
                    width: selected == i ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: context.colors.border),
                        color: selected == i ? context.colors.accent : Colors.transparent,
                      ),
                      child: selected == i
                          ? Icon(Icons.check, size: 14, color: context.colors.onAccent)
                          : Text(
                              String.fromCharCode(65 + i),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: context.colors.textSecondary,
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        step.options[i],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (selected != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCorrect ? context.colors.accentContainer : context.colors.panel,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCorrect ? context.colors.accent : context.colors.panelBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'That is right' : 'Not quite',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  step.answerExplanation ?? '',
                  style: const TextStyle(fontSize: 12, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _lessonBody() {
    final step = _steps[_stepIndex];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.skill.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            _listenPill(),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          step.question ?? step.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2),
        ),
        const SizedBox(height: 14),
        if (step.question == null)
          Text(
            step.body,
            style: const TextStyle(fontSize: 14, height: 1.55),
          )
        else
          Text(
            step.body,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.textSecondary,
              height: 1.4,
            ),
          ),
        if (step.equation != null && step.calloutTitle == null) ...[
          const SizedBox(height: 18),
          _equationCard(step.equation!),
        ],
        if (step.workedSteps.isNotEmpty) ...[
          const SizedBox(height: 16),
          _workedSteps(step.workedSteps),
        ],
        if (step.calloutTitle != null) ...[
          const SizedBox(height: 18),
          _callout(step),
          if (step.equation != null) ...[
            const SizedBox(height: 10),
            _equationCard(step.equation!),
          ],
        ],
        if (step.question != null) ...[
          const SizedBox(height: 14),
          _quickCheck(step),
        ],
      ],
    );
  }

  Widget _doneBody() {
    final isSimultaneous =
        widget.skill.name.toLowerCase().contains('simultaneous');
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 164,
              height: 126,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.accentContainer,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 30,
                    bottom: 20,
                    child: Icon(Icons.auto_awesome, color: context.colors.accent, size: 24),
                  ),
                  Positioned(
                    right: 28,
                    top: 20,
                    child: Icon(Icons.star_outline, color: context.colors.accent, size: 24),
                  ),
                  Icon(Icons.menu_book_rounded, color: context.colors.accent, size: 48),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'You have learned ${isSimultaneous ? 'simultaneous equations' : _topicName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2),
            ),
            const SizedBox(height: 12),
            Text(
              'Next, practise it. You will have a go, get hints if you need them, then try 4 questions on your own. Your map changes when you show it on your own.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'About 8 minutes · Works offline',
              style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _stepIndex == _steps.length - 1;
    final canContinue = !isLastStep || _selectedAnswer != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _progressHeader(),
            Expanded(child: _complete ? _doneBody() : _lessonBody()),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: context.colors.divider)),
              ),
              child: _complete
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => QuickPracticeScreen(
                                    skill: widget.skill,
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              backgroundColor: context.colors.accent,
                              foregroundColor: context.colors.onAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            child: const Text('Start practice'),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Practice later'),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        if (_stepIndex > 0) ...[
                          SizedBox(
                            width: 84,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: _back,
                              child: const Text('Back'),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: FilledButton(
                            onPressed: canContinue ? _next : null,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              backgroundColor: context.colors.accent,
                              foregroundColor: context.colors.onAccent,
                              disabledBackgroundColor: context.colors.disabledFill,
                              disabledForegroundColor: context.colors.disabledText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            child: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickPracticeScreen extends StatefulWidget {
  const QuickPracticeScreen({super.key, required this.skill});

  final Skill skill;

  @override
  State<QuickPracticeScreen> createState() => _QuickPracticeScreenState();
}

class _QuickPracticeScreenState extends State<QuickPracticeScreen> {
  int _index = 0;
  int? _selected;
  int _correct = 0;
  bool _complete = false;
  bool _isSpeaking = false;
  final TextToSpeechService _speech = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _speech.initialize(
      onStart: () {
        if (mounted) setState(() => _isSpeaking = true);
      },
      onComplete: () {
        if (mounted) setState(() => _isSpeaking = false);
      },
      onError: (message) {
        if (mounted) setState(() => _isSpeaking = false);
      },
    ).catchError((Object error) {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  @override
  void dispose() {
    unawaited(_speech.dispose());
    super.dispose();
  }

  List<({String question, List<String> options, int answer, String explanation})>
      get _questions {
    if (widget.skill.name.toLowerCase().contains('whole number')) {
      return const [
        (
          question: 'In 572, what is the 7 worth?',
          options: ['7', '70', '700', '7,000'],
          answer: 1,
          explanation: 'The 7 is in the tens place, so it is worth 70.',
        ),
        (
          question: 'Which is the expanded form of 345?',
          options: ['300 + 40 + 5', '30 + 40 + 5', '300 + 4 + 5', '3 + 4 + 5'],
          answer: 0,
          explanation: '3 hundreds, 4 tens and 5 ones make 300 + 40 + 5.',
        ),
        (
          question: 'What is 600 + 80 + 4?',
          options: ['684', '648', '6084', '864'],
          answer: 0,
          explanation: '600 + 80 + 4 = 684.',
        ),
        (
          question: 'What does the zero show in 2,306?',
          options: ['No thousands', 'No hundreds', 'No tens', 'No ones'],
          answer: 2,
          explanation: 'The zero holds the tens place because there are no tens.',
        ),
      ];
    }

    final skillName = widget.skill.name.toLowerCase();
    final isEquationSkill = skillName.contains('equation') ||
        skillName.contains('letter') ||
        skillName.contains('substitut');

    if (isEquationSkill) {
      return const [
        (
          question: 'x + y = 10 and x − y = 4. What is x?',
          options: ['5', '7', '3', '10'],
          answer: 1,
          explanation: 'Add both equations: 2x = 14, so x = 7.',
        ),
        (
          question: 'For the same pair of equations, what is y?',
          options: ['3', '4', '7', '10'],
          answer: 0,
          explanation: 'Put x = 7 into x + y = 10. That gives y = 3.',
        ),
        (
          question: 'What should you do after finding x?',
          options: ['Stop', 'Find y and check both equations', 'Change the values', 'Ignore the second equation'],
          answer: 1,
          explanation: 'Both unknowns must satisfy both equations.',
        ),
        (
          question: 'If x + y = 9 and x − y = 1, what is x?',
          options: ['4', '5', '8', '9'],
          answer: 1,
          explanation: 'Add the equations: 2x = 10, so x = 5.',
        ),
      ];
    }

    return const [
      (
        question: 'What should you do first when a maths question feels difficult?',
        options: ['Read it and identify what is given', 'Guess immediately', 'Skip the working', 'Ignore the question'],
        answer: 0,
        explanation: 'Read carefully first so you know what information you have.',
      ),
      (
        question: 'Why is it useful to show your steps?',
        options: ['It makes the page longer', 'It helps you check your reasoning', 'It hides mistakes', 'It changes the question'],
        answer: 1,
        explanation: 'Showing your steps helps you follow your reasoning and spot mistakes.',
      ),
      (
        question: 'What should you do after finding an answer?',
        options: ['Stop without checking', 'Check that it makes sense', 'Erase the working', 'Change the numbers'],
        answer: 1,
        explanation: 'A quick check helps confirm that your answer fits the question.',
      ),
      (
        question: 'What can help when you are not sure how to start?',
        options: ['A worked example or hint', 'Skipping every lesson', 'Choosing a random answer', 'Giving up'],
        answer: 0,
        explanation: 'A worked example or hint can help you understand the first step.',
      ),
    ];
  }

  void _select(int index) {
    if (_selected != null) return;
    setState(() {
      _selected = index;
      if (index == _questions[_index].answer) _correct++;
    });
  }

  void _next() {
    if (_selected == null) return;
    if (_index == _questions.length - 1) {
      setState(() => _complete = true);
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (_complete) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice complete')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_outlined, size: 64, color: colors.accent),
                const SizedBox(height: 18),
                const Text(
                  'Good work!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'You got $_correct of ${_questions.length} questions right.',
                  style: TextStyle(color: colors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text('Back to your lesson'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_index];
    final isCorrect = _selected == question.answer;

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice · ${_index + 1} of ${_questions.length}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_index + (_selected == null ? 0 : 1)) / _questions.length,
              minHeight: 6,
              backgroundColor: colors.divider,
              color: colors.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            question.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1.3),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < question.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => _select(i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _selected == i ? colors.accentContainer : colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selected == i ? colors.accent : colors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(question.options[i])),
                      if (_selected == i)
                        Icon(Icons.check_circle, color: colors.onAccentContainer),
                    ],
                  ),
                ),
              ),
            ),
          if (_selected != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect ? colors.accentContainer : colors.panel,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCorrect ? 'Correct' : 'Not quite',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(question.explanation),
                ],
              ),
            ),
          ],
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _selected == null ? null : _next,
              child: Text(_index == _questions.length - 1 ? 'Finish practice' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
