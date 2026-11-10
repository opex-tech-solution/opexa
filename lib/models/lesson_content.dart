class LessonContentCatalog {
  const LessonContentCatalog({
    required this.schemaVersion,
    required this.contentId,
    required this.subject,
    required this.language,
    required this.contentNotes,
    required this.topics,
  });

  final String schemaVersion;
  final String contentId;
  final SubjectContent subject;
  final String language;
  final List<String> contentNotes;
  final List<TopicContent> topics;

  factory LessonContentCatalog.fromJson(Map<String, dynamic> json) {
    return LessonContentCatalog(
      schemaVersion: _stringValue(json['schema_version'], fallback: '1.0.0'),
      contentId: _stringValue(json['content_id']),
      subject: SubjectContent.fromJson(
        _mapValue(json['subject'], fieldName: 'subject'),
      ),
      language: _stringValue(json['language'], fallback: 'en'),
      contentNotes: _stringList(json['content_notes']),
      topics: _mapList(json['topics'], fieldName: 'topics')
          .map(TopicContent.fromJson)
          .toList(growable: false),
    );
  }

  TopicContent? topicById(String id) {
    for (final topic in topics) {
      if (topic.id == id) return topic;
    }
    return null;
  }
}

class SubjectContent {
  const SubjectContent({required this.id, required this.name});

  final String id;
  final String name;

  factory SubjectContent.fromJson(Map<String, dynamic> json) {
    return SubjectContent(
      id: _stringValue(json['id']),
      name: _stringValue(json['name']),
    );
  }
}

class TopicContent {
  const TopicContent({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.summary,
    required this.level,
    required this.estimatedLessonMinutes,
    required this.lessonSteps,
    required this.practiceQuestions,
    this.mapLabel,
    this.mapGroup,
    this.mapBand,
  });

  final String id;
  final String name;
  final String subjectId;
  final String summary;
  final String level;
  final int estimatedLessonMinutes;
  final List<LessonStepContent> lessonSteps;
  final List<AssessmentQuestion> practiceQuestions;

  /// Exact label used by the Maps brick, e.g. "Add & subtract integers".
  final String? mapLabel;

  /// Map section identifier: stretch, your_class or foundations.
  final String? mapGroup;

  /// Human-readable Map band, e.g. "JSS2 blocks".
  final String? mapBand;

  factory TopicContent.fromJson(Map<String, dynamic> json) {
    return TopicContent(
      id: _stringValue(json['id']),
      name: _stringValue(json['name']),
      subjectId: _stringValue(json['subject_id']),
      summary: _stringValue(json['summary']),
      level: _stringValue(json['level']),
      estimatedLessonMinutes: _intValue(json['estimated_lesson_minutes']),
      lessonSteps: _mapList(json['lesson_steps'], fieldName: 'lesson_steps')
          .map(LessonStepContent.fromJson)
          .toList(growable: false),
      practiceQuestions:
          _mapList(json['practice_questions'], fieldName: 'practice_questions')
              .map(AssessmentQuestion.fromJson)
              .toList(growable: false),
      mapLabel: _nullableString(json['map_label']),
      mapGroup: _nullableString(json['map_group']),
      mapBand: _nullableString(json['map_band']),
    );
  }

  LessonStepContent? getStepById(String stepId) {
    for (final step in lessonSteps) {
      if (step.id == stepId) return step;
    }
    return null;
  }
}

class LessonStepContent {
  const LessonStepContent({
    required this.id,
    required this.section,
    required this.title,
    required this.body,
    this.equation,
    this.workedSteps = const [],
    this.callout,
    this.quickCheck,
  });

  final String id;
  final String section;
  final String title;
  final String body;
  final String? equation;
  final List<WorkedExampleStep> workedSteps;
  final LessonCallout? callout;
  final AssessmentQuestion? quickCheck;

  factory LessonStepContent.fromJson(Map<String, dynamic> json) {
    final calloutJson = json['callout'];
    final quickCheckJson = json['quick_check'];

    return LessonStepContent(
      id: _stringValue(json['id']),
      section: _stringValue(json['section']),
      title: _stringValue(json['title']),
      body: _stringValue(json['body']),
      equation: _nullableString(json['equation']),
      workedSteps: _mapList(json['worked_steps'], fieldName: 'worked_steps')
          .map(WorkedExampleStep.fromJson)
          .toList(growable: false),
      callout: calloutJson is Map
          ? LessonCallout.fromJson(Map<String, dynamic>.from(calloutJson))
          : null,
      quickCheck: quickCheckJson is Map
          ? AssessmentQuestion.fromJson(
              Map<String, dynamic>.from(quickCheckJson),
            )
          : null,
    );
  }
}

class WorkedExampleStep {
  const WorkedExampleStep({required this.heading, required this.explanation});

  final String heading;
  final String explanation;

  factory WorkedExampleStep.fromJson(Map<String, dynamic> json) {
    return WorkedExampleStep(
      heading: _stringValue(json['heading']),
      explanation: _stringValue(json['explanation']),
    );
  }
}

class LessonCallout {
  const LessonCallout({required this.title, required this.body});

  final String title;
  final String body;

  factory LessonCallout.fromJson(Map<String, dynamic> json) {
    return LessonCallout(
      title: _stringValue(json['title']),
      body: _stringValue(json['body']),
    );
  }
}

/// Used by both the lesson's quick check and the topic's practice questions.
class AssessmentQuestion {
  const AssessmentQuestion({
    required this.id,
    required this.prompt,
    required this.type,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    required this.difficulty,
    this.body = '',
    this.speechText,
  });

  final String id;
  final String prompt;
  final String body;
  final String type;
  final String? speechText;
  final List<AnswerOption> options;
  final String correctOptionId;
  final String explanation;
  final String difficulty;

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: _stringValue(json['id']),
      prompt: _stringValue(json['prompt']),
      body: _stringValue(json['body']),
      type: _stringValue(json['type'], fallback: 'multiple_choice'),
      speechText: _nullableString(json['speech_text']),
      options: _mapList(json['options'], fieldName: 'options')
          .map(AnswerOption.fromJson)
          .toList(growable: false),
      correctOptionId: _stringValue(json['correct_option_id']),
      explanation: _stringValue(json['explanation']),
      difficulty: _stringValue(json['difficulty'], fallback: 'unspecified'),
    );
  }

  bool isCorrect(String? selectedOptionId) =>
      selectedOptionId != null && selectedOptionId == correctOptionId;

  AnswerOption? get correctOption {
    for (final option in options) {
      if (option.id == correctOptionId) return option;
    }
    return null;
  }
}

class AnswerOption {
  const AnswerOption({required this.id, required this.text});

  final String id;
  final String text;

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: _stringValue(json['id']),
      text: _stringValue(json['text']),
    );
  }
}

String _stringValue(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}

String? _nullableString(Object? value) {
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}

int _intValue(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList(growable: false);
}

List<Map<String, dynamic>> _mapList(
  Object? value, {
  required String fieldName,
}) {
  if (value == null) return const [];
  if (value is! List) {
    throw FormatException('Expected "$fieldName" to be a JSON array.');
  }

  return value.map((item) {
    if (item is! Map) {
      throw FormatException(
        'Expected each item in "$fieldName" to be a JSON object.',
      );
    }
    return Map<String, dynamic>.from(item);
  }).toList(growable: false);
}

Map<String, dynamic> _mapValue(
  Object? value, {
  required String fieldName,
}) {
  if (value is Map) return Map<String, dynamic>.from(value);
  throw FormatException('Expected "$fieldName" to be a JSON object.');
}
