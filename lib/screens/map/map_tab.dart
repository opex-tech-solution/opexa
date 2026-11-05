import 'package:flutter/material.dart';
import 'package:opexa/screens/map/widget.dart';
import 'package:opexa/widgets/widget.dart' show SectionLabel, BuildNextCard, SkillWall, InfoCard;
import '../../models/model.dart';
import '../../theme/widget.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key, required this.onOpenLearningList});
  final VoidCallback onOpenLearningList;

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  bool _after = false;

  void _why() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionLabel('Why this block?'),
            SizedBox(height: 10),
            Text('Two-step equations sit underneath harder equations and word problems. '
                'Fixing this block makes both of those easier.',
                style: TextStyle(fontSize: 15, height: 1.4)),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wall = buildWall(afterFirstCheck: _after);
    final solid = wall.count(BrickState.solid);
    final building = wall.count(BrickState.building);
    final unchecked = wall.count(BrickState.unchecked);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const Text('Map', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _Segmented(
          labels: const ['Maths', 'English', 'Physics'],
          soon: const {1, 2},
          selected: 0,
          onChanged: (_) {},
        ),
        const SizedBox(height: 10),
        _Segmented(
          labels: const ['Now', 'After my first check'],
          selected: _after ? 1 : 0,
          onChanged: (i) => setState(() => _after = i == 1),
        ),
        const SizedBox(height: 14),
        Text('$solid solid · $building building · $unchecked not checked yet',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: context.colors.surface,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            builder: (_) => const HowMapWorksSheet(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.info_outline, size: 14, color: context.colors.textSecondary),
              SizedBox(width: 6),
              Text('How your map works', style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: widget.onOpenLearningList,
          borderRadius: BorderRadius.circular(14),
          child: InfoCard(
            child: Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: context.colors.background, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.checklist, size: 20, color: context.colors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Your learning list',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  SizedBox(height: 2),
                  Text('3 topics to learn. Next: Two-step equations',
                      style: TextStyle(fontSize: 11.5, color: context.colors.textSecondary)),
                ]),
              ),
              Icon(Icons.chevron_right, color: context.colors.textSecondary),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        BuildNextCard(
          compact: false,
          onStart: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lesson screen: not part of the recording')),
          ),
          onWhy: _why,
        ),
        const SizedBox(height: 20),
        SkillWall(data: wall),
      ],
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.soon = const {},
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final Set<int> soon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.divider),
      ),
      child: Row(children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: soon.contains(i) ? null : () => onChanged(i),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selected ? context.colors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: i == selected ? Border.all(color: context.colors.divider) : null,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(labels[i],
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: soon.contains(i) ? context.colors.textSecondary : context.colors.textPrimary,
                      )),
                  if (soon.contains(i))
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text('Soon', style: TextStyle(fontSize: 9, color: context.colors.textSecondary)),
                    ),
                ]),
              ),
            ),
          ),
      ]),
    );
  }
}
