import 'skill.dart' show BrickState;

/// Everything the Today screen needs to draw itself.
///
/// The screen holds no logic of its own: give it a [TodayState] and it draws
/// that state. Build one from the learner's progress (see TodayStore).

/// How far the learner is with the first check.
enum FirstCheckStage { notStarted, inProgress, done }

/// The kind of lesson shown on a card or row.
enum LessonKind { foundation, klass, stretch, quickCheck }

/// Colour of a "Next up" card border.
enum NextUpTone {
  /// Blue border: a normal lesson.
  accent,

  /// Warm border: something time-sensitive, like a quick check that is due.
  warm,
}

/// Small icon in front of a reason line on the "Next up" card.
enum ReasonIcon {
  /// A target: "Fixing this helps with this week's topic".
  topic,

  /// A sparkle: "Starts: try it first".
  startsWith,
}

/// State of one row in the day's plan.
enum LessonStatus {
  /// Can be opened.
  todo,

  /// Finished today.
  done,

  /// Not open yet (explained in the caption).
  locked,

  /// Waiting for the learner to pick this week's class topic.
  needsTopic,
}

/// How many blocks of each kind are on the learner's map.
class MapCounts {
  const MapCounts({
    this.mastered = 0,
    this.lockedIn = 0,
    this.solid = 0,
    this.building = 0,
    this.notSure = 0,
    this.notChecked = 0,
  });

  final int mastered;
  final int lockedIn;
  final int solid;
  final int building;
  final int notSure;
  final int notChecked;
}

class NextUpReason {
  const NextUpReason(this.icon, this.text);
  final ReasonIcon icon;
  final String text;
}

/// The big "Next up" card.
class NextUp {
  const NextUp({
    required this.kind,
    required this.title,
    required this.description,
    required this.brick,
    required this.minutes,
    required this.primaryLabel,
    this.reasons = const [],
    this.worksOffline = true,
    this.downloadSize,
    this.badge,
    this.secondaryLabel,
    this.tone = NextUpTone.accent,
    this.topicId,
  });

  final LessonKind kind;
  final String title;
  final String description;
  final BrickState brick;
  final int minutes;
  final List<NextUpReason> reasons;
  final bool worksOffline;

  /// e.g. "about 5 KB", shown when something has to be downloaded first.
  final String? downloadSize;

  /// Small pill at the top right, e.g. "Due today" or "In progress".
  final String? badge;
  final String primaryLabel;

  /// e.g. "Not today". Null hides the link.
  final String? secondaryLabel;
  final NextUpTone tone;
  /// Stable ID into assets/json/opexa_math_content.json.
  final String? topicId;
}

/// One row of "Also today" / "Today's plan".
class PlanItem {
  const PlanItem({
    required this.kind,
    required this.title,
    required this.brick,
    required this.status,
    required this.caption,
    this.topicId,
  });

  final LessonKind kind;
  final String title;
  final BrickState brick;
  final LessonStatus status;

  /// Second line: "About 8 min", "Solid today", "Pick this week's topic below."
  final String caption;
  /// Stable ID into assets/json/opexa_math_content.json.
  final String? topicId;
}

/// "What are you working on in Maths this week?"
class ClassTopicPrompt {
  const ClassTopicPrompt({
    required this.subject,
    required this.topics,
    this.selected,
  });

  final String subject;
  final List<String> topics;
  final String? selected;

  ClassTopicPrompt withSelected(String topic) =>
      ClassTopicPrompt(subject: subject, topics: topics, selected: topic);
}

class LearningListSummary {
  const LearningListSummary({
    required this.topicCount,
    required this.nextTopic,
  });
  final int topicCount;
  final String nextTopic;
}

class MovedBlock {
  const MovedBlock(this.name, this.brick);
  final String name;
  final BrickState brick;
}

/// The "This week" card.
class WeekProgress {
  const WeekProgress({
    this.learnedDays = const [false, false, false, false, false, false, false],
    this.lessons = 0,
    this.blocksMovedUp = const [],
  });

  /// Seven days, oldest first. The LAST one is today.
  final List<bool> learnedDays;
  final int lessons;
  final List<MovedBlock> blocksMovedUp;

  int get daysLearning => learnedDays.where((d) => d).length;
}

class AppNotification {
  const AppNotification({
    required this.title,
    required this.body,
    required this.whenLabel,
    this.isNew = false,
  });

  final String title;
  final String body;

  /// "Today", "Yesterday"...
  final String whenLabel;
  final bool isNew;

  AppNotification asRead() => AppNotification(
    title: title,
    body: body,
    whenLabel: whenLabel,
    isNew: false,
  );
}

class TodayState {
  const TodayState({
    required this.userName,
    this.now,
    this.offline = false,
    this.stage = FirstCheckStage.done,
    this.map,
    this.classPrompt,
    this.nextUp,
    this.learningList,
    this.doneForToday = false,
    this.plan = const [],
    this.week = const WeekProgress(),
    this.notifications = const [],
  });

  final String userName;

  /// Overrides the clock (samples and tests). Null = DateTime.now().
  final DateTime? now;

  /// Shows the "Offline. Everything you do is saved on this phone." banner.
  final bool offline;
  final FirstCheckStage stage;

  /// Null until the first check is done.
  final MapCounts? map;
  final ClassTopicPrompt? classPrompt;
  final NextUp? nextUp;
  final LearningListSummary? learningList;

  /// The learner took today off: show "Done for today" instead of a next lesson.
  final bool doneForToday;
  final List<PlanItem> plan;
  final WeekProgress week;
  final List<AppNotification> notifications;

  bool get firstCheckDone => stage == FirstCheckStage.done;

  int get unreadCount => notifications.where((n) => n.isNew).length;

  /// Lessons today. A quick check is not a lesson, so it is not counted.
  int get lessonsTotal =>
      plan.length +
      ((nextUp != null && nextUp!.kind != LessonKind.quickCheck) ? 1 : 0);

  int get lessonsDone =>
      plan.where((p) => p.status == LessonStatus.done).length;

  /// "Today's plan" once the learner is done, otherwise "Also today".
  String get planHeading =>
      (nextUp == null && doneForToday) ? 'Today’s plan' : 'Also today';

  TodayState copyWith({
    String? userName,
    DateTime? now,
    bool? offline,
    FirstCheckStage? stage,
    MapCounts? map,
    ClassTopicPrompt? classPrompt,
    bool clearNextUp = false,
    NextUp? nextUp,
    LearningListSummary? learningList,
    bool? doneForToday,
    List<AppNotification>? notifications,
    List<PlanItem>? plan,
    WeekProgress? week,
  }) {
    return TodayState(
      userName: userName ?? this.userName,
      now: now ?? this.now,
      offline: offline ?? this.offline,
      stage: stage ?? this.stage,
      map: map ?? this.map,
      classPrompt: classPrompt ?? this.classPrompt,
      nextUp: clearNextUp ? null : nextUp ?? this.nextUp,
      learningList: learningList ?? this.learningList,
      doneForToday: doneForToday ?? this.doneForToday,
      plan: plan ?? this.plan,
      week: week ?? this.week,
      notifications: notifications ?? this.notifications,
    );
  }
}
