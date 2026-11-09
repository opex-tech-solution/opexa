import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/skill.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bricks.dart';
import '../../widgets/cards.dart';
import '../../widgets/info_widgets.dart';
import '../routes/widget.dart';

class _SkillDetails {
  const _SkillDetails({
    required this.description,
    required this.evidence,
    required this.needs,
    required this.unlocks,
    required this.supports,
    required this.usuallyMet,
  });

  final String description;
  final String evidence;
  final List<String> needs;
  final List<String> unlocks;
  final String supports;
  final String usuallyMet;
}

const Map<String, _SkillDetails> _skillDetails = {
  'Letters for numbers': _SkillDetails(
    description: 'Using a letter to stand for a number',
    evidence: 'You solved x + 5 = 12, which needs this block.',
    needs: ['Whole numbers'],
    unlocks: ['Simplifying', 'Substituting', 'One-step equations'],
    supports: 'General Mathematics, Physics, Chemistry and Economics',
    usuallyMet: 'Usually met in JSS1 · Foundations',
  ),
  'Whole numbers': _SkillDetails(
    description: 'Adding, taking away, multiplying and dividing whole numbers',
    evidence: 'Nothing yet. We will check this as you go.',
    needs: [],
    unlocks: ['Negative numbers', 'Order of operations', 'Letters for numbers'],
    supports: 'General Mathematics, Financial Accounting and Commerce',
    usuallyMet: 'Usually met in Primary 4–5 · Foundations',
  ),
  'One-step equations': _SkillDetails(
    description: 'Solving an equation by undoing one operation',
    evidence: 'You solved simple equations on your own.',
    needs: ['Letters for numbers', 'Whole numbers'],
    unlocks: ['Two-step equations', 'Substitution'],
    supports: 'General Mathematics, Physics and Chemistry',
    usuallyMet: 'Usually met in JSS1 · Foundations',
  ),
  'Two-step equations': _SkillDetails(
    description: 'Solving equations that need two inverse operations',
    evidence:
        'Your recent answers show that the order of the two steps needs practice.',
    needs: ['One-step equations', 'Negative numbers'],
    unlocks: ['Harder equations', 'Word problems', 'Simultaneous equations'],
    supports: 'General Mathematics, Physics and Economics',
    usuallyMet: 'Usually met in JSS2 · Your class',
  ),
  'Simultaneous equations': _SkillDetails(
    description: 'Solving two equations together to find two unknown values',
    evidence:
        'This block is used when two facts share the same unknown values.',
    needs: ['Letters for numbers', 'One-step equations'],
    unlocks: ['Word problems', 'Harder equations'],
    supports: 'General Mathematics, Physics and Economics',
    usuallyMet: 'Usually met in SS1 · Stretch',
  ),
};

class SkillDetailPage extends StatelessWidget {
  const SkillDetailPage({super.key, required this.skill});

  final Skill skill;

  _SkillDetails get _details =>
      _skillDetails[skill.name] ??
      const _SkillDetails(
        description: 'A building block in your Mathematics learning map.',
        evidence:
            'We will use your lesson and practice answers to check this skill.',
        needs: [],
        unlocks: [],
        supports: 'General Mathematics',
        usuallyMet: 'Based on the Nigerian national curriculum',
      );

  String get _statusHeading {
    switch (skill.state) {
      case BrickState.unchecked:
        return 'Not checked yet';
      case BrickState.notSure:
        return 'Not sure yet';
      case BrickState.building:
        return 'Building';
      case BrickState.solid:
        return 'Solid · shown through a harder question';
      case BrickState.mastered:
        return 'Mastered';
      case BrickState.lockedIn:
        return 'Locked in';
    }
  }

  String get _statusDescription {
    switch (skill.state) {
      case BrickState.unchecked:
        return 'We have not seen enough yet. We will check this as you go.';
      case BrickState.notSure:
        return 'We have seen a little, but need a clearer answer before we can be sure.';
      case BrickState.building:
        return 'You are working on this skill in lessons. Keep practising.';
      case BrickState.solid:
        return 'You showed this through a harder question that needs it.';
      case BrickState.mastered:
        return 'You have used this skill successfully in varied questions.';
      case BrickState.lockedIn:
        return 'You have still got this skill after time has passed.';
    }
  }

