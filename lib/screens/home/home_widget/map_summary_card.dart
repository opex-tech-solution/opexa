import 'package:flutter/material.dart';
import '../../../models/model.dart';
import '../../../theme/widget.dart';
import 'home_format.dart';

/// "Your map · 4 solid · 1 building · 9 not checked yet" (tap opens the Map).
class MapSummaryCard extends StatelessWidget {
  const MapSummaryCard({super.key, required this.counts, required this.onTap});

  final MapCounts counts;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: c.divider),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Your map',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: ' · ${mapSummary(counts)}'),
                    ],
                  ),
                  style: const TextStyle(fontSize: 14, height: 1.35),
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
