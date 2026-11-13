import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../api/repositories/widget.dart';
import '../../api/services/widget.dart';
import '../../models/lesson_content.dart';
import '../../models/skill.dart';
import '../home/home_widget/today_store.dart';
import '../../theme/app_colors.dart';
import '../../widgets/info_widgets.dart';
import '../routes/widget.dart';

String _makeSymbolsSpeakable(String text) {
  return text
      .replaceAll('₦', ' naira ')
      .replaceAll('×', ' times ')
      .replaceAll('÷', ' divided by ')
      .replaceAll('≤', ' less than or equal to ')
      .replaceAll('≥', ' greater than or equal to ')
      .replaceAll('≠', ' is not equal to ')
      .replaceAll('−', ' minus ')
      .replaceAll('–', ' to ')
      .replaceAll('→', ' leads to ')
      .replaceAll('=', ' equals ')
      .replaceAll('+', ' plus ')
      .replaceAll('>', ' greater than ')
      .replaceAll('<', ' less than ')
      .replaceAll('²', ' squared ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// Displays the seven-stage Teach Me experience using topic content loaded
/// from assets/content/opexa_math_content.json.
///
/// Existing callers can continue to pass only [skill]. If a Map item has a
/// stable content ID, pass it through [topicId] to avoid relying on a label.
class TeachingLessonPage extends StatefulWidget {
  const TeachingLessonPage({super.key, required this.skill, this.topicId});

  final Skill skill;
  final String? topicId;

  @override
  State<TeachingLessonPage> createState() => _TeachingLessonPageState();
}

class _TeachingLessonPageState extends State<TeachingLessonPage> {
  final LessonContentRepository _contentRepository = LessonContentRepository();
  final TextToSpeechService _speech = TextToSpeechService();

  TopicContent? _topic;
  Object? _loadError;
  bool _isLoading = true;
  bool _isSpeaking = false;
  bool _isComplete = false;
  int _stepIndex = 0;
  String? _selectedQuickCheckOptionId;

  @override
  void initState() {
    super.initState();
    unawaited(_loadTopic());
    unawaited(_initializeSpeech());
  }

  Future<void> _loadTopic() async {
    try {
      final topic = await _contentRepository.getTopicForSkill(
        skillName: widget.skill.name,
        topicId: widget.topicId ?? widget.skill.topicId,
      );

      if (!mounted) return;
      setState(() {
        _topic = topic;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Could not load Teach Me content: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      await _speech.initialize(
        onStart: () {
          if (mounted) setState(() => _isSpeaking = true);
        },
        onComplete: () {
          if (mounted) setState(() => _isSpeaking = false);
        },
        onError: (message) {
          debugPrint('Teach Me TTS error: $message');
          if (mounted) setState(() => _isSpeaking = false);
        },
      );
    } catch (error) {
      debugPrint('Teach Me TTS initialization failed: $error');
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  @override
  void dispose() {
    unawaited(_speech.dispose());
    super.dispose();
  }

  List<LessonStepContent> get _steps => _topic?.lessonSteps ?? const [];

  LessonStepContent? get _currentStep {
    if (_steps.isEmpty || _stepIndex < 0 || _stepIndex >= _steps.length) {
      return null;
    }
    return _steps[_stepIndex];
  }

  Future<void> _stopSpeech() async {
    // Avoid sending a native stop command when no utterance is active.
    if (!_isSpeaking) return;
    // Reset the UI immediately; the native cancel/completion callback will
    // also report the stopped state when it arrives.
    if (mounted) setState(() => _isSpeaking = false);
    try {
      await _speech.stop();
    } catch (error) {
      debugPrint('Could not stop lesson speech: $error');
    }
  }

  Future<void> _listen() async {
    if (_isSpeaking) {
      await _stopSpeech();
      return;
    }

    final text = _speechTextForCurrentStep();
    if (text.trim().isEmpty) return;

    // Switch the control to Stop immediately, including while the native
    // speech engine is still initializing.
    setState(() => _isSpeaking = true);

    try {
      // initialize() is cached by the service, so this is safe even if the
      // page-level initialization has already completed.
      await _speech.initialize(
        onStart: () {
          if (mounted) setState(() => _isSpeaking = true);
        },
        onComplete: () {
          if (mounted) setState(() => _isSpeaking = false);
        },
        onError: (message) {
          debugPrint('Teach Me TTS error: $message');
          if (mounted) setState(() => _isSpeaking = false);
        },
      );
      // The student may have tapped Stop while initialization was pending.
      if (!mounted || !_isSpeaking) return;
      await _speech.speak(text);
    } catch (error, stackTrace) {
      debugPrint('Could not read lesson aloud: $error\n$stackTrace');
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

  String _speechTextForCurrentStep() {
    final step = _currentStep;
    if (step == null) return '';

    final parts = <String>[];
    if (step.section.isNotEmpty) parts.add(step.section);
    if (step.title.isNotEmpty) parts.add(step.title);
    if (step.body.isNotEmpty) parts.add(step.body);
    if (step.equation?.isNotEmpty == true) {
      parts.add('Example. ${step.equation}');
    }

    for (final workedStep in step.workedSteps) {
      parts.add('${workedStep.heading}. ${workedStep.explanation}');
    }

    if (step.callout != null) {
      parts.add('${step.callout!.title}. ${step.callout!.body}');
    }

    final question = step.quickCheck;
    if (question != null) {
      // speech_text is authored specifically for speech. Fall back to prompt.
      final questionSpeech = question.speechText?.trim().isNotEmpty == true
          ? question.speechText!
          : question.prompt;
      if (questionSpeech != step.title) parts.add(questionSpeech);
      if (question.body.isNotEmpty && question.body != step.body) {
        parts.add(question.body);
      }
      parts.add('The answer choices are:');
      for (final option in question.options) {
        parts.add('${option.id}. ${option.text}');
      }

      if (_selectedQuickCheckOptionId != null) {
        parts.add(
          question.isCorrect(_selectedQuickCheckOptionId)
              ? 'That is correct.'
              : 'Not quite.',
        );
        if (question.explanation.isNotEmpty) {
          parts.add(question.explanation);
        }
      }
    }

    return _makeSymbolsSpeakable(parts.join('. '));
  }

  Future<void> _next() async {
    final step = _currentStep;
    if (step == null) return;
    if (step.quickCheck != null && _selectedQuickCheckOptionId == null) {
      return;
    }

    await _stopSpeech();
    if (!mounted) return;

    if (_stepIndex >= _steps.length - 1) {
      final topicId = widget.topicId ?? widget.skill.topicId ?? _topic?.id;
      if (topicId != null) TodayStore.instance.completeLesson(topicId);
      setState(() => _isComplete = true);
      return;
    }

    setState(() {
      _stepIndex++;
      _selectedQuickCheckOptionId = null;
    });
  }

  Future<void> _back() async {
    await _stopSpeech();
    if (!mounted) return;

    if (_isComplete) {
      setState(() => _isComplete = false);
      return;
    }

    if (_stepIndex == 0) return;
    setState(() {
      _stepIndex--;
      _selectedQuickCheckOptionId = null;
    });
  }

  Future<void> _closeLesson() async {
    await _stopSpeech();
    if (mounted) {
      navBarVisible.value = true;
      Navigator.of(context).pop();
    }
  }

  void _selectQuickCheckOption(String optionId) {
    if (_selectedQuickCheckOptionId == optionId) return;
    if (_isSpeaking) unawaited(_stopSpeech());
    setState(() => _selectedQuickCheckOptionId = optionId);
  }

  Widget _loadingView() {
    return const Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _contentUnavailableView() {
    final message = _loadError != null
        ? 'We could not load this lesson. Please check the content file and try again.'
        : 'A Teach Me lesson for ${widget.skill.name} has not been added yet.';

    return Scaffold(
      appBar: AppBar(title: const Text('Teach me')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _loadError != null
                    ? Icons.error_outline_rounded
                    : Icons.menu_book_outlined,
                size: 48,
                color: context.colors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.45),
              ),
              const SizedBox(height: 18),
              if (_loadError != null)
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _loadError = null;
                    });
                    unawaited(_loadTopic());
                  },
                  child: const Text('Try again'),
                ),
              TextButton(
                onPressed: () {
                  navBarVisible.value = true;
                  Navigator.of(context).pop();
                },
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressHeader() {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _closeLesson,
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
                          color: i <= (_isComplete ? _steps.length : _stepIndex)
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
            _isComplete
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
              _isSpeaking
                  ? Icons.stop_circle_outlined
                  : Icons.volume_up_outlined,
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

  Widget _workedSteps(List<WorkedExampleStep> steps) {
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

  Widget _callout(LessonCallout callout) {
    final isWarning = callout.title.toUpperCase().contains('NOT');
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
          SectionLabel(callout.title),
          const SizedBox(height: 7),
          Text(
            callout.body,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _quickCheck(AssessmentQuestion question) {
    final selectedId = _selectedQuickCheckOptionId;
    final isCorrect = question.isCorrect(selectedId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        for (final option in question.options)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _selectQuickCheckOption(option.id),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selectedId == option.id
                      ? context.colors.accentContainer
                      : context.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectedId == option.id
                        ? context.colors.accent
                        : context.colors.border,
                    width: selectedId == option.id ? 1.5 : 1,
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
                        color: selectedId == option.id
                            ? context.colors.accent
                            : Colors.transparent,
                      ),
                      child: selectedId == option.id
                          ? Icon(
                              Icons.check,
                              size: 14,
                              color: context.colors.onAccent,
                            )
                          : Text(
                              option.id,
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
                        option.text,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (selectedId != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCorrect
                  ? context.colors.accentContainer
                  : context.colors.panel,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCorrect
                    ? context.colors.accent
                    : context.colors.panelBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'That is right' : 'Not quite',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question.explanation,
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
    final step = _currentStep!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _topic!.name.toUpperCase(),
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
          step.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          step.body,
          style: TextStyle(
            fontSize: step.quickCheck == null ? 14 : 12,
            color: step.quickCheck == null
                ? null
                : context.colors.textSecondary,
            height: 1.55,
          ),
        ),
        if (step.equation?.isNotEmpty == true && step.callout == null) ...[
          const SizedBox(height: 18),
          _equationCard(step.equation!),
        ],
        if (step.workedSteps.isNotEmpty) ...[
          const SizedBox(height: 16),
          _workedSteps(step.workedSteps),
        ],
        if (step.callout != null) ...[
          const SizedBox(height: 18),
          _callout(step.callout!),
          if (step.equation?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            _equationCard(step.equation!),
          ],
        ],
        if (step.quickCheck != null) ...[
          const SizedBox(height: 14),
          _quickCheck(step.quickCheck!),
        ],
      ],
    );
  }

  Widget _doneBody() {
    final topic = _topic!;
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
                image: DecorationImage(
                  image: AssetImage('assets/images/Illustration.png'),
                  fit: BoxFit.contain,
                ),
              ),
              //child: Image.asset('assets/images/Illustration.png'),
            ),
            const SizedBox(height: 28),
            Text(
              'You have learned ${topic.name.toLowerCase()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Next, practise it. You will answer questions and see explanations when you need them. Your learning map can be updated after your practice results are evaluated.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'About ${topic.estimatedLessonMinutes} minutes · Works offline',
              style: TextStyle(
                fontSize: 12,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _loadingView();
    if (_loadError != null || _topic == null) return _contentUnavailableView();
    if (_steps.isEmpty) return _contentUnavailableView();

    final isLastStep = _stepIndex == _steps.length - 1;
    final canContinue = !isLastStep || _selectedQuickCheckOptionId != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _progressHeader(),
            Expanded(child: _isComplete ? _doneBody() : _lessonBody()),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: context.colors.divider)),
              ),
              child: _isComplete
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () async {
                              final topicId = widget.topicId ??
                                  widget.skill.topicId ??
                                  _topic?.id;
                              if (topicId == null || topicId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Practice content is not available for this topic.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              navBarVisible.value = false;
                              try {
                                await context.push(
                                  '${AppRoutes.mainMap}/'
                                  '${AppRoutes.mainMapPracticeLesson}/'
                                  '${Uri.encodeComponent(topicId)}',
                                );
                              } finally {
                                if (mounted) navBarVisible.value = true;
                              }
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
                          onPressed: _closeLesson,
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
                              disabledBackgroundColor:
                                  context.colors.disabledFill,
                              disabledForegroundColor:
                                  context.colors.disabledText,
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

/// Practice screen powered by the selected topic's JSON practice_questions.
class QuickPracticeScreen extends StatefulWidget {
  const QuickPracticeScreen({
    super.key,
    required this.skill,
    this.topicId,
    this.topicContent,
  });

  /// Kept required for compatibility with existing QuickPracticeScreen calls.
  final Skill skill;
  final String? topicId;
  final TopicContent? topicContent;

  @override
  State<QuickPracticeScreen> createState() => _QuickPracticeScreenState();
}

class _QuickPracticeScreenState extends State<QuickPracticeScreen> {
  final LessonContentRepository _contentRepository = LessonContentRepository();

  TopicContent? _topic;
  Object? _loadError;
  bool _isLoading = true;
  int _index = 0;
  String? _selectedOptionId;
  int _correct = 0;
  bool _complete = false;
  bool _isSpeaking = false;
  final TextToSpeechService _speech = TextToSpeechService();

  List<AssessmentQuestion> get _questions =>
      _topic?.practiceQuestions ?? const [];

  @override
  void initState() {
    super.initState();
    if (widget.topicContent != null) {
      _topic = widget.topicContent;
      _isLoading = false;
    } else {
      unawaited(_loadTopic());
    }
    unawaited(_initializeSpeech());
  }

  Future<void> _initializeSpeech() async {
    try {
      await _speech.initialize(
        onStart: () {
          if (mounted) setState(() => _isSpeaking = true);
        },
        onComplete: () {
          if (mounted) setState(() => _isSpeaking = false);
        },
        onError: (message) {
          debugPrint('Practice TTS error: $message');
          if (mounted) setState(() => _isSpeaking = false);
        },
      );
    } catch (error) {
      debugPrint('Practice TTS initialization failed: $error');
    }
  }

  @override
  void dispose() {
    unawaited(_speech.dispose());
    super.dispose();
  }

  Future<void> _stopSpeech() async {
    if (!_isSpeaking) return;
    if (mounted) setState(() => _isSpeaking = false);
    try {
      await _speech.stop();
    } catch (error) {
      debugPrint('Could not stop practice speech: $error');
    }
  }

  String _practiceSpeechText(AssessmentQuestion question) {
    final promptForSpeech = question.speechText?.trim().isNotEmpty == true
        ? question.speechText!
        : question.prompt;
    final parts = <String>[promptForSpeech];
    if (question.body.isNotEmpty) parts.add(question.body);
    parts.add('The answer choices are:');
    for (final option in question.options) {
      parts.add('${option.id}. ${option.text}');
    }
    if (_selectedOptionId != null) {
      parts.add(
        question.isCorrect(_selectedOptionId)
            ? 'That is correct.'
            : 'Not quite.',
      );
      if (question.explanation.isNotEmpty) parts.add(question.explanation);
    }
    return _makeSymbolsSpeakable(parts.join('. '));
  }

  Future<void> _listenToPracticeQuestion() async {
    if (_isSpeaking) {
      await _stopSpeech();
      return;
    }
    if (_questions.isEmpty) return;
    setState(() => _isSpeaking = true);
    try {
      await _speech.initialize(
        onStart: () {
          if (mounted) setState(() => _isSpeaking = true);
        },
        onComplete: () {
          if (mounted) setState(() => _isSpeaking = false);
        },
        onError: (message) {
          debugPrint('Practice TTS error: $message');
          if (mounted) setState(() => _isSpeaking = false);
        },
      );
      if (!mounted || !_isSpeaking) return;
      await _speech.speak(_practiceSpeechText(_questions[_index]));
    } catch (error, stackTrace) {
      debugPrint('Could not read practice question: $error\n$stackTrace');
      if (!mounted) return;
      setState(() => _isSpeaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text-to-speech is unavailable on this device.'),
        ),
      );
    }
  }

  Widget _listenPill() {
    return InkWell(
      onTap: _listenToPracticeQuestion,
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
              _isSpeaking
                  ? Icons.stop_circle_outlined
                  : Icons.volume_up_outlined,
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

  Future<void> _loadTopic() async {
    try {
      final topic = await _contentRepository.getTopicForSkill(
        skillName: widget.skill.name,
        topicId: widget.topicId ?? widget.skill.topicId,
      );
      if (!mounted) return;
      setState(() {
        _topic = topic;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Could not load practice content: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  void _select(String optionId) {
    if (_selectedOptionId == optionId) return;
    if (_isSpeaking) unawaited(_stopSpeech());
    setState(() {
      final question = _questions[_index];
      if (question.isCorrect(_selectedOptionId)) _correct--;
      _selectedOptionId = optionId;
      if (question.isCorrect(optionId)) _correct++;
    });
  }

  Future<void> _next() async {
    if (_selectedOptionId == null) return;
    await _stopSpeech();
    if (!mounted) return;
    if (_index == _questions.length - 1) {
      final topicId = widget.topicId ?? widget.skill.topicId;
      if (topicId != null) {
        final threshold = (_questions.length * 0.7).ceil();
        TodayStore.instance.completePractice(
          topicId,
          status: _correct >= threshold ? 'solid' : 'building',
        );
      }
      setState(() => _complete = true);
    } else {
      setState(() {
        _index++;
        _selectedOptionId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (_isLoading) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    if (_loadError != null || _topic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'We could not load practice questions for this topic.',
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back to lesson'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Practice questions are not available for this topic yet.',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back to lesson'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_complete) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice complete')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: colors.accent,
                ),
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
                    onPressed: () => Navigator.of(context).pop(),
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
    final selectedOption = _selectedOptionId;
    final isCorrect = question.isCorrect(selectedOption);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            navBarVisible.value = true;
          },
          icon: const Icon(Icons.arrow_back, size: 18),
        ),
        title: Text(
          'Practice · ${_index + 1} of ${_questions.length}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value:
                  (_index + (selectedOption == null ? 0 : 1)) /
                  _questions.length,
              minHeight: 6,
              backgroundColor: colors.divider,
              color: colors.accent,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _listenPill(),
            ],
          ),
          if (question.body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              question.body,
              style: TextStyle(color: colors.textSecondary, height: 1.4),
            ),
          ],
          const SizedBox(height: 18),
          for (final option in question.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => _select(option.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selectedOption == option.id
                        ? colors.accentContainer
                        : colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedOption == option.id
                          ? colors.accent
                          : colors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border),
                          color: selectedOption == option.id
                              ? colors.accent
                              : Colors.transparent,
                        ),
                        child: selectedOption == option.id
                            ? Icon(
                                Icons.check,
                                size: 15,
                                color: colors.onAccent,
                              )
                            : Text(
                                option.id,
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(option.text)),
                    ],
                  ),
                ),
              ),
            ),
          if (selectedOption != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect ? colors.accentContainer : colors.panel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorrect ? colors.accent : colors.panelBorder,
                ),
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
            height: 50,
            width: double.infinity,
            child: FilledButton(
              onPressed: selectedOption == null ? null : _next,
              child: Text(
                _index == _questions.length - 1 ? 'Finish practice' : 'Next',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
