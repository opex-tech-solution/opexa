
import '../../../models/model.dart';

/// One named Today state, for previews and tests.
class TodaySample {
  const TodaySample(this.label, this.state);
  final String label;
  final TodayState state;
}

/// The nine Today states from the design board, as data.
///
/// Numbers in the labels match the board (2 is the Foundation sheet and 5 is
/// the Notifications page, which are not separate Today states).
class TodaySamples {
  TodaySamples._();

  static const _bello = AppNotification(
    title: 'Mrs Bello has seen your map',
    body: 'They can use it to help you in class.',
    whenLabel: 'Today',
    isNew: true,
  );

  static const _belloRead = AppNotification(
    title: 'Mrs Bello has seen your map',
    body: 'They can use it to help you in class.',
    whenLabel: 'Today',
  );

  static const _classPrompt = ClassTopicPrompt(
    subject: 'Maths',
    topics: [
      'Simple equations',
      'Linear equations',
      'Equations with x on both sides',
      'Word problems into equations',
      'Not sure',
    ],
  );

  static const _topicReason = NextUpReason(
    ReasonIcon.topic,
    'Fixing this helps with this week’s topic: linear equations.',
  );

  static const _tryFirstReason = NextUpReason(
    ReasonIcon.startsWith,
    'Starts: try it first',
  );

  // 1 ── before the first check
  static final startingPoint = TodayState(
    userName: 'Amaka',
    now: DateTime(2026, 10, 23, 15),
    stage: FirstCheckStage.notStarted,
  );

  // 3 ── first check half done
  static final resume = TodayState(
    userName: 'Amaka',
    now: DateTime(2026, 10, 23, 15),
    stage: FirstCheckStage.inProgress,
  );

  // 4 ── first plan after the check
  static final firstPlan = TodayState(
    userName: 'Amaka',
    now: DateTime(2026, 10, 24, 9),
    map: const MapCounts(solid: 4, building: 1, notChecked: 9),
    nextUp: const NextUp(
      kind: LessonKind.foundation,
      title: 'Add & subtract integers',
      topicId: 'addition_subtraction_integers',
      description:
          'Fixing this makes multiply & divide integers, simplifying and '
          'one-step equations easier.',
      brick: BrickState.building,
      minutes: 10,
      reasons: [_topicReason, _tryFirstReason],
      primaryLabel: 'Start',
      secondaryLabel: 'Not today',
    ),
    learningList: const LearningListSummary(
      topicCount: 6,
      nextTopic: 'Add & subtract integers',
    ),
    plan: const [
      PlanItem(
        kind: LessonKind.klass,
        title: 'Two-step equations',
      topicId: 'two_step_equations',
        brick: BrickState.solid,
        status: LessonStatus.todo,
        caption: 'About 8 min',
      ),
      PlanItem(
        kind: LessonKind.stretch,
        title: 'Word problems',
        topicId: 'word_problems',
        brick: BrickState.unchecked,
        status: LessonStatus.todo,
        caption: 'About 10 min',
      ),
    ],
    notifications: const [_bello],
  );

  // 6 ── took the day off / all lessons done
  static final doneForToday = TodayState(
    userName: 'Amaka',
    now: DateTime(2026, 10, 23, 15),
    map: const MapCounts(solid: 4, building: 1, notChecked: 9),
    learningList: const LearningListSummary(
      topicCount: 6,
      nextTopic: 'Add & subtract integers',
    ),
    doneForToday: true,
    plan: const [
      PlanItem(
        kind: LessonKind.foundation,
        title: 'Add & subtract integers',
        topicId: 'addition_subtraction_integers',
        brick: BrickState.building,
        status: LessonStatus.done,
        caption: 'Solid today',
      ),
      PlanItem(
        kind: LessonKind.klass,
        title: 'Two-step equations',
        topicId: 'two_step_equations',
        brick: BrickState.solid,
        status: LessonStatus.done,
        caption: 'Solid today',
      ),
      PlanItem(
        kind: LessonKind.stretch,
        title: 'Word problems',
        topicId: 'word_problems',
        brick: BrickState.unchecked,
        status: LessonStatus.done,
        caption: 'Solid today',
      ),
    ],
    week: const WeekProgress(
      learnedDays: [false, false, false, false, false, false, true],
      lessons: 3,
    ),
    notifications: const [_bello],
  );

  static const _quickCheck = NextUp(
    kind: LessonKind.quickCheck,
    title: 'One-step equations',
    topicId: 'one_step_equations',
    description:
        'Two quick questions from 7 days ago. If it’s still there, this block '
        'locks in.',
    brick: BrickState.mastered,
    minutes: 2,
    badge: 'Due today',
    primaryLabel: 'Start quick check',
    tone: NextUpTone.warm,
  );

  static const _quickCheckPlan = [
    PlanItem(
      kind: LessonKind.foundation,
      title: 'Harder equations',
      topicId: 'harder_equations',
      brick: BrickState.unchecked,
      status: LessonStatus.todo,
      caption: 'About 10 min',
    ),
    PlanItem(
      kind: LessonKind.klass,
      title: 'Class',
      brick: BrickState.unchecked,
      status: LessonStatus.needsTopic,
      caption: 'Pick this week’s topic below.',
    ),
    PlanItem(
      kind: LessonKind.stretch,
      title: 'Simultaneous equations',
      topicId: 'simultaneous_equations',
      brick: BrickState.unchecked,
      status: LessonStatus.todo,
      caption: 'About 10 min',
    ),
  ];

