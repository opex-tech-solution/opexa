import 'dart:async';

import 'package:flutter/material.dart';

import '../../api/repositories/widget.dart';
import '../../models/practice_lesson_content.dart';
import '../../theme/app_colors.dart';

/// Recreates the multi-stage OpexA practice lesson shown in the supplied
/// recording. Its text, moves, hints, questions and result copy are loaded
/// from the topic's `practice_lesson` object in the Mathematics JSON asset.
class PracticeLessonPage extends StatefulWidget {
  const PracticeLessonPage({
    super.key,
    required this.topicId,
    this.repository,
    this.onCompleted,
    this.onBackToToday,
    this.onSeeOnMap,
    this.onNextLesson,
  });

  final String topicId;
  final PracticeLessonRepository? repository;
  final ValueChanged<PracticeLessonResult>? onCompleted;
  final VoidCallback? onBackToToday;
  final VoidCallback? onSeeOnMap;
  final VoidCallback? onNextLesson;

  @override
  State<PracticeLessonPage> createState() => _PracticeLessonPageState();
}

class _PracticeLessonPageState extends State<PracticeLessonPage> {
  late final PracticeLessonRepository _repository =
      widget.repository ?? PracticeLessonRepository();

  PracticeLessonContent? _lesson;
  String? _topicName;
  Object? _loadError;
  bool _loading = true;
  bool _showResult = false;
  bool _completionReported = false;

  // The eight screens shown in the reference recording.
  int _stageIndex = 0;
  static const List<String> _stageLabels = [
    'Start',
    'Have a go',
    'The idea',
    'Watch',
    'What if',
    'Practise',
    'Think',
    'Check',
  ];

  // Have-a-go state.
  int _moveStepIndex = 0;
  bool _haveAGoComplete = false;
  bool _haveAGoSkipped = false;
  String? _moveFeedback;
  bool _lastMoveWasCorrect = false;

  // Watch state.
  int _watchStepIndex = 0;
  Timer? _watchTimer;
  bool _watchPlaying = false;

  // What-if state.
  String? _selectedWhatIf;

  // Guided practice state.
  int _guidedQuestionIndex = 0;
  String _guidedInput = '';
  bool _guidedChecked = false;
  bool _guidedCorrect = false;
  int _hintIndex = 0;

  // Reflection state.
  final Map<String, String> _reflectionAnswers = {};

  // Independent check state.
  int _checkQuestionIndex = 0;
  String _checkInput = '';
  bool _checkDontKnow = false;
  final List<PracticeAnswerResult> _checkAnswers = [];

  PracticeLessonContent get _content => _lesson!;
  bool get _canContinueHaveAGo => _haveAGoComplete;
  bool get _canContinueWhatIf => _selectedWhatIf != null;

  NumericPracticeQuestion? get _currentGuidedQuestion {
    final questions = _lesson?.guidedPractice ?? const [];
    if (_guidedQuestionIndex < 0 || _guidedQuestionIndex >= questions.length) {
      return null;
    }
    return questions[_guidedQuestionIndex];
  }

