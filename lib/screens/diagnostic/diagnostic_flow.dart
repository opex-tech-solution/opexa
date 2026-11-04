import 'package:flutter/material.dart';
import '../../models/answer_result.dart';
import '../../models/skill.dart';
import 'interstitial_screen.dart';
import 'mcq_screen.dart';
import 'numeric_screen.dart';
import 'quick_fix_screen.dart';
import 'results_screen.dart';
import 'working_text_screen.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bricks.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/info_widgets.dart';

/// Called when the student taps "See my full map" / "See what to learn".
/// Wire this in your router (see AppRouter in app_routes.dart).
typedef OpenMapCallback =
    void Function(BuildContext context, bool openLearningList);

class DiagnosticFlow extends StatefulWidget {
  const DiagnosticFlow({super.key, this.userName, required this.onOpenMap});
  final String? userName;
  final OpenMapCallback onOpenMap;

  @override
  State<DiagnosticFlow> createState() => _DiagnosticFlowState();
}

class _DiagnosticFlowState extends State<DiagnosticFlow> {
  // Step indices
  static const sQ1 = 0, sQ2 = 1, sQ3 = 2;
  static const sWorkChoice = 3, sWorkText = 4, sNotSure = 5;
  static const sNeg1 = 6, sNeg2 = 7, sQ4 = 8, sQ5 = 9;
  static const sFound = 10, sFix = 11, sTurn = 12;
  static const sFreshIntro = 13, sFresh1 = 14, sFresh2 = 15;
  static const sNeedsTime = 16, sMapReady = 17, sMapOverview = 18;

  int _step = sQ1;
  final List<String> _seen = [];

  void _next() => setState(() => _step++);
  void _jump(int s) => setState(() => _step = s);

  void _record(String prompt, List<String> options, AnswerResult r) {
    final String what;
    if (r.choice == null) {
      what = 'you said you didn’t know';
    } else {
      final guess = r.confidence == 0 ? ' (guessing)' : '';
      what = 'you answered ${options[r.choice!]}$guess';
    }
    _seen.add('On $prompt $what.');
  }

