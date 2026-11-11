import 'skill.dart';

/// One row in "Your learning list".
class LearningListTopic {
  const LearningListTopic({
    required this.topicId,
    required this.name,
    required this.minutes,
    this.brick = BrickState.unchecked,
    this.startHere = false,
  });

  /// Same ID the Teach Me and Practice lessons use (`Skill.contentId`).
  final String topicId;
  final String name;
  final int minutes;
  final BrickState brick;
  final bool startHere;

  factory LearningListTopic.fromJson(Map<String, dynamic> json) {
    return LearningListTopic(
      topicId: '${json['topic_id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      minutes: json['minutes'] is int ? json['minutes'] as int : 5,
      brick: _brick('${json['brick'] ?? ''}'),
      startHere: json['start_here'] == true,
    );
  }

  static BrickState _brick(String value) => switch (value) {
        'building' => BrickState.building,
        'solid' => BrickState.solid,
        'mastered' => BrickState.mastered,
        'locked_in' => BrickState.lockedIn,
        'not_sure' => BrickState.notSure,
        _ => BrickState.unchecked,
      };
}

/// "Your class", "Stretch", "Not checked yet".
class LearningListSection {
  const LearningListSection({
    required this.id,
    required this.title,
    required this.trailing,
    required this.topics,
    this.caption,
  });

  final String id;
  final String title;
  final String trailing; // "JSS2", "When you’re ready", ...
  final String? caption;
  final List<LearningListTopic> topics;

  factory LearningListSection.fromJson(Map<String, dynamic> json) {
    final raw = json['topics'];
    return LearningListSection(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? ''}',
      trailing: '${json['trailing'] ?? ''}',
      caption: json['caption'] as String?,
      topics: raw is List
          ? [
              for (final t in raw)
                if (t is Map) LearningListTopic.fromJson(Map<String, dynamic>.from(t)),
            ]
          : const [],
    );
  }
}

class LearningListData {
  const LearningListData({
    required this.intro,
    required this.introNote,
    required this.sections,
    this.initialState = const {},
  });

  final String intro;
  final String introNote;
  final List<LearningListSection> sections;

  /// Demo seed for the progress store (see assets/json/learning_list.json).
  final Map<String, dynamic> initialState;

  factory LearningListData.fromJson(Map<String, dynamic> json) {
    final raw = json['sections'];
    final seed = json['initial_state'];
    return LearningListData(
      intro: '${json['intro'] ?? ''}',
      introNote: '${json['intro_note'] ?? ''}',
      sections: raw is List
          ? [
              for (final s in raw)
                if (s is Map) LearningListSection.fromJson(Map<String, dynamic>.from(s)),
            ]
          : const [],
      initialState: seed is Map ? Map<String, dynamic>.from(seed) : const {},
    );
  }

  Iterable<LearningListTopic> get allTopics sync* {
    for (final s in sections) {
      yield* s.topics;
    }
  }

  /// "3 topics to learn. Next: Two-step equations" for the launcher cards.
  String get summary {
    final classTopics = sections.isEmpty ? const <LearningListTopic>[] : sections.first.topics;
    if (classTopics.isEmpty) return 'Nothing to learn right now.';
    final next = classTopics.firstWhere((t) => t.startHere, orElse: () => classTopics.first);
    return '${classTopics.length} topics to learn. Next: ${next.name}';
  }
}
