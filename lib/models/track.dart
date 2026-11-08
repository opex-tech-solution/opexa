import 'package:flutter/material.dart';

enum TrackKind { foundation, klass, stretch }

/// One of the three learning tracks shown on the Today screen.
class Track {
  const Track({
    required this.kind,
    required this.name,
    required this.tagline,
    required this.explainer,
    required this.icon,
  });

  final TrackKind kind;
  final String name;

  /// One line shown on the tile.
  final String tagline;

  /// Longer text shown in the bottom sheet when the tile is tapped.
  final String explainer;
  final IconData icon;
}

const List<Track> kTracks = [
  Track(
    kind: TrackKind.foundation,
    name: 'Foundation',
    tagline: 'Fix the blocks that unlock the most',
    explainer:
        'The earlier blocks your class work stands on. OpexA picks the one that '
        'unlocks the most for you, so a few minutes here makes everything else '
        'easier.',
    icon: Icons.layers_outlined,
  ),
  Track(
    kind: TrackKind.klass,
    name: 'Class',
    tagline: 'Keep up with this week’s topic',
    explainer:
        'Short lessons for the topic your class is on this week, with any '
        'missing pieces filled in first.',
    icon: Icons.menu_book_outlined,
  ),
  Track(
    kind: TrackKind.stretch,
    name: 'Stretch',
    tagline: 'Challenge yourself and go further',
    explainer:
        'Harder problems on the blocks you’re already strong in, to take you '
        'further.',
    icon: Icons.bar_chart,
  ),
];
