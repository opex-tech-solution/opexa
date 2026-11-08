import 'package:flutter/foundation.dart';
import '../../../models/model.dart';
import 'today_samples.dart';

/// Holds the [TodayState] the Today tab shows, and the few things the learner
/// can change from it. Other screens (the diagnostic, the lessons) will update
/// it when the learner makes progress.
///
/// TODO: the starting value is a sample. Replace it with the real learner state
/// (from the check results and the lessons) once that exists.
class TodayStore extends ValueNotifier<TodayState> {
  TodayStore(super.value);

  static final TodayStore instance = TodayStore(TodaySamples.startingPoint);

  /// Shows another state (used by the debug picker).
  void show(TodayState state) => value = state;

  /// Applies the first-check result and reveals the learner's first plan.
  void completeFirstCheck() {
    value = TodaySamples.firstPlan.copyWith(
      userName: value.userName,
      now: value.now,
    );
  }

  /// "Not today": drop the next lesson and show "Done for today".
  void takeTodayOff() =>
      value = value.copyWith(clearNextUp: true, doneForToday: true);

  /// The learner picked this week's class topic.
  void selectClassTopic(String topic) {
    final prompt = value.classPrompt;
    if (prompt == null) return;
    value = value.copyWith(classPrompt: prompt.withSelected(topic));
  }

  /// Clears the bell badge.
  void markNotificationsRead() {
    if (value.unreadCount == 0) return;
    value = value.copyWith(
      notifications: [for (final n in value.notifications) n.asRead()],
    );
  }
}
