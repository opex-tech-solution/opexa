import 'package:flutter/material.dart';

import '../../../models/model.dart';
import '../../../theme/widget.dart';
import '../../../widgets/widget.dart';
import 'home_widget.dart';

/// The bottom sheet that explains a track when its tile is tapped.
Future<void> showTrackInfoSheet(BuildContext context, Track track) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => SafeArea(
      child: DefaultTextStyle.merge(
        style: TextStyle(color: sheetContext.colors.textPrimary),
        child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrackBadge(track: track, size: 44),
            const SizedBox(height: 16),
            Text(
              track.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              track.explainer,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            Text(
              'This opens up after your first check.',
              style: TextStyle(
                fontSize: 14,
                color: sheetContext.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'OK',
              onPressed: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
      ),
    ),
  );
}
