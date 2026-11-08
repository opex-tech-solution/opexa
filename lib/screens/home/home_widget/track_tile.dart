import 'package:flutter/material.dart';

import '../../../models/model.dart';
import '../../../theme/widget.dart';

/// The coloured rounded square with a track's icon.
class TrackBadge extends StatelessWidget {
  const TrackBadge({super.key, required this.track, this.size = 48});

  final Track track;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, glyph) = switch (track.kind) {
      TrackKind.foundation => (c.trackFoundation, c.onTrackFoundation),
      TrackKind.klass => (c.trackClass, c.onTrackClass),
      TrackKind.stretch => (c.trackStretch, c.onTrackStretch),
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(track.icon, color: glyph, size: size * 0.5),
    );
  }
}

/// One row of "Your three tracks".
class TrackTile extends StatelessWidget {
  const TrackTile({super.key, required this.track, required this.onTap});

  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(16);
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: c.divider),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              TrackBadge(track: track),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      track.tagline,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: c.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
