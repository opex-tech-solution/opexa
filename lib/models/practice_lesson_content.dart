/// Typed model for the JSON-driven, multi-stage OpexA practice lesson.
///
/// JSON uses snake_case. Dart uses lowerCamelCase. The model is deliberately
/// separate from LessonContent so the regular Teach Me and the guided Practice
/// experience can evolve independently while sharing the same topic catalog.
class PracticeLessonContent {
  const PracticeLessonContent({
    required this.topicId,
    required this.title,
    required this.estimatedMinutes,
    required this.worksOffline,
    required this.start,
    required this.haveAGo,
    required this.idea,
    required this.watch,
    required this.whatIf,
    required this.guidedPractice,
    required this.reflection,
    required this.independentCheck,
    required this.result,
  });

  final String topicId;
  final String title;
  final int estimatedMinutes;
  final bool worksOffline;
  final PracticeStartContent start;
  final HaveAGoContent haveAGo;
  final PracticeIdeaContent idea;
  final WatchContent watch;
  final WhatIfContent whatIf;
  final List<PracticeQuestion> guidedPractice;
  final ReflectionContent reflection;
  final List<PracticeQuestion> independentCheck;
  final PracticeResultContent result;

  factory PracticeLessonContent.fromTopicJson({
    required String topicId,
    required String topicName,
    required String topicLevel,
    required String topicSummary,
    required Map<String, dynamic> json,
  }) {
    final stages = {
      for (final stage in _objects(json['stages'], 'practice_lesson.stages'))
        _string(stage['id']): stage,
    };
    final start = _requiredStage(stages, 'start');
    final haveAGo = _requiredStage(stages, 'have_a_go');
    final idea = _requiredStage(stages, 'the_idea');
    final watch = _requiredStage(stages, 'watch');
    final whatIf = _requiredStage(stages, 'what_if');
    final guidedPractice = _requiredStage(stages, 'guided_practice');
    final reflection = _requiredStage(stages, 'reflection');
    final independentCheck = _requiredStage(stages, 'independent_check');
    final objectives = _strings(json['learning_objectives']);
    final watchContent = WatchContent.fromCatalogJson(watch);
    final guidedQuestions = _objects(
      guidedPractice['questions'],
      'stages.guided_practice.questions',
    ).map(PracticeQuestion.fromJson).toList(growable: false);
    final checkQuestions = _objects(
      independentCheck['questions'],
      'stages.independent_check.questions',
    ).map(PracticeQuestion.fromJson).toList(growable: false);

    if (watchContent.steps.isEmpty ||
        guidedQuestions.isEmpty ||
        checkQuestions.isEmpty) {
      throw const FormatException(
        'Practice lessons require worked steps, guided questions, and an independent check.',
      );
    }

    return PracticeLessonContent(
      topicId: topicId,
      title: topicName,
      estimatedMinutes: _integer(json['estimated_minutes'], fallback: 10),
      worksOffline: true,
      start: PracticeStartContent(
        classLabel: 'MATHS · $topicLevel',
        lessonStartsTitle: _string(start['title']),
        lessonStartsBody: _string(start['body']),
        differentWayLabel: _string(start['purpose']),
        whyItMatters: topicSummary,
        learningOutcome: objectives.join('\n'),
      ),
      haveAGo: HaveAGoContent.fromCatalogJson(haveAGo),
      idea: PracticeIdeaContent(
        eyebrow: 'THE IDEA',
        title: _string(idea['title']),
        body: _string(idea['body']),
        exampleLabel: 'KEY IDEA',
        example: _string(idea['key_point']),
      ),
      watch: watchContent,
      whatIf: WhatIfContent.fromQuestion(
        _object(whatIf['question'], 'stages.what_if.question'),
        prompt: _string(whatIf['prompt']),
      ),
      guidedPractice: guidedQuestions,
      reflection: ReflectionContent.fromCatalogJson(reflection),
      independentCheck: checkQuestions,
      result: PracticeResultContent.fromCompletion(
        _object(json['completion'], 'practice_lesson.completion'),
        independentCheckCount: checkQuestions.length,
      ),
    );
  }
}

Map<String, dynamic> _requiredStage(
  Map<String, Map<String, dynamic>> stages,
  String id,
) {
  final stage = stages[id];
  if (stage == null) {
    throw FormatException('The practice lesson is missing the "$id" stage.');
  }
  return stage;
}

class PracticeStartContent {
  const PracticeStartContent({
    required this.classLabel,
    required this.lessonStartsTitle,
    required this.lessonStartsBody,
    required this.differentWayLabel,
    required this.whyItMatters,
    required this.learningOutcome,
  });

  final String classLabel;
  final String lessonStartsTitle;
  final String lessonStartsBody;
  final String differentWayLabel;
  final String whyItMatters;
  final String learningOutcome;
}