  int get _progressIndex {
    switch (skill.state) {
      case BrickState.unchecked:
      case BrickState.notSure:
        return 0;
      case BrickState.building:
        return 2;
      case BrickState.solid:
        return 3;
      case BrickState.mastered:
        return 4;
      case BrickState.lockedIn:
        return 5;
    }
  }

  String get _nextStep {
    switch (skill.state) {
      case BrickState.unchecked:
      case BrickState.notSure:
        return 'Next: your plan checks this block as you go.';
      case BrickState.building:
        return 'Next: practise this skill in a lesson.';
      case BrickState.solid:
        return 'Next: varied questions and a new kind of problem, on another day, make it Mastered.';
      case BrickState.mastered:
        return 'Next: show that you can still use this skill later.';
      case BrickState.lockedIn:
        return 'This foundation is holding strong. Keep using it in harder topics.';
    }
  }

  String get _actionLabel {
    switch (skill.state) {
      case BrickState.unchecked:
      case BrickState.notSure:
      case BrickState.building:
        return 'Teach me this topic';
      case BrickState.solid:
        return 'Go over the teaching';
      case BrickState.mastered:
      case BrickState.lockedIn:
        return 'Practise this topic';
    }
  }

  void _openTeaching(BuildContext context) {
    context.push(
      '${AppRoutes.mainMap}/${AppRoutes.mainMapSkillDetails}/${AppRoutes.mainMapLearningLearningScreen}',
      extra: skill,
    );
  }

  Widget _progressTimeline(BuildContext context) {
    const labels = [
      'Checked',
      'Taught',
      'Practised',
      'Solid',
      'Mastered',
      'Locked in',
    ];
    final colors = context.colors;
    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < labels.length; i++) ...[
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i < _progressIndex
                            ? colors.brickSolid
                            : colors.surfaceInset,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: i <= _progressIndex
                              ? colors.accent
                              : colors.border,
                          width: i == _progressIndex ? 2 : 1,
                        ),
                      ),
                      child: i < _progressIndex
                          ? Icon(Icons.check, size: 15, color: colors.onAccent)
                          : i == _progressIndex
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colors.accent,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 8,
                        height: 1.1,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < labels.length - 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 19),
                  child: Container(
                    height: 2,
                    width: 5,
                    color: i < _progressIndex ? colors.accent : colors.divider,
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.track_changes, size: 20, color: colors.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _nextStep,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.auto_awesome, size: 19, color: colors.accent),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Next lesson starts: try it first.',
                style: TextStyle(fontSize: 13, height: 1.35),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _relatedSkills(BuildContext context, List<String> names) {
    if (names.isEmpty) {
      return Text(
        'This is a starting block.',
        style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final name in names)
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrickFace(
                  name == 'One-step equations' &&
                          skill.state == BrickState.solid
                      ? BrickState.solid
                      : BrickState.unchecked,
                  width: 84,
                  height: 40,
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _textPanel(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = _details;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          skill.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrickFace(skill.state, width: 64, height: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.name == 'Letters for numbers'
                          ? 'Letters standing for numbers'
                          : skill.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      details.description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(_statusHeading),
                const SizedBox(height: 8),
                Text(
                  _statusDescription,
                  style: const TextStyle(fontSize: 14, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Where this block is'),
                const SizedBox(height: 18),
                _progressTimeline(context),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openTeaching(context),
              icon: const Icon(Iconsax.book_1, weight: 2.0),
              label: Text(_actionLabel),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.accent,
                foregroundColor: context.colors.onAccent,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          _textPanel(
            context,
            'What shows this',
            InfoCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    skill.state == BrickState.unchecked
                        ? Icons.info_outline
                        : Icons.trending_up,
                    color: context.colors.textSecondary,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      details.evidence,
                      style: const TextStyle(fontSize: 13, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          _textPanel(context, 'Needs', _relatedSkills(context, details.needs)),
          const SizedBox(height: 22),
          _textPanel(
            context,
            'Unlocks',
            _relatedSkills(context, details.unlocks),
          ),
          const SizedBox(height: 22),
          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('In SS this supports'),
                const SizedBox(height: 10),
                Text(
                  details.supports,
                  style: const TextStyle(fontSize: 15, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            details.usuallyMet,
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