  NumericPracticeQuestion? get _currentCheckQuestion {
    final questions = _lesson?.independentCheck ?? const [];
    if (_checkQuestionIndex < 0 || _checkQuestionIndex >= questions.length) {
      return null;
    }
    return questions[_checkQuestionIndex];
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadLesson());
  }

  Future<void> _loadLesson() async {
    try {
      final lesson = await _repository.getPracticeLesson(widget.topicId);
      final topicName = await _repository.getTopicName(widget.topicId);
      if (!mounted) return;
      setState(() {
        _lesson = lesson;
        _topicName = topicName;
        _loading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Could not load practice lesson: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _watchTimer?.cancel();
    super.dispose();
  }

  void _goToStage(int stage) {
    _watchTimer?.cancel();
    setState(() {
      _stageIndex = stage < 0 ? 0 : (stage > 7 ? 7 : stage);
      _watchPlaying = false;
      _moveFeedback = null;
      _selectedWhatIf = null;
    });
    if (stage == 3) _playWatchSequence();
  }

  void _nextStage() {
    if (_stageIndex >= 7) return;
    _goToStage(_stageIndex + 1);
  }

  void _selectMove(EquationMoveOption move) {
    if (_haveAGoComplete || _lesson == null) return;
    final currentStep = _content.haveAGo.steps[_moveStepIndex];
    final isCorrect = move.id == currentStep.correctMoveId;

    setState(() {
      _moveFeedback = move.feedback;
      _lastMoveWasCorrect = isCorrect;
    });

    if (!isCorrect) return;

    // Give the learner a brief moment to see the feedback before the equation
    // advances to the next balanced state.
    unawaited(Future<void>.delayed(const Duration(milliseconds: 750), () {
      if (!mounted || _stageIndex != 1 || _haveAGoSkipped || _haveAGoComplete) return;
      setState(() {
        if (_moveStepIndex < _content.haveAGo.steps.length - 1) {
          _moveStepIndex++;
          _moveFeedback = null;
          _lastMoveWasCorrect = false;
        } else {
          _haveAGoComplete = true;
          _moveFeedback = currentStep.successCaption;
          _lastMoveWasCorrect = true;
        }
      });
    }));
  }

  void _undoMove() {
    if (_moveStepIndex == 0 || _haveAGoComplete) return;
    setState(() {
      _moveStepIndex--;
      _moveFeedback = null;
      _lastMoveWasCorrect = false;
    });
  }

  void _skipHaveAGo() {
    setState(() {
      _haveAGoComplete = true;
      _haveAGoSkipped = true;
      _moveFeedback = null;
    });
  }

  void _playWatchSequence() {
    _watchTimer?.cancel();
    if (_lesson == null || _content.watch.steps.isEmpty) return;
    setState(() {
      _watchStepIndex = 0;
      _watchPlaying = true;
    });

    _watchTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!mounted || _stageIndex != 3) {
        timer.cancel();
        return;
      }
      if (_watchStepIndex >= _content.watch.steps.length - 1) {
        timer.cancel();
        setState(() => _watchPlaying = false);
      } else {
        setState(() => _watchStepIndex++);
      }
    });
  }

  void _appendDigit(String digit, {required bool guided}) {
    setState(() {
      if (guided) {
        if (_guidedChecked) return;
        if (digit == 'negative') {
          _guidedInput = _guidedInput.startsWith('-')
              ? _guidedInput.substring(1)
              : '-$_guidedInput';
        } else if (digit == 'backspace') {
          if (_guidedInput.isNotEmpty) {
            _guidedInput = _guidedInput.substring(0, _guidedInput.length - 1);
          }
        } else if (_guidedInput.length < 8) {
          _guidedInput += digit;
        }
      } else {
        if (_checkDontKnow) return;
        if (digit == 'negative') {
          _checkInput = _checkInput.startsWith('-')
              ? _checkInput.substring(1)
              : '-$_checkInput';
        } else if (digit == 'backspace') {
          if (_checkInput.isNotEmpty) {
            _checkInput = _checkInput.substring(0, _checkInput.length - 1);
          }
        } else if (_checkInput.length < 8) {
          _checkInput += digit;
        }
      }
    });
  }

  void _checkGuidedAnswer() {
    final question = _currentGuidedQuestion;
    if (question == null || _guidedInput.trim().isEmpty) return;
    final correct = _normaliseNumber(_guidedInput) == _normaliseNumber(question.answer);
    setState(() {
      _guidedChecked = true;
      _guidedCorrect = correct;
    });
  }

  void _showNextGuidedQuestion() {
    final questions = _content.guidedPractice;
    if (_guidedQuestionIndex < questions.length - 1) {
      setState(() {
        _guidedQuestionIndex++;
        _guidedInput = '';
        _guidedChecked = false;
        _guidedCorrect = false;
        _hintIndex = 0;
      });
    } else {
      _goToStage(6);
    }
  }

  void _showHint() {
    final question = _currentGuidedQuestion;
    if (question == null || _guidedChecked) return;
    if (_hintIndex >= question.hints.length) return;
    setState(() => _hintIndex++);
  }

  void _selectReflection(String groupId, String optionId) {
    setState(() => _reflectionAnswers[groupId] = optionId);
  }

  bool get _reflectionComplete {
    if (_lesson == null) return false;
    return _content.reflection.groups
        .every((group) => _reflectionAnswers.containsKey(group.id));
  }

  void _recordCheckAnswer() {
    final question = _currentCheckQuestion;
    if (question == null) return;
    if (_checkInput.trim().isEmpty && !_checkDontKnow) return;

    final answer = _checkDontKnow ? null : _checkInput.trim();
    final correct = answer != null &&
        _normaliseNumber(answer) == _normaliseNumber(question.answer);

    _checkAnswers.add(
      PracticeAnswerResult(
        question: question.prompt,
        givenAnswer: answer,
        correctAnswer: question.answer,
        isCorrect: correct,
        didNotKnow: _checkDontKnow,
      ),
    );

    if (_checkQuestionIndex < _content.independentCheck.length - 1) {
      setState(() {
        _checkQuestionIndex++;
        _checkInput = '';
        _checkDontKnow = false;
      });
    } else {
      _finishPractice();
    }
  }

  void _finishPractice() {
    if (_lesson == null) return;
    final score = _checkAnswers.where((answer) => answer.isCorrect).length;
    final status = score >= _content.result.solidThreshold ? 'solid' : 'building';
    final result = PracticeLessonResult(
      topicId: widget.topicId,
      topicName: _topicName ?? _content.title,
      correctCount: score,
      totalQuestions: _checkAnswers.length,
      answers: List.unmodifiable(_checkAnswers),
      reflections: Map.unmodifiable(_reflectionAnswers),
      status: status,
    );

    setState(() => _showResult = true);
    if (!_completionReported) {
      _completionReported = true;
      widget.onCompleted?.call(result);
    }
  }

  String _normaliseNumber(String value) {
    final parsed = double.tryParse(value.replaceAll('−', '-').trim());
    if (parsed == null) return value.replaceAll('−', '-').trim();
    return parsed.toStringAsFixed(parsed.truncateToDouble() == parsed ? 0 : 4);
  }

  void _goBackToToday() {
    widget.onBackToToday?.call();
    if (widget.onBackToToday == null && mounted) Navigator.of(context).pop();
  }

  void _goSeeOnMap() {
    widget.onSeeOnMap?.call();
    if (widget.onSeeOnMap == null && mounted) Navigator.of(context).pop();
  }

  void _goNextLesson() {
    widget.onNextLesson?.call();
    if (widget.onNextLesson == null && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) return _buildLoadError();
    if (_lesson == null) return _buildUnavailable();
    if (_showResult) return _buildResultScreen();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: KeyedSubtree(
                  key: ValueKey<int>(_stageIndex),
                  child: _buildStageBody(),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({bool result = false}) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Close practice lesson',
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Row(
                  children: List.generate(8, (index) {
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= (result ? 7 : _stageIndex)
                              ? colors.accent
                              : colors.divider,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 1),
            child: Text(
              result
                  ? 'Class · Result'
                  : 'Step ${_stageIndex + 1} of 8 · ${_stageLabels[_stageIndex]}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageBody() {
    switch (_stageIndex) {
      case 0:
        return _buildStartStage();
      case 1:
        return _buildHaveAGoStage();
      case 2:
        return _buildIdeaStage();
      case 3:
        return _buildWatchStage();
      case 4:
        return _buildWhatIfStage();
      case 5:
        return _buildGuidedPracticeStage();
      case 6:
        return _buildThinkStage();
      case 7:
        return _buildIndependentCheckStage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStartStage() {
    final colors = context.colors;
    final start = _content.start;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        _eyebrow(start.classLabel),
        const SizedBox(height: 8),
        Text(
          _content.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.15),
        ),
        const SizedBox(height: 18),
        _infoCard(
          title: 'HOW THIS LESSON STARTS',
          bodyTitle: start.lessonStartsTitle,
          body: start.lessonStartsBody,
          footer: start.differentWayLabel,
          icon: Icons.auto_awesome_outlined,
        ),
        const SizedBox(height: 12),
        _infoCard(
          title: 'WHY IT MATTERS',
          body: start.whyItMatters,
          icon: Icons.lightbulb_outline,
        ),
        const SizedBox(height: 12),
        _infoCard(
          title: "BY THE END YOU'LL BE ABLE TO",
          body: start.learningOutcome,
          icon: Icons.flag_outlined,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.timer_outlined, size: 17, color: colors.textSecondary),
            const SizedBox(width: 8),
            Text('About ${_content.estimatedMinutes} minutes', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Icon(Icons.wifi_off_outlined, size: 17, color: colors.textSecondary),
            const SizedBox(width: 8),
            Text(_content.worksOffline ? 'Works offline' : 'Internet connection needed', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildHaveAGoStage() {
    final content = _content.haveAGo;
    final step = content.steps[_moveStepIndex];
    final displaySolvedEquation = _haveAGoComplete && !_haveAGoSkipped;
    final displayedLeft = displaySolvedEquation ? step.resultLeft : step.equationLeft;
    final displayedRight = displaySolvedEquation ? step.resultRight : step.equationRight;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        _eyebrow(content.eyebrow),
        const SizedBox(height: 10),
        Text(content.intro, style: const TextStyle(fontSize: 14, height: 1.45)),
        const SizedBox(height: 12),
        Text(content.prompt, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.35)),
        const SizedBox(height: 14),
        _buildBalanceCard(displayedLeft, displayedRight),
        if (_moveStepIndex > 0 && !_haveAGoComplete) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _undoMove,
              icon: const Icon(Icons.undo, size: 16),
              label: const Text('Undo'),
            ),
          ),
        ],
        const SizedBox(height: 8),
        for (final move in step.moves)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _actionOption(
              label: move.label,
              selected: _lastMoveWasCorrect && move.id == step.correctMoveId &&
                  _moveFeedback == move.feedback,
              enabled: !_haveAGoComplete && !_lastMoveWasCorrect,
              onTap: () => _selectMove(move),
            ),
          ),
        if (_moveFeedback != null && !_haveAGoComplete) ...[
          const SizedBox(height: 6),
          _feedbackCard(
            title: _lastMoveWasCorrect ? 'Good move' : 'Try that again',
            body: _moveFeedback!,
            positive: _lastMoveWasCorrect,
          ),
        ],
        if (_haveAGoComplete && !_haveAGoSkipped) ...[
          const SizedBox(height: 8),
          _feedbackCard(
            title: 'You found x',
            body: '3x + 4 = −5, so x = −3. You kept the equation balanced at every step.',
            positive: true,
          ),
        ],
      ],
    );
  }

  Widget _buildIdeaStage() {
    final idea = _content.idea;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _eyebrow(idea.eyebrow),
        const SizedBox(height: 12),
        Text(idea.title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, height: 1.2)),
        const SizedBox(height: 12),
        Text(idea.body, style: const TextStyle(fontSize: 14, height: 1.55)),
        const SizedBox(height: 16),
        _outlinedContentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow(idea.exampleLabel),
              const SizedBox(height: 8),
              Text(idea.example, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWatchStage() {
    final watch = _content.watch;
    final safeIndex = _watchStepIndex.clamp(0, watch.steps.length - 1);
    final step = watch.steps[safeIndex];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _eyebrow(watch.eyebrow),
        const SizedBox(height: 12),
        _buildBalanceCard(step.equationLeft, step.equationRight),
        const SizedBox(height: 14),
        Text(step.caption, style: const TextStyle(fontSize: 14, height: 1.45, fontWeight: FontWeight.w600)),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(watch.steps.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: index == safeIndex ? 10 : 7,
              height: index == safeIndex ? 10 : 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: index == safeIndex ? context.colors.accent : context.colors.textSecondary.withOpacity(.45),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildWhatIfStage() {
    final whatIf = _content.whatIf;
    final selected = _firstOrNull(whatIf.options.where((option) => option.id == _selectedWhatIf));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _eyebrow(whatIf.eyebrow),
        const SizedBox(height: 12),
        Text(whatIf.prompt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.35)),
        const SizedBox(height: 14),
        for (final option in whatIf.options)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _choiceTile(
              label: option.label,
              selected: _selectedWhatIf == option.id,
              onTap: () => setState(() => _selectedWhatIf = option.id),
            ),
          ),
        if (selected != null) ...[
          const SizedBox(height: 5),
          _feedbackCard(
            title: selected.feedbackTitle,
            body: selected.feedbackBody,
            positive: selected.isCorrect,
          ),
        ],
      ],
    );
  }

  Widget _buildGuidedPracticeStage() {
    final question = _currentGuidedQuestion;
    if (question == null) return const SizedBox.shrink();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      children: [
        _eyebrow('PRACTICE ${_guidedQuestionIndex + 1} OF ${_content.guidedPractice.length} · HINTS ALLOWED'),
        const SizedBox(height: 12),
        _questionPanel(question.prompt),
        const SizedBox(height: 12),
        _answerDisplay(_guidedInput),
        const SizedBox(height: 8),
        _numberPad(guided: true),
        if (_hintIndex > 0 && !_guidedChecked) ...[
          const SizedBox(height: 10),
          _feedbackCard(
            title: 'HINT $_hintIndex',
            body: question.hints[_hintIndex - 1],
            positive: false,
          ),
        ],
        if (_guidedChecked) ...[
          const SizedBox(height: 10),
          _feedbackCard(
            title: _guidedCorrect ? 'Good, that\'s it.' : 'Not quite, and that\'s fine.',
            body: _guidedCorrect
                ? question.correctFeedback
                : question.incorrectFeedback,
            positive: _guidedCorrect,
          ),
          if (!_guidedCorrect && question.solutionSteps.isNotEmpty) ...[
            const SizedBox(height: 10),
            _outlinedContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _eyebrow('HOW TO DO IT'),
                  const SizedBox(height: 7),
                  for (var i = 0; i < question.solutionSteps.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text('${i + 1}. ${question.solutionSteps[i]}', style: const TextStyle(fontSize: 12, height: 1.35)),
                    ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildThinkStage() {
    final reflection = _content.reflection;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        _eyebrow(reflection.eyebrow),
        const SizedBox(height: 10),
        Text(reflection.title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
        const SizedBox(height: 18),
        for (final group in reflection.groups) ...[
          Text(group.prompt, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final option in group.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _choiceTile(
                label: option.label,
                selected: _reflectionAnswers[group.id] == option.id,
                onTap: () => _selectReflection(group.id, option.id),
              ),
            ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildIndependentCheckStage() {
    final question = _currentCheckQuestion;
    if (question == null) return const SizedBox.shrink();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        _eyebrow('CHECK · ${_checkQuestionIndex + 1} OF ${_content.independentCheck.length} · ON YOUR OWN'),
        const SizedBox(height: 13),
        _questionPanel(question.prompt),
        const SizedBox(height: 12),
        _answerDisplay(_checkInput.isEmpty && !_checkDontKnow ? '' : _checkDontKnow ? 'I don\'t know' : _checkInput),
        const SizedBox(height: 8),
        _numberPad(guided: false),
        const SizedBox(height: 9),
        _choiceTile(
          label: "I don't know",
          selected: _checkDontKnow,
          onTap: () => setState(() {
            _checkDontKnow = !_checkDontKnow;
            if (_checkDontKnow) _checkInput = '';
          }),
          leadingIcon: Icons.help_outline,
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final score = _checkAnswers.where((answer) => answer.isCorrect).length;
    final isSolid = score >= _content.result.solidThreshold;
    final title = isSolid ? _content.result.solidTitle : _content.result.buildingTitle;
    final bodyTemplate = isSolid ? _content.result.solidBody : _content.result.buildingBody;
    final planMessage = isSolid
        ? _content.result.solidPlanMessage
        : _content.result.buildingPlanMessage;
    final confidence = _confidenceLabel();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(result: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                children: [
                  Center(
                    child: Container(
                      width: 54,
                      height: 42,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: context.colors.accent,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: context.colors.panelBorder, width: 2),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 13,
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(
                    _formatResultText(bodyTemplate, score),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, height: 1.45),
                  ),
                  const SizedBox(height: 10),
                  Text(planMessage, style: TextStyle(fontSize: 13, height: 1.45, color: context.colors.textSecondary)),
                  const SizedBox(height: 14),
                  _outlinedContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 16, color: context.colors.textSecondary),
                            const SizedBox(width: 7),
                            const Text('What shows this', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        for (var i = 0; i < _checkAnswers.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: _buildResultAnswerLine(_checkAnswers[i], confidence),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _goNextLesson,
                      style: _primaryButtonStyle(),
                      child: Text(_content.result.nextLessonLabel.replaceAll('{topic}', _topicName ?? _content.title)),
                    ),
                  ),
                  Center(
                    child: TextButton(onPressed: _goBackToToday, child: Text(_content.result.backToTodayLabel)),
                  ),
                  Center(
                    child: TextButton(onPressed: _goSeeOnMap, child: Text(_content.result.seeOnMapLabel)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultAnswerLine(PracticeAnswerResult answer, String confidence) {
    final colors = context.colors;
    final IconData icon;
    final String text;
    if (answer.didNotKnow) {
      icon = Icons.help_outline;
      text = '${answer.question}: you said you didn\'t know.';
    } else if (answer.isCorrect) {
      icon = Icons.check_circle_outline;
      text = 'You solved ${answer.question} on your own ($confidence).';
    } else {
      icon = Icons.radio_button_unchecked;
      text = '${answer.question}: you answered ${answer.givenAnswer} ($confidence).';
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 15, color: colors.textSecondary),
        ),
        const SizedBox(width: 7),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.35))),
      ],
    );
  }

  String _confidenceLabel() {
    final group = _firstOrNull(_content.reflection.groups.where((item) => item.id == 'confidence'));
    if (group == null) return 'your confidence';
    final selectedId = _reflectionAnswers[group.id];
    return _firstOrNull(group.options.where((option) => option.id == selectedId))?.label.toLowerCase() ?? 'your confidence';
  }

  String _formatResultText(String template, int score) {
    return template
        .replaceAll('{score}', '$score')
        .replaceAll('{total}', '${_checkAnswers.length}')
        .replaceAll('{topic}', _topicName ?? _content.title);
  }

  Widget _buildFooter() {
    final colors = context.colors;
    Widget primaryButton(String label, VoidCallback? onPressed) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: _primaryButtonStyle(),
          child: Text(label),
        ),
      );
    }

    Widget? secondaryAction(String label, VoidCallback onPressed) {
      return TextButton(onPressed: onPressed, child: Text(label));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 9, 16, 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: switch (_stageIndex) {
        0 => primaryButton("Let's go", _nextStage),
        1 => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              primaryButton('Next', _canContinueHaveAGo ? _nextStage : null),
              secondaryAction('Skip this step', _skipHaveAGo)!,
            ],
          ),
        2 => primaryButton('Next', _nextStage),
        3 => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              primaryButton('Next', _nextStage),
              TextButton.icon(
                onPressed: _watchPlaying ? null : _playWatchSequence,
                icon: const Icon(Icons.replay, size: 16),
                label: Text(_watchPlaying ? 'Playing…' : _content.watch.replayLabel),
              ),
            ],
          ),
        4 => primaryButton('Next', _canContinueWhatIf ? _nextStage : null),
        5 => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              primaryButton(
                _guidedChecked
                    ? (_guidedQuestionIndex == _content.guidedPractice.length - 1 ? 'Continue' : 'Next question')
                    : 'Check',
                _guidedChecked
                    ? _showNextGuidedQuestion
                    : (_guidedInput.trim().isEmpty ? null : _checkGuidedAnswer),
              ),
              if (!_guidedChecked)
                TextButton.icon(
                  onPressed: _hintIndex < (_currentGuidedQuestion?.hints.length ?? 0) ? _showHint : null,
                  icon: const Icon(Icons.lightbulb_outline, size: 16),
                  label: Text(_hintIndex == 0 ? 'Hint' : 'Another hint'),
                ),
            ],
          ),
        6 => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              primaryButton('Save and continue', _reflectionComplete ? _nextStage : null),
              secondaryAction('Skip', _nextStage)!,
            ],
          ),
        7 => primaryButton('Done', (_checkInput.trim().isNotEmpty || _checkDontKnow) ? _recordCheckAnswer : null),
        _ => const SizedBox.shrink(),
      },
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: context.colors.accent,
      foregroundColor: context.colors.onAccent,
      disabledBackgroundColor: context.colors.disabledFill,
      disabledForegroundColor: context.colors.disabledText,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
    );
  }

  Widget _eyebrow(String text) => Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          letterSpacing: .7,
          fontWeight: FontWeight.w800,
          color: context.colors.textSecondary,
        ),
      );

  Widget _infoCard({
    required String title,
    String? bodyTitle,
    required String body,
    String? footer,
    IconData? icon,
  }) {
    return _outlinedContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _eyebrow(title),
          if (icon != null) ...[
            const SizedBox(height: 9),
            Icon(icon, size: 18, color: context.colors.textSecondary),
          ],
          if (bodyTitle != null) ...[
            const SizedBox(height: 8),
            Text(bodyTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          ],
          const SizedBox(height: 6),
          Text(body, style: TextStyle(fontSize: 12, height: 1.4, color: context.colors.textSecondary)),
          if (footer != null) ...[
            const SizedBox(height: 9),
            Text(footer, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.accent)),
          ],
        ],
      ),
    );
  }

  Widget _outlinedContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.panelBorder),
      ),
      child: child,
    );
  }

  Widget _questionPanel(String prompt) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 142),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.panelBorder),
      ),
      child: Text(
        prompt,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, height: 1.25),
      ),
    );
  }

  Widget _answerDisplay(String value) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: context.colors.panelBorder),
      ),
      child: Text(
        value.isEmpty ? 'Type your answer' : value,
        style: TextStyle(
          fontSize: value.isEmpty ? 13 : 21,
          fontWeight: value.isEmpty ? FontWeight.w400 : FontWeight.w800,
          color: value.isEmpty ? context.colors.textSecondary : null,
        ),
      ),
    );
  }

  Widget _numberPad({required bool guided}) {
    final rows = const [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['negative', '0', 'backspace'],
    ];
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                for (var i = 0; i < row.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: _numberKey(
                      row[i],
                      onTap: () => _appendDigit(row[i], guided: guided),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _numberKey(String key, {required VoidCallback onTap}) {
    final isUtility = key == 'negative' || key == 'backspace';
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 43,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: context.colors.panelBorder),
          ),
          child: key == 'backspace'
              ? const Icon(Icons.backspace_outlined, size: 17)
              : key == 'negative'
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('±', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1)),
                        Text('Negative', style: TextStyle(fontSize: 8, height: 1.1)),
                      ],
                    )
                  : Text(key, style: TextStyle(fontSize: isUtility ? 15 : 18, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String left, String right) {
    return _outlinedContentCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(height: 4, decoration: BoxDecoration(color: context.colors.textSecondary, borderRadius: BorderRadius.circular(5))),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(width: 2, height: 10, color: context.colors.textSecondary),
                    _balancePan(left),
                  ],
                ),
              ),
              SizedBox(
                width: 42,
                child: Column(
                  children: [
                    Icon(Icons.change_history, size: 43, color: context.colors.textSecondary),
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: context.colors.textSecondary, borderRadius: BorderRadius.circular(5))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(width: 2, height: 10, color: context.colors.textSecondary),
                    _balancePan(right),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text('$left = $right', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _balancePan(String value) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: context.colors.panel,
        border: Border.all(color: context.colors.accent, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
    );
  }

  Widget _actionOption({
    required String label,
    required bool selected,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1 : .7,
      child: Material(
        color: context.colors.panel,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: selected ? context.colors.accent : context.colors.panelBorder),
            ),
            child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
          ),
        ),
      ),
    );
  }

  Widget _choiceTile({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    IconData? leadingIcon,
  }) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.accentContainer : colors.surface,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: selected ? colors.accent : colors.panelBorder),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle : (leadingIcon ?? Icons.radio_button_unchecked),
                size: 18,
                color: selected ? colors.onAccentContainer : colors.textSecondary,
              ),
              const SizedBox(width: 9),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedbackCard({required String title, required String body, required bool positive}) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: positive ? colors.accentContainer : colors.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: positive ? colors.accent : colors.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(body, style: const TextStyle(fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildLoadError() {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice lesson')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40),
              const SizedBox(height: 12),
              const Text('We could not load this practice lesson.'),
              const SizedBox(height: 8),
              Text('Check the JSON asset path and format.\n$_loadError', textAlign: TextAlign.center, style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
              const SizedBox(height: 16),
              FilledButton(onPressed: () { setState(() { _loading = true; _loadError = null; }); unawaited(_loadLesson()); }, child: const Text('Try again')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnavailable() {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice lesson')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.menu_book_outlined, size: 42),
              const SizedBox(height: 12),
              const Text('This guided practice lesson is not available yet.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('The topic exists in the Mathematics content bank, but it does not have a "practice_lesson" section yet.', textAlign: TextAlign.center, style: TextStyle(color: context.colors.textSecondary, fontSize: 12, height: 1.4)),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Go back')),
            ],
          ),
        ),
      ),
    );
  }
}

T? _firstOrNull<T>(Iterable<T> items) {
  for (final item in items) {
    return item;
  }
  return null;
}