  Future<void> _confirmClose() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: C.surface,
        title: const Text('Leave this check?'),
        content: const Text('Your answers so far won’t be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      setState(() {
        _step = sQ1;
        _seen.clear();
      });
    }
  }

  void _openMap({bool learnList = false}) =>
      widget.onOpenMap(context, learnList);

  // Header ---------------------------------------------------------------

  Widget? _header() {
    if (_step == sMapOverview) return null;
    if (_step == sMapReady) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Done', style: TextStyle(fontSize: 11, color: C.muted)),
            SizedBox(height: 4),
            _ProgressBar(1),
          ],
        ),
      );
    }
    final progress = (_step / sMapReady).clamp(0.0, 1.0);
    final mins = _step == sQ1 ? 5 : (_step == sQ2 ? 4 : 3);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: _confirmClose,
            icon: const Icon(Icons.close, size: 22),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProgressBar(progress),
                const SizedBox(height: 4),
                Text(
                  'About $mins min left',
                  style: const TextStyle(fontSize: 11, color: C.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Steps ----------------------------------------------------------------

  Widget _body() {
    switch (_step) {
      case sQ1:
        return _mcq('Solve x + 5 = 12', [
          'x = 7',
          'x = 17',
          'x = −7',
          'x = 5',
        ], record: false);
      case sQ2:
        return _mcq('Solve 3x − 4 = 11', [
          'x = 5',
          'x = 7/3',
          'x = 15',
          'x = 7',
        ], record: false);
      case sQ3:
        return _mcq('Solve 2x + 9 = 3', ['x = −3', 'x = 3', 'x = −6', 'x = 6']);
      case sWorkChoice:
        return McqScreen(
          key: const ValueKey('work'),
          label: 'Show your working',
          subtitle: 'There’s no wrong answer here. It shows us how you think.',
          showBanner: false,
          askConfidence: false,
          dontKnowLabel: 'I’m not sure',
          prompt: 'For 2x + 9 = 3, what did you do first?',
          options: const [
            'Took 9 away from both sides',
            'Added 9 to both sides',
            'Divided both sides by 2 first',
          ],
          onDone: (r) => r.choice == null ? _jump(sNotSure) : _next(),
        );
      case sWorkText:
        return WorkingTextScreen(
          key: const ValueKey('workText'),
          title: 'How did you get x = 3?',
          onSend: (_) => _next(), // send `text` to your backend here
          onSkip: _next,
        );
      case sNotSure:
        return InterstitialScreen(
          key: const ValueKey('notSure'),
          icon: Icons.search,
          title: 'We’re not sure yet',
          body:
              'That one looked tricky, and there are a few possible reasons. '
              'Let’s check one more thing.',
          button: 'Next',
          onPressed: _next,
        );
      case sNeg1:
        return NumericScreen(
          key: const ValueKey('neg1'),
          prompt: '−3 − 5 = ?',
          onDone: (_) => _next(),
        );
      case sNeg2:
        return NumericScreen(
          key: const ValueKey('neg2'),
          prompt: '4 − 10 = ?',
          onDone: (_) => _next(),
        );
      case sQ4:
        return _mcq('Solve 2x + 1 = 9', ['x = 4', 'x = 8', 'x = 5', 'x = 10']);
      case sQ5:
        return _mcq('Solve 4x − 2 = 10', ['x = 3', 'x = 12', 'x = 2', 'x = 8']);
      case sFound:
        return ResultsScreen(
          key: const ValueKey('found'),
          seen: _seen,
          onFix: _next,
        );
      case sFix:
        return QuickFixScreen(key: const ValueKey('fix'), onTryOne: _next);
      case sTurn:
        return NumericScreen(
          key: const ValueKey('turn'),
          mode: NumericMode.practice,
          label: 'Quick fix · Your turn',
          prompt: '2x + 3 = 11',
          correctAnswer: 4,
          hint: 'Take 3 from both sides first, then divide by 2.',
          onDone: (_) => _next(),
        );
      case sFreshIntro:
        return InterstitialScreen(
          key: const ValueKey('fresh'),
          icon: Icons.replay,
          title: 'Two fresh questions',
          body: 'Now try two new questions on the same block, on your own.',
          button: 'Let’s go',
          onPressed: _next,
        );
      case sFresh1:
        return NumericScreen(
          key: const ValueKey('fresh1'),
          label: 'Fresh question',
          prompt: 'Solve 3x + 4 = 19',
          onDone: (_) => _next(),
        );
      case sFresh2:
        return NumericScreen(
          key: const ValueKey('fresh2'),
          label: 'Fresh question',
          showBanner: false,
          prompt: 'Solve 2x − 5 = 9',
          onDone: (_) => _next(),
        );
      case sNeedsTime:
        return InterstitialScreen(
          key: const ValueKey('needsTime'),
          icon: Icons.grid_view_rounded,
          title: 'This block needs a bit more time',
          body:
              'That’s normal. It goes first in your plan, and we’ll come back to it '
              'with more practice.',
          button: 'Next',
          onPressed: _next,
        );
      case sMapReady:
        return _MapReady(
          key: const ValueKey('mapReady'),
          name: widget.userName,
          onSeeMap: _next,
        );
      default:
        return _MapOverview(
          key: const ValueKey('mapOverview'),
          name: widget.userName,
          onFullMap: () => _openMap(),
          onLearn: () => _openMap(learnList: true),
        );
    }
  }

  Widget _mcq(String prompt, List<String> options, {bool record = true}) {
    return McqScreen(
      key: ValueKey('mcq$_step'),
      prompt: prompt,
      options: options,
      onDone: (r) {
        if (record) _record(prompt.replaceFirst('Solve ', ''), options, r);
        _next();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_header() != null) _header()!,
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: KeyedSubtree(key: ValueKey(_step), child: _body()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar(this.value);
  final double value;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: LinearProgressIndicator(
      value: value,
      minHeight: 4,
      backgroundColor: C.surface,
      valueColor: const AlwaysStoppedAnimation(C.primary),
    ),
  );
}

class _MapReady extends StatelessWidget {
  const _MapReady({super.key, this.name, required this.onSeeMap});
  final String? name;
  final VoidCallback onSeeMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              children: [
                const BrickFace(BrickState.building, width: 56, height: 24),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BrickFace(BrickState.solid, width: 56, height: 30),
                    SizedBox(width: 6),
                    BrickFace(BrickState.solid, width: 56, height: 30),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Your map is ready',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  name == null
                      ? 'Thanks. Here’s what today showed.'
                      : 'Thanks, $name. Here’s what today showed.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13.5, color: C.muted),
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: double.infinity,
                    child: PanelCard(
                      title: 'What you can do',
                      items: kStrengths,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionLabel('Block to build first'),
                      SizedBox(height: 8),
                      Text(
                        'Doing the two steps in the right order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'It goes first in your plan, with more practice.',
                        style: TextStyle(fontSize: 12.5, color: C.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: PrimaryButton(label: 'See my map', onPressed: onSeeMap),
        ),
      ],
    );
  }
}

class _MapOverview extends StatelessWidget {
  const _MapOverview({
    super.key,
    this.name,
    required this.onFullMap,
    required this.onLearn,
  });
  final String? name;
  final VoidCallback onFullMap;
  final VoidCallback onLearn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name == null ? 'Here’s your map' : 'Here’s your map, $name',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                const PanelCard(
                  title: 'Here’s what you can already do',
                  items: kStrengths,
                ),
                const SizedBox(height: 16),
                SkillWall(data: buildWall(), highlight: 'Two-step equations'),
                const SizedBox(height: 16),
                const BuildNextCard(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Column(
            children: [
              PrimaryButton(label: 'See my full map', onPressed: onFullMap),
              const SizedBox(height: 10),
              LinkButton(label: 'See what to learn', onPressed: onLearn),
            ],
          ),
        ),
      ],
    );
  }
}
