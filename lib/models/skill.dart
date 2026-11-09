enum BrickState { unchecked, notSure, building, solid, mastered, lockedIn }

class Skill {
  const Skill(this.name, this.state, {this.trending = false});

  final String name;
  final BrickState state;
  final bool trending;
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

  int count(BrickState state) =>
      all.where((skill) => skill.state == state).length;
}

/// Sample Mathematics wall based on the Map reference recording.
/// Replace this local sample with the student's wall returned by your API.
///
/// In the "Now" view, two blocks are solid. The historical view shows the
/// state immediately after the student's first check: one solid and one
/// uncertain block.
WallData buildWall({bool afterFirstCheck = false}) {
  const unchecked = BrickState.unchecked;

  return WallData(
    stretch: const [
      [Skill('Simultaneous equations', unchecked)],
    ],
    klass: const [
      [
        Skill('Harder equations', unchecked),
        Skill('Word problems', unchecked),
        Skill('Expanding brackets', unchecked),
      ],
      [Skill('Two-step equations', unchecked)],
    ],
    foundations: [
      const [
        Skill('Substituting', unchecked),
        Skill('Multiply & divide integers', unchecked),
        Skill('Simplifying', unchecked),
      ],
      [
        Skill(
          'One-step equations',
          afterFirstCheck ? BrickState.notSure : BrickState.solid,
        ),
        Skill('Add & subtract integers', unchecked),
        Skill('Negative numbers', unchecked),
      ],
      const [
        Skill('Order of operations', unchecked),
        Skill('Letters for numbers', BrickState.solid, trending: true),
        Skill('Whole numbers', unchecked),
      ],
    ],
  );
}
