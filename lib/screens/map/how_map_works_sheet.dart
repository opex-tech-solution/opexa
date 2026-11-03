import 'package:flutter/material.dart';
import '../../models/skill.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bricks.dart';
import '../../widgets/buttons.dart';
import '../../widgets/info_widgets.dart';

class HowMapWorksSheet extends StatefulWidget {
  const HowMapWorksSheet({super.key});
  @override
  State<HowMapWorksSheet> createState() => _HowMapWorksSheetState();
}

class _HowMapWorksSheetState extends State<HowMapWorksSheet> {
  final _pc = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == 2) {
      Navigator.pop(context);
    } else {
      _pc.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  Widget _legend(BrickState s, String label) => Expanded(
        child: Row(children: [
          BrickFace(s, width: 34, height: 22),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _page1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionLabel('How your map works · 1 of 3'),
        const SizedBox(height: 10),
        const Text('Every block is a brick',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 18),
        Row(children: [
          _legend(BrickState.unchecked, 'Not checked yet'),
          _legend(BrickState.notSure, 'Not sure yet'),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          _legend(BrickState.building, 'Building'),
          _legend(BrickState.solid, 'Solid'),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          _legend(BrickState.mastered, 'Mastered'),
          _legend(BrickState.lockedIn, 'Locked in'),
        ]),
        const SizedBox(height: 18),
        const Text('Each brick is one Maths skill. Its look tells you how sure we are that you can do it.',
            style: TextStyle(fontSize: 13, color: C.muted, height: 1.4)),
      ]);

  Widget _page2() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionLabel('How your map works · 2 of 3'),
        const SizedBox(height: 10),
        const Text('Your wall has three levels',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        const Center(child: SectionLabel('Stretch')),
        const SizedBox(height: 6),
        const Center(child: BrickFace(BrickState.unchecked, width: 46, height: 28)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: C.classPanel, borderRadius: BorderRadius.circular(12)),
          child: const Column(children: [
            SectionLabel('Your class'),
            SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              BrickFace(BrickState.building, width: 46, height: 28),
              SizedBox(width: 6),
              BrickFace(BrickState.unchecked, width: 46, height: 28),
            ]),
          ]),
        ),
        const SizedBox(height: 8),
        const Center(child: SectionLabel('Foundations')),
        const SizedBox(height: 6),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          BrickFace(BrickState.solid, width: 46, height: 28),
          SizedBox(width: 6),
          BrickFace(BrickState.solid, width: 46, height: 28),
          SizedBox(width: 6),
          BrickFace(BrickState.mastered, width: 46, height: 28),
        ]),
        const SizedBox(height: 14),
        const Text('Foundations from earlier years sit at the bottom. Strong foundations hold up your class topics, and Stretch sits on top.',
            style: TextStyle(fontSize: 12.5, color: C.muted, height: 1.4)),
      ]);

  Widget _row(BrickState s, String title, String desc) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BrickFace(s, width: 42, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
              Text(desc, style: const TextStyle(fontSize: 12, color: C.muted, height: 1.3)),
            ]),
          ),
        ]),
      );

  Widget _page3() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionLabel('How your map works · 3 of 3'),
        const SizedBox(height: 10),
        const Text('How a brick moves up',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        _row(BrickState.building, 'Building', 'You’re working on it in lessons.'),
        _row(BrickState.solid, 'Solid', '3 of 4 new questions right on your own.'),
        _row(BrickState.mastered, 'Mastered',
            'On another day, with varied questions and a new kind of problem.'),
        _row(BrickState.lockedIn, 'Locked in', 'Still there a week later.'),
        const SizedBox(height: 4),
        const Text('Lessons move bricks up. Nothing ever moves down because of one bad day.',
            style: TextStyle(fontSize: 12.5, color: C.muted, height: 1.4)),
      ]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(color: C.outline, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 350,
            child: PageView(
              controller: _pc,
              onPageChanged: (i) => setState(() => _page = i),
              children: [_page1(), _page2(), _page3()],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < 3; i++)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _page ? C.primary : C.outlineSoft,
                ),
              ),
          ]),
          const SizedBox(height: 14),
          PrimaryButton(label: _page == 2 ? 'Got it' : 'Next', onPressed: _next),
          if (_page < 2)
            LinkButton(label: 'Skip', onPressed: () => Navigator.pop(context))
          else
            const SizedBox(height: 48),
        ]),
      ),
    );
  }
}
