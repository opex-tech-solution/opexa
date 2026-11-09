import 'package:flutter/material.dart';

import '../../models/skill.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bricks.dart';
import '../../widgets/cards.dart';
import '../../widgets/info_widgets.dart';
import 'widget.dart';

/// Main content for the Map bottom-navigation tab.
///
/// This screen intentionally does not create its own Scaffold or bottom
/// navigation bar. It is rendered inside the existing MainShell so the OpexA
/// Home / Map / Readiness / Me navigation remains visible while a student
/// opens a skill or a lesson.
class MapTab extends StatefulWidget {
  const MapTab({super.key, required this.onOpenLearningList});

  final VoidCallback onOpenLearningList;

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  bool _afterFirstCheck = false;

  void _openSkill(Skill skill) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SkillDetailPage(skill: skill),
      ),
    );
  }

  void _showHowMapWorks() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const HowMapWorksSheet(),
    );
  }

  Widget _subjectSelector() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(child: _SubjectTab(label: 'Maths', selected: true)),
          Expanded(
            child: _SubjectTab(label: 'English', selected: false, soon: true),
          ),
          Expanded(
            child: _SubjectTab(label: 'Physics', selected: false, soon: true),
          ),
        ],
      ),
    );
  }

  Widget _timeSelector() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TimeTab(
              label: 'Now',
              selected: !_afterFirstCheck,
              onTap: () => setState(() => _afterFirstCheck = false),
            ),
          ),
          Expanded(
            child: _TimeTab(
              label: 'After my first check',
              selected: _afterFirstCheck,
              onTap: () => setState(() => _afterFirstCheck = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard() {
    final colors = context.colors;
    if (_afterFirstCheck) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.divider),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your wall right after your first check',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              '7 November. Switch to Now to see what you have built since.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.textPrimary.withOpacity(0.85)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel('All in place'),
          SizedBox(height: 10),
          Text(
            'Nothing to repair right now. Keep going with your class topic and quick checks.',
            style: TextStyle(fontSize: 14, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _skillSection({
    required String title,
    required String subtitle,
    required List<List<Skill>> rows,
    bool staggerSecondRow = false,
    bool shaded = false,
  }) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionLabel(title),
            const Spacer(),
            Flexible(
              child: Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
          Padding(
            padding: EdgeInsets.only(
              left: title == 'Your class' && rows[rowIndex].length == 1
                  ? 72
                  : (staggerSecondRow && rowIndex == 1 ? 36 : 0),
              bottom: 11,
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 10,
              children: [
                for (final skill in rows[rowIndex])
                  _MapSkillTile(
                    skill: skill,
                    onTap: () => _openSkill(skill),
                  ),
              ],
            ),
          ),
      ],
    );

    if (!shaded) return content;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: context.colors.band,
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    );
  }

  Widget _firstCheckHistory() {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Since your first check: 1 block moved up',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BrickFace(BrickState.notSure, width: 34, height: 28),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: context.colors.textSecondary),
              const SizedBox(width: 8),
              const BrickFace(BrickState.solid, width: 34, height: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'One-step equations is now Solid',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendCard() {
    return InfoCard(
      child: Column(
        children: [
          Row(
            children: [
              _LegendItem(state: BrickState.unchecked, label: 'Not checked yet'),
              const SizedBox(width: 10),
              _LegendItem(state: BrickState.building, label: 'Building'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _LegendItem(state: BrickState.solid, label: 'Solid'),
              const SizedBox(width: 10),
              _LegendItem(state: BrickState.mastered, label: 'Mastered'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _LegendItem(state: BrickState.lockedIn, label: 'Locked in'),
              const SizedBox(width: 10),
              _LegendItem(state: BrickState.notSure, label: 'Not sure yet'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.border),
                ),
                child: Icon(
                  Icons.trending_up,
                  size: 15,
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Shown through a harder question',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topicList() {
    const topics = [
      ('Expressions and brackets', 'Not checked yet'),
      ('Linear equations', '1 of 2 blocks solid'),
      ('Substitution', 'Not checked yet'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.divider),
      ),
      child: Column(
        children: [
          for (var index = 0; index < topics.length; index++) ...[
            InkWell(
              borderRadius: BorderRadius.vertical(
                top: index == 0 ? const Radius.circular(16) : Radius.zero,
                bottom: index == topics.length - 1
                    ? const Radius.circular(16)
                    : Radius.zero,
              ),
              onTap: widget.onOpenLearningList,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const BrickFace(
                      BrickState.unchecked,
                      width: 28,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topics[index].$1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            topics[index].$2,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (index != topics.length - 1)
              Divider(height: 1, color: context.colors.divider),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wall = buildWall(afterFirstCheck: _afterFirstCheck);
    final solid = wall.count(BrickState.solid);
    final notSure = wall.count(BrickState.notSure);
    final unchecked = wall.count(BrickState.unchecked);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
      children: [
        const Text(
          'Map',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        _subjectSelector(),
        const SizedBox(height: 12),
        _timeSelector(),
        const SizedBox(height: 18),
        Text(
          [
            '$solid solid',
            if (notSure > 0) '$notSure not sure yet',
            '$unchecked not checked yet',
          ].join(' · '),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _showHowMapWorks,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: context.colors.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  'How your map works',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.colors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _statusCard(),
        const SizedBox(height: 20),
        _skillSection(
          title: 'Stretch',
          subtitle: 'Blocks above your class',
          rows: wall.stretch,
        ),
        const SizedBox(height: 8),
        _skillSection(
          title: 'Your class',
          subtitle: 'JSS2 blocks',
          rows: wall.klass,
          shaded: true,
        ),
        const SizedBox(height: 18),
        _skillSection(
          title: 'Foundations',
          subtitle: 'Blocks from earlier years',
          rows: wall.foundations,
          staggerSecondRow: true,
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: context.colors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your foundations start here',
          style: TextStyle(
            fontSize: 12,
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        if (!_afterFirstCheck) ...[
          _firstCheckHistory(),
          const SizedBox(height: 14),
        ],
        _legendCard(),
        const SizedBox(height: 22),
        const Text(
          'Your JSS2 topics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        _topicList(),
        const SizedBox(height: 12),
        Text(
          'Based on the Nigerian national curriculum.',
          style: TextStyle(
            fontSize: 11.5,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SubjectTab extends StatelessWidget {
  const _SubjectTab({
    required this.label,
    required this.selected,
    this.soon = false,
  });

  final String label;
  final bool selected;
  final bool soon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? context.colors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        soon ? '$label Soon' : label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: soon ? context.colors.textSecondary : context.colors.textPrimary,
        ),
      ),
    );
  }
}

class _TimeTab extends StatelessWidget {
  const _TimeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? context.colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _MapSkillTile extends StatelessWidget {
  const _MapSkillTile({required this.skill, required this.onTap});

  final Skill skill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  BrickFace(skill.state, width: 70, height: 40),
                  if (skill.trending)
                    Positioned(
                      right: -4,
                      top: -7,
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.colors.border),
                        ),
                        child: Icon(
                          Icons.trending_up,
                          size: 12,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                skill.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.state, required this.label});

  final BrickState state;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          BrickFace(state, width: 24, height: 20),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
