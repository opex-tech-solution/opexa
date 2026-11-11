/// Typed model for the JSON-driven, multi-stage OpexA practice lesson.
///
/// JSON uses snake_case. Dart uses lowerCamelCase. The model is deliberately
/// separate from LessonContent so the regular Teach Me and the guided Practice
/// experience can evolve independently while sharing the same topic catalog.
class PracticeLessonContent {
  const PracticeLessonContent({
    required this.id,
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

  final String id;
  final String title;
  final int estimatedMinutes;
  final bool worksOffline;
  final PracticeStartContent start;
  final HaveAGoContent haveAGo;
  final PracticeIdeaContent idea;
  final WatchContent watch;
  final WhatIfContent whatIf;
  final List<NumericPracticeQuestion> guidedPractice;
  final ReflectionContent reflection;
  final List<NumericPracticeQuestion> independentCheck;
  final PracticeResultContent result;

  factory PracticeLessonContent.fromJson(Map<String, dynamic> json) {
    return PracticeLessonContent(
      id: _string(json['id']),
      title: _string(json['title']),
      estimatedMinutes: _integer(json['estimated_minutes'], fallback: 10),
      worksOffline: _boolean(json['works_offline'], fallback: true),
      start: PracticeStartContent.fromJson(_object(json['start'], 'start')),
      haveAGo: HaveAGoContent.fromJson(
        _object(json['have_a_go'], 'have_a_go'),
      ),
      idea: PracticeIdeaContent.fromJson(_object(json['idea'], 'idea')),
      watch: WatchContent.fromJson(_object(json['watch'], 'watch')),
      whatIf: WhatIfContent.fromJson(_object(json['what_if'], 'what_if')),
      guidedPractice: _objects(
        json['guided_practice'],
        'guided_practice',
      ).map(NumericPracticeQuestion.fromJson).toList(growable: false),
      reflection: ReflectionContent.fromJson(
        _object(json['reflection'], 'reflection'),
      ),
      independentCheck: _objects(
        json['independent_check'],
        'independent_check',
      ).map(NumericPracticeQuestion.fromJson).toList(growable: false),
      result: PracticeResultContent.fromJson(
        _object(json['result'], 'result'),
      ),
    );
  }
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

  factory PracticeStartContent.fromJson(Map<String, dynamic> json) {
    return PracticeStartContent(
      classLabel: _string(json['class_label'], fallback: 'CLASS · NEW LESSON'),
      lessonStartsTitle: _string(json['lesson_starts_title']),
      lessonStartsBody: _string(json['lesson_starts_body']),
      differentWayLabel: _string(json['different_way_label']),
      whyItMatters: _string(json['why_it_matters']),
      learningOutcome: _string(json['learning_outcome']),
    );
  }
}

class HaveAGoContent {
  const HaveAGoContent({
    required this.eyebrow,
    required this.intro,
    required this.prompt,
    required this.steps,
  });

  final String eyebrow;
  final String intro;
  final String prompt;
  final List<EquationMoveStep> steps;

  factory HaveAGoContent.fromJson(Map<String, dynamic> json) {
    return HaveAGoContent(
      eyebrow: _string(json['eyebrow'], fallback: 'HAVE A GO FIRST'),
      intro: _string(json['intro']),
      prompt: _string(json['prompt']),
      steps: _objects(json['steps'], 'have_a_go.steps')
          .map(EquationMoveStep.fromJson)
          .toList(growable: false),
    );
  }
}

class EquationMoveStep {
  const EquationMoveStep({
    required this.equationLeft,
    required this.equationRight,
    required this.correctMoveId,
    required this.moves,
    required this.resultLeft,
    required this.resultRight,
    required this.successCaption,
  });

  final String equationLeft;
  final String equationRight;
  final String correctMoveId;
  final List<EquationMoveOption> moves;
  final String resultLeft;
  final String resultRight;
  final String successCaption;

  factory EquationMoveStep.fromJson(Map<String, dynamic> json) {
    return EquationMoveStep(
      equationLeft: _string(json['equation_left']),
      equationRight: _string(json['equation_right']),
      correctMoveId: _string(json['correct_move_id']),
      moves: _objects(json['moves'], 'have_a_go.moves')
          .map(EquationMoveOption.fromJson)
          .toList(growable: false),
      resultLeft: _string(json['result_left']),
      resultRight: _string(json['result_right']),
      successCaption: _string(json['success_caption']),
    );
  }
}

class EquationMoveOption {
  const EquationMoveOption({
    required this.id,
    required this.label,
    required this.feedback,
  });

  final String id;
  final String label;
  final String feedback;

  factory EquationMoveOption.fromJson(Map<String, dynamic> json) {
    return EquationMoveOption(
      id: _string(json['id']),
      label: _string(json['label']),
      feedback: _string(json['feedback']),
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

  factory PracticeIdeaContent.fromJson(Map<String, dynamic> json) {
    return PracticeIdeaContent(
      eyebrow: _string(json['eyebrow'], fallback: 'THE IDEA'),
      title: _string(json['title']),
      body: _string(json['body']),
      exampleLabel: _string(json['example_label'], fallback: 'EXAMPLE'),
      example: _string(json['example']),
    );
  }
}

class WatchContent {
  const WatchContent({required this.eyebrow, required this.steps, required this.replayLabel});

  final String eyebrow;
  final List<WatchStepContent> steps;
  final String replayLabel;

  factory WatchContent.fromJson(Map<String, dynamic> json) {
    return WatchContent(
      eyebrow: _string(json['eyebrow'], fallback: 'WATCH'),
      steps: _objects(json['steps'], 'watch.steps')
          .map(WatchStepContent.fromJson)
          .toList(growable: false),
      replayLabel: _string(json['replay_label'], fallback: 'Play again'),
    );
  }
}

class WatchStepContent {
  const WatchStepContent({
    required this.equationLeft,
    required this.equationRight,
    required this.caption,
  });

  final String equationLeft;
  final String equationRight;
  final String caption;

  factory WatchStepContent.fromJson(Map<String, dynamic> json) {
    return WatchStepContent(
      equationLeft: _string(json['equation_left']),
      equationRight: _string(json['equation_right']),
      caption: _string(json['caption']),
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

  factory WhatIfContent.fromJson(Map<String, dynamic> json) {
    return WhatIfContent(
      eyebrow: _string(json['eyebrow'], fallback: 'WHAT HAPPENS IF...?'),
      prompt: _string(json['prompt']),
      options: _objects(json['options'], 'what_if.options')
          .map(WhatIfOption.fromJson)
          .toList(growable: false),
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

  factory WhatIfOption.fromJson(Map<String, dynamic> json) {
    return WhatIfOption(
      id: _string(json['id']),
      label: _string(json['label']),
      isCorrect: _boolean(json['is_correct']),
      feedbackTitle: _string(json['feedback_title']),
      feedbackBody: _string(json['feedback_body']),
    );
  }
}

class NumericPracticeQuestion {
  const NumericPracticeQuestion({
    required this.id,
    required this.prompt,
    required this.answer,
    required this.hints,
    required this.explanation,
    required this.correctFeedback,
    required this.incorrectFeedback,
    required this.solutionSteps,
  });

  final String id;
  final String prompt;
  final String answer;
  final List<String> hints;
  final String explanation;
  final String correctFeedback;
  final String incorrectFeedback;
  final List<String> solutionSteps;

  factory NumericPracticeQuestion.fromJson(Map<String, dynamic> json) {
    return NumericPracticeQuestion(
      id: _string(json['id']),
      prompt: _string(json['prompt']),
      answer: _string(json['answer']),
      hints: _strings(json['hints']),
      explanation: _string(json['explanation'] ?? json['correct_feedback']),
      correctFeedback: _string(json['correct_feedback'] ?? json['explanation']),
      incorrectFeedback: _string(json['incorrect_feedback'] ?? json['explanation']),
      solutionSteps: _strings(json['solution_steps']),
    );
  }

}

class ReflectionContent {
  const ReflectionContent({required this.eyebrow, required this.title, required this.groups});

  final String eyebrow;
  final String title;
  final List<ReflectionGroup> groups;

  factory ReflectionContent.fromJson(Map<String, dynamic> json) {
    return ReflectionContent(
      eyebrow: _string(json['eyebrow'], fallback: 'THINK'),
      title: _string(json['title'], fallback: 'A moment to think'),
      groups: _objects(json['groups'], 'reflection.groups')
          .map(ReflectionGroup.fromJson)
          .toList(growable: false),
    );
  }
}

class ReflectionGroup {
  const ReflectionGroup({required this.id, required this.prompt, required this.options});

  final String id;
  final String prompt;
  final List<ReflectionOption> options;

  factory ReflectionGroup.fromJson(Map<String, dynamic> json) {
    return ReflectionGroup(
      id: _string(json['id']),
      prompt: _string(json['prompt']),
      options: _objects(json['options'], 'reflection.options')
          .map(ReflectionOption.fromJson)
          .toList(growable: false),
    );
  }
}

class ReflectionOption {
  const ReflectionOption({required this.id, required this.label});

  final String id;
  final String label;

  factory ReflectionOption.fromJson(Map<String, dynamic> json) {
    return ReflectionOption(id: _string(json['id']), label: _string(json['label']));
  }
}

class PracticeResultContent {
  const PracticeResultContent({
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

  factory PracticeResultContent.fromJson(Map<String, dynamic> json) {
    return PracticeResultContent(
      solidThreshold: _integer(json['solid_threshold'], fallback: 3),
      buildingTitle: _string(json['building_title'], fallback: "Not yet, and that's fine"),
      buildingBody: _string(json['building_body']),
      buildingPlanMessage: _string(json['building_plan_message']),
      solidTitle: _string(json['solid_title'], fallback: 'Good work'),
      solidBody: _string(json['solid_body']),
      solidPlanMessage: _string(json['solid_plan_message']),
      nextLessonLabel: _string(json['next_lesson_label'], fallback: 'Next lesson'),
      backToTodayLabel: _string(json['back_to_today_label'], fallback: 'Back to Today'),
      seeOnMapLabel: _string(json['see_on_map_label'], fallback: 'See it on my map'),
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
  });

  final String question;
  final String? givenAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final bool didNotKnow;
}

Map<String, dynamic> _object(dynamic value, String fieldName) {
  if (value is Map) return Map<String, dynamic>.from(value);
  throw FormatException('Expected "$fieldName" to be a JSON object.');
}

List<Map<String, dynamic>> _objects(dynamic value, String fieldName) {
  if (value == null) return const [];
  if (value is! List) throw FormatException('Expected "$fieldName" to be a list.');
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

bool _boolean(dynamic value, {bool fallback = false}) =>
    value is bool ? value : fallback;