class HaveAGoContent {
  const HaveAGoContent({
    required this.eyebrow,
    required this.intro,
    required this.prompt,
    required this.question,
  });

  final String eyebrow;
  final String intro;
  final String prompt;
  final PracticeQuestion question;

  factory HaveAGoContent.fromCatalogJson(Map<String, dynamic> json) {
    return HaveAGoContent(
      eyebrow: _string(json['title'], fallback: 'HAVE A GO FIRST'),
      intro: _string(json['instruction']),
      prompt: _string(
        _object(json['question'], 'stages.have_a_go.question')['prompt'],
      ),
      question: PracticeQuestion.fromJson(
        _object(json['question'], 'stages.have_a_go.question'),
      ),
    );
  }
}

class PracticeIdeaContent {
  const PracticeIdeaContent({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.exampleLabel,
    required this.example,
  });

  final String eyebrow;
  final String title;
  final String body;
  final String exampleLabel;
  final String example;
}

class WatchContent {
  const WatchContent({
    required this.eyebrow,
    required this.exampleTitle,
    required this.prompt,
    required this.equation,
    required this.steps,
    required this.replayLabel,
  });

  final String eyebrow;
  final String exampleTitle;
  final String prompt;
  final String equation;
  final List<WatchStepContent> steps;
  final String replayLabel;

  factory WatchContent.fromCatalogJson(Map<String, dynamic> json) {
    return WatchContent(
      eyebrow: _string(json['title'], fallback: 'WATCH'),
      exampleTitle: _string(json['example_title']),
      prompt: _string(json['prompt']),
      equation: _string(json['equation']),
      steps: _objects(
        json['steps'],
        'watch.steps',
      ).map(WatchStepContent.fromJson).toList(growable: false),
      replayLabel: 'Play again',
    );
  }
}

class WatchStepContent {
  const WatchStepContent({required this.heading, required this.explanation});

  final String heading;
  final String explanation;

  factory WatchStepContent.fromJson(Map<String, dynamic> json) {
    return WatchStepContent(
      heading: _string(json['heading']),
      explanation: _string(json['explanation']),
    );
  }
}

class WhatIfContent {
  const WhatIfContent({
    required this.eyebrow,
    required this.prompt,
    required this.options,
  });

  final String eyebrow;
  final String prompt;
  final List<WhatIfOption> options;

  factory WhatIfContent.fromQuestion(
    Map<String, dynamic> question, {
    required String prompt,
  }) {
    final practiceQuestion = PracticeQuestion.fromJson(question);
    return WhatIfContent(
      eyebrow: 'WHAT IF?',
      prompt: prompt.isEmpty ? practiceQuestion.prompt : prompt,
      options: [
        for (final option in practiceQuestion.options)
          WhatIfOption(
            id: option.id,
            label: option.label,
            isCorrect: option.id == practiceQuestion.correctOptionId,
            feedbackTitle: option.id == practiceQuestion.correctOptionId
                ? 'That is correct'
                : 'Not quite',
            feedbackBody: practiceQuestion.explanation,
          ),
      ],
    );
  }
}

class WhatIfOption {
  const WhatIfOption({
    required this.id,
    required this.label,
    required this.isCorrect,
    required this.feedbackTitle,
    required this.feedbackBody,
  });

  final String id;
  final String label;
  final bool isCorrect;
  final String feedbackTitle;
  final String feedbackBody;
}

class PracticeQuestion {
  const PracticeQuestion({
    required this.id,
    required this.prompt,
    required this.explanation,
    required this.options,
    required this.correctOptionId,
  });

  final String id;
  final String prompt;
  final String explanation;
  final List<PracticeQuestionOption> options;
  final String correctOptionId;
  String get answer =>
      options.firstWhere((option) => option.id == correctOptionId).label;

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    final options = _objects(
      json['options'],
      'question.options',
    ).map(PracticeQuestionOption.fromJson).toList(growable: false);
    final correctOptionId = _string(json['correct_option_id']);
    final correctOption = options.where(
      (option) => option.id == correctOptionId,
    );
    if (correctOptionId.isEmpty || correctOption.isEmpty) {
      throw FormatException(
        'Question "${_string(json['id'])}" has no matching correct option.',
      );
    }
    final explanation = _string(json['explanation']);

    return PracticeQuestion(
      id: _string(json['id']),
      prompt: _string(json['prompt']),
      explanation: explanation,
      options: options,
      correctOptionId: correctOptionId,
    );
  }
}

class PracticeQuestionOption {
  const PracticeQuestionOption({required this.id, required this.label});

  final String id;
  final String label;

  factory PracticeQuestionOption.fromJson(Map<String, dynamic> json) {
    return PracticeQuestionOption(
      id: _string(json['id']),
      label: _string(json['text']),
    );
  }
}

class ReflectionContent {
  const ReflectionContent({
    required this.eyebrow,
    required this.title,
    required this.groups,
  });

  final String eyebrow;
  final String title;
  final List<ReflectionGroup> groups;

