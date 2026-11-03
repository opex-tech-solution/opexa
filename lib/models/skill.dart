enum BrickState { unchecked, notSure, building, solid, mastered, lockedIn }

class Skill {
  const Skill(this.name, this.state, {this.trending = false});
  final String name;
  final BrickState state;
  final bool trending;
}

class WallData {
  const WallData({required this.stretch, required this.klass, required this.foundations});
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

  int count(BrickState s) => all.where((e) => e.state == s).length;
}

/// Sample data matching the recording. Replace with real data from your backend.
WallData buildWall({bool afterFirstCheck = false}) {
  const u = BrickState.unchecked;
  return WallData(
    stretch: const [
      [Skill('Simultaneous equations', u)],
    ],
    klass: [
      const [
        Skill('Harder equations', u),
        Skill('Word problems', u),
        Skill('Expanding brackets', u),
      ],
      [
        Skill('Two-step equations',
            afterFirstCheck ? BrickState.solid : BrickState.building),
      ],
    ],
    foundations: const [
      [
        Skill('Substituting', u),
        Skill('Multiply & divide integers', u),
        Skill('Simplifying', u),
      ],
      [
        Skill('One-step equations', BrickState.solid),
        Skill('Add & subtract integers', BrickState.solid),
        Skill('Negative numbers', u),
      ],
      [
        Skill('Order of operations', u),
        Skill('Letters for numbers', BrickState.solid, trending: true),
        Skill('Whole numbers', u),
      ],
    ],
  );
}