  // 7 ── a quick check is due
  static final quickCheckDue = TodayState(
    userName: 'Tobi',
    now: DateTime(2026, 10, 31, 15),
    map: const MapCounts(mastered: 1, solid: 3, notChecked: 10),
    classPrompt: _classPrompt,
    nextUp: _quickCheck,
    plan: _quickCheckPlan,
    notifications: const [_bello],
  );

  // 8 ── the same, offline
  static final quickCheckOffline = TodayState(
    userName: 'Tobi',
    now: DateTime(2026, 10, 31, 15),
    offline: true,
    map: const MapCounts(mastered: 1, solid: 3, notChecked: 10),
    classPrompt: _classPrompt,
    nextUp: _quickCheck,
    plan: _quickCheckPlan,
    notifications: const [_bello],
  );

  // 9 ── the same, with something to download first
  static final quickCheckDownload = TodayState(
    userName: 'Tobi',
    now: DateTime(2026, 10, 31, 15),
    map: const MapCounts(mastered: 1, solid: 3, notChecked: 10),
    classPrompt: _classPrompt,
    nextUp: const NextUp(
      kind: LessonKind.quickCheck,
      title: 'One-step equations',
      topicId: 'one_step_equations',
      description:
          'Two quick questions from 7 days ago. If it’s still there, this '
          'block locks in.',
      brick: BrickState.mastered,
      minutes: 2,
      downloadSize: 'about 5 KB',
      badge: 'Due today',
      primaryLabel: 'Start quick check',
      tone: NextUpTone.warm,
    ),
    plan: _quickCheckPlan,
    notifications: const [_bello],
  );

  // 10 ── answers pointed different ways
  static final oneMoreLook = TodayState(
    userName: 'Zainab',
    now: DateTime(2026, 10, 23, 15),
    map: const MapCounts(solid: 1, notSure: 1, notChecked: 12),
    classPrompt: _classPrompt,
    nextUp: const NextUp(
      kind: LessonKind.foundation,
      title: 'One more look',
      topicId: 'letters_for_numbers',
      description:
          'Your answers on letters for numbers pointed different ways. Three '
          'quick questions help us be fair to you.',
      brick: BrickState.notSure,
      minutes: 3,
      primaryLabel: 'Start',
      secondaryLabel: 'Not today',
    ),
    learningList: const LearningListSummary(
      topicCount: 5,
      nextTopic: 'Letters for numbers',
    ),
    plan: const [
      PlanItem(
        kind: LessonKind.klass,
        title: 'Class',
        brick: BrickState.unchecked,
        status: LessonStatus.needsTopic,
        caption: 'Pick this week’s topic below.',
      ),
      PlanItem(
        kind: LessonKind.stretch,
        title: 'Expanding brackets',
        topicId: 'expanding_brackets',
        brick: BrickState.unchecked,
        status: LessonStatus.locked,
        caption:
            'Stretch opens once simplifying and multiply & divide integers '
            'are solid.',
      ),
    ],
    notifications: const [_belloRead],
  );

  // 11 ── a quick look at an earlier block
  static final quickLook = TodayState(
    userName: 'Amaka',
    now: DateTime(2026, 10, 27, 9),
    map: const MapCounts(mastered: 1, solid: 4, notChecked: 9),
    nextUp: const NextUp(
      kind: LessonKind.foundation,
      title: 'Quick look: Whole numbers',
      topicId: 'whole_numbers',
      description:
          'Your block to build is fixed. Three quick questions show if this '
          'earlier block is in place too.',
      brick: BrickState.unchecked,
      minutes: 3,
      reasons: [_topicReason],
      primaryLabel: 'Start',
      secondaryLabel: 'Not today',
    ),
    learningList: const LearningListSummary(
      topicCount: 5,
      nextTopic: 'Multiply & divide integers',
    ),
    plan: const [
      PlanItem(
        kind: LessonKind.klass,
        title: 'Two-step equations',
        brick: BrickState.solid,
        status: LessonStatus.todo,
        caption: 'About 8 min',
      ),
      PlanItem(
        kind: LessonKind.stretch,
        title: 'Word problems',
        brick: BrickState.unchecked,
        status: LessonStatus.todo,
        caption: 'About 10 min',
      ),
    ],
    week: const WeekProgress(
      blocksMovedUp: [MovedBlock('Add & subtract integers', BrickState.mastered)],
    ),
    notifications: const [_bello],
  );

  static final List<TodaySample> all = [
    TodaySample('1 · Starting point', startingPoint),
    TodaySample('3 · Pick up where you left off', resume),
    TodaySample('4 · First plan', firstPlan),
    TodaySample('6 · Done for today', doneForToday),
    TodaySample('7 · Quick check due', quickCheckDue),
    TodaySample('8 · Quick check, offline', quickCheckOffline),
    TodaySample('9 · Quick check, needs download', quickCheckDownload),
    TodaySample('10 · One more look', oneMoreLook),
    TodaySample('11 · Quick look', quickLook),
  ];
}