  factory ReflectionContent.fromCatalogJson(Map<String, dynamic> json) {
    return ReflectionContent(
      eyebrow: _string(json['title'], fallback: 'THINK'),
      title: _string(json['purpose'], fallback: 'A moment to think'),
      groups: _objects(
        json['prompts'],
        'stages.reflection.prompts',
      ).map(ReflectionGroup.fromCatalogJson).toList(growable: false),
    );
  }
}

class ReflectionGroup {
  const ReflectionGroup({
    required this.id,
    required this.prompt,
    required this.options,
  });

  final String id;
  final String prompt;
  final List<ReflectionOption> options;

  factory ReflectionGroup.fromCatalogJson(Map<String, dynamic> json) {
    return ReflectionGroup(
      id: _string(json['id']),
      prompt: _string(json['question']),
      options: _objects(
        json['options'],
        'reflection.prompt.options',
      ).map(ReflectionOption.fromCatalogJson).toList(growable: false),
    );
  }
}

class ReflectionOption {
  const ReflectionOption({required this.id, required this.label});

  final String id;
  final String label;

  factory ReflectionOption.fromCatalogJson(Map<String, dynamic> json) {
    return ReflectionOption(
      id: _string(json['id']),
      label: _string(json['label']),
    );
  }
}

class PracticeResultContent {
  const PracticeResultContent({
    required this.showScore,
    required this.showCorrectAnswers,
    required this.showExplanations,
    required this.recommendedNextActions,
    required this.solidThreshold,
    required this.buildingTitle,
    required this.buildingBody,
    required this.buildingPlanMessage,
    required this.solidTitle,
    required this.solidBody,
    required this.solidPlanMessage,
    required this.nextLessonLabel,
    required this.backToTodayLabel,
    required this.seeOnMapLabel,
  });

  final bool showScore;
  final bool showCorrectAnswers;
  final bool showExplanations;
  final List<String> recommendedNextActions;
  final int solidThreshold;
  final String buildingTitle;
  final String buildingBody;
  final String buildingPlanMessage;
  final String solidTitle;
  final String solidBody;
  final String solidPlanMessage;
  final String nextLessonLabel;
  final String backToTodayLabel;
  final String seeOnMapLabel;

  factory PracticeResultContent.fromCompletion(
    Map<String, dynamic> json, {
    required int independentCheckCount,
  }) {
    return PracticeResultContent(
      showScore: _boolean(json['show_score'], fallback: true),
      showCorrectAnswers: _boolean(
        json['show_correct_answers'],
        fallback: true,
      ),
      showExplanations: _boolean(json['show_explanations'], fallback: true),
      recommendedNextActions: _strings(json['recommended_next_action']),
      solidThreshold: (independentCheckCount * 0.75).ceil(),
      buildingTitle: "Not yet, and that's fine",
      buildingBody:
          'You got {score} out of {total} questions correct on {topic}.',
      buildingPlanMessage: 'Keep practising this topic to build confidence.',
      solidTitle: 'Good work',
      solidBody: 'You got {score} out of {total} questions correct on {topic}.',
      solidPlanMessage: 'Your answers show that this skill is becoming solid.',
      nextLessonLabel: 'Continue learning {topic}',
      backToTodayLabel: 'Back to the Map',
      seeOnMapLabel: 'See it on my Map',
    );
  }
}

class PracticeLessonResult {
  const PracticeLessonResult({
    required this.topicId,
    required this.topicName,
    required this.correctCount,
    required this.totalQuestions,
    required this.answers,
    required this.reflections,
    required this.status,
  });

  final String topicId;
  final String topicName;
  final int correctCount;
  final int totalQuestions;
  final List<PracticeAnswerResult> answers;
  final Map<String, String> reflections;
  final String status;
}

class PracticeAnswerResult {
  const PracticeAnswerResult({
    required this.question,
    required this.givenAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.didNotKnow,
    required this.explanation,
  });

  final String question;
  final String? givenAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final bool didNotKnow;
  final String explanation;
}

Map<String, dynamic> _object(dynamic value, String fieldName) {
  if (value is Map) return Map<String, dynamic>.from(value);
  throw FormatException('Expected "$fieldName" to be a JSON object.');
}

List<Map<String, dynamic>> _objects(dynamic value, String fieldName) {
  if (value == null) return const [];
  if (value is! List) {
    throw FormatException('Expected "$fieldName" to be a list.');
  }
  return value.map((item) => _object(item, fieldName)).toList(growable: false);
}

List<String> _strings(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList(growable: false);
}

String _string(dynamic value, {String fallback = ''}) =>
    value is String ? value : fallback;

int _integer(dynamic value, {required int fallback}) =>
    value is int ? value : int.tryParse(value?.toString() ?? '') ?? fallback;

bool _boolean(dynamic value, {required bool fallback}) =>
    value is bool ? value : fallback;
