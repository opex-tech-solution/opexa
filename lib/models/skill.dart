/// Represents the learner's current state for a skill brick on the Map.
enum BrickState { unchecked, notSure, building, solid, mastered, lockedIn }

/// A skill shown on the OpexA learning Map.
///
/// `topicId` is the stable identifier shared by all learning experiences
/// associated with this skill. Teach Me and Practice Lesson use the same ID
/// to retrieve their own content from the topic record in the JSON content bank.
class Skill {
  const Skill(
    this.name,
    this.state, {
    this.trending = false,
    String? topicId,
    String? contentId,
  }) : topicId = topicId ?? contentId;

  /// Human-readable skill name displayed on the Map.
  final String name;

  /// The learner's current progress state for this skill.
  final BrickState state;

  /// Whether this skill should display the trending indicator on the Map.
  final bool trending;

  /// Stable topic ID used by Teach Me and Practice Lesson repositories.
  ///
  /// Example: `two_step_equations`.
  ///
  /// The Teach Me repository uses this ID to retrieve lesson steps, examples
  /// and quick checks. The Practice Lesson repository uses the same ID to
  /// retrieve guided practice, hints, reflection prompts and independent checks.
  ///
  /// It is nullable to preserve compatibility with skills without catalog
  /// content. [contentId] remains as a compatibility alias.
  final String? topicId;

  String? get contentId => topicId;
}

/// Organises skill bricks into the three learning sections displayed on the Map.
class WallData {
  const WallData({
    required this.stretch,
    required this.klass,
    required this.foundations,
  });

  final List<List<Skill>> stretch;
  final List<List<Skill>> klass;
  final List<List<Skill>> foundations;

  /// Provides every skill on the Map, regardless of its section.
  Iterable<Skill> get all sync* {
    for (final section in [stretch, klass, foundations]) {
      for (final row in section) {
        yield* row;
      }
    }
  }

  /// Counts skills currently in the supplied progress state.
  int count(BrickState state) =>
      all.where((skill) => skill.state == state).length;
}

/// Sample Mathematics wall based on the OpexA Map reference.
///
/// Each skill with available learning content is connected to the JSON content
/// bank through `topicId`. Both Teach Me and Practice Lesson resolve content
/// through that same ID; they do not need separate Skill models or IDs.
WallData buildWall({bool afterFirstCheck = false}) {
  const unchecked = BrickState.unchecked;

  return WallData(
    stretch: const [
      [
        Skill(
          'Simultaneous equations',
          unchecked,
          topicId: 'simultaneous_equations',
        ),
      ],
    ],
    klass: const [
      [
        Skill('Harder equations', unchecked, topicId: 'harder_equations'),
        Skill('Word problems', unchecked, topicId: 'word_problems'),
        Skill('Expanding brackets', unchecked, topicId: 'expanding_brackets'),
      ],
      [Skill('Two-step equations', unchecked, topicId: 'two_step_equations')],
    ],
    foundations: [
      const [
        Skill('Substituting', unchecked, topicId: 'substitution'),
        Skill(
          'Multiply & divide integers',
          unchecked,
          topicId: 'multiplying_dividing_integers',
        ),
        Skill('Simplifying', unchecked, topicId: 'simplifying_expressions'),
      ],
      [
        Skill(
          'One-step equations',
          afterFirstCheck ? BrickState.notSure : BrickState.solid,
          topicId: 'one_step_equations',
        ),
        Skill(
          'Add & subtract integers',
          unchecked,
          topicId: 'addition_subtraction_integers',
        ),
        Skill('Negative numbers', unchecked, topicId: 'negative_numbers'),
      ],
      const [
        Skill('Order of operations', unchecked, topicId: 'order_of_operations'),
        Skill(
          'Letters for numbers',
          BrickState.solid,
          trending: true,
          topicId: 'letters_for_numbers',
        ),
        Skill('Whole numbers', unchecked, topicId: 'whole_numbers'),
      ],
    ],
  );
}
