enum BrickState { unchecked, notSure, building, solid, mastered, lockedIn }

class Skill {
  const Skill(
    this.name,
    this.state, {
    this.trending = false,
    this.contentId,
  });

  final String name;
  final BrickState state;
  final bool trending;

  /// Stable ID used to retrieve the related Teach Me content from JSON/API.
  /// It is optional so existing Skill constructors remain compatible.
  final String? contentId;
}

class WallData {
  const WallData({
    required this.stretch,
    required this.klass,
    required this.foundations,
  });

  final List<List<Skill>> stretch;
  final List<List<Skill>> klass;
  final List<List<Skill>> foundations;

  Iterable<Skill> get all sync* {
    for (final section in [stretch, klass, foundations]) {
      for (final row in section) {
        yield* row;
      }
    }
  }

  int count(BrickState state) => all.where((skill) => skill.state == state).length;
}

/// Sample Mathematics wall based on the Map reference recording.
/// Each skill that has lesson content carries the stable JSON topic ID.
WallData buildWall({bool afterFirstCheck = false}) {
  const unchecked = BrickState.unchecked;

  return WallData(
    stretch: const [
      [
        Skill(
          'Simultaneous equations',
          unchecked,
          contentId: 'simultaneous_equations',
        ),
      ],
    ],
    klass: const [
      [
        Skill('Harder equations', unchecked, contentId: 'harder_equations'),
        Skill('Word problems', unchecked, contentId: 'word_problems'),
        Skill(
          'Expanding brackets',
          unchecked,
          contentId: 'expanding_brackets',
        ),
      ],
      [
        Skill(
          'Two-step equations',
          unchecked,
          contentId: 'two_step_equations',
        ),
      ],
    ],
    foundations: [
      const [
        Skill('Substituting', unchecked, contentId: 'substitution'),
        Skill(
          'Multiply & divide integers',
          unchecked,
          contentId: 'multiplying_dividing_integers',
        ),
        Skill('Simplifying', unchecked, contentId: 'simplifying_expressions'),
      ],
      [
        Skill(
          'One-step equations',
          afterFirstCheck ? BrickState.notSure : BrickState.solid,
          contentId: 'one_step_equations',
        ),
        Skill(
          'Add & subtract integers',
          unchecked,
          contentId: 'addition_subtraction_integers',
        ),
        Skill('Negative numbers', unchecked, contentId: 'negative_numbers'),
      ],
      const [
        Skill(
          'Order of operations',
          unchecked,
          contentId: 'order_of_operations',
        ),
        Skill(
          'Letters for numbers',
          BrickState.solid,
          trending: true,
          contentId: 'letters_for_numbers',
        ),
        Skill('Whole numbers', unchecked, contentId: 'whole_numbers'),
      ],
    ],
  );
}
