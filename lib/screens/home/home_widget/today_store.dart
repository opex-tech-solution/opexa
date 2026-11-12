import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../../api/repositories/lesson_progress_store.dart';
import '../../../models/model.dart';
import 'today_samples.dart';

/// Shared Home state. Lesson and practice screens report completion here so
/// the Today cards update immediately and are reconstructed after app restart.
class TodayStore extends ValueNotifier<TodayState> {
  TodayStore(super.value);

  static final TodayStore instance = TodayStore(TodaySamples.startingPoint);
  final LessonProgressStore _progress = LessonProgressStore.instance;

  Future<void> initFromProgress() async {
    if (!_progress.firstCheckCompleted) {
      value = TodaySamples.startingPoint.copyWith(userName: value.userName);
      return;
    }

    value = TodaySamples.firstPlan.copyWith(userName: value.userName);
    final completed = _progress.completedToday.toList()..sort();
    for (final topicId in completed) {
      _applyCompletion(topicId);
    }
  }

  /// Applies the first-check result and restores today's completed activities.
  void completeFirstCheck() {
    unawaited(_progress.markFirstCheckCompleted());
    value = TodaySamples.firstPlan.copyWith(
      userName: value.userName,
      now: value.now,
    );
    final completed = _progress.completedToday.toList()..sort();
    for (final topicId in completed) {
      _applyCompletion(topicId);
    }
  }

  /// Called when a learner reaches the end of the seven-stage Teach Me flow.
  void completeLesson(String topicId) {
    if (topicId.isEmpty) return;
    unawaited(_progress.markLessonCompleted(topicId));
    _applyCompletion(topicId);
  }

  /// Called when a learner submits the independent Practice Lesson check.
  void completePractice(String topicId, {required String status}) {
    if (topicId.isEmpty) return;
    unawaited(_progress.markPractised(topicId, status: status));
    _applyCompletion(topicId);
  }

  void _applyCompletion(String topicId) {
    final current = value;
    if (!current.firstCheckDone) return;

    final next = current.nextUp;
    final plan = [...current.plan];

    if (next != null && next.topicId == topicId) {
      // Preserve the completed card in the plan, then promote the next
      // available item into the prominent Next up card.
      if (!plan.any((item) => item.topicId == topicId)) {
        plan.insert(
          0,
          PlanItem(
            kind: next.kind,
            title: next.title,
            brick: next.brick,
            status: LessonStatus.done,
            caption: 'Completed today',
            topicId: topicId,
          ),
        );
      }

      final promoteIndex = plan.indexWhere(
        (item) => item.status == LessonStatus.todo && item.topicId != null,
      );
      final promoted = promoteIndex < 0 ? null : plan.removeAt(promoteIndex);
      final nextUp = promoted == null ? null : _toNextUp(promoted);

      value = current.copyWith(
        clearNextUp: nextUp == null,
        nextUp: nextUp,
        plan: plan,
        doneForToday: nextUp == null &&
            plan.every((item) => item.status == LessonStatus.done),
      );
      return;
    }

    final index = plan.indexWhere((item) => item.topicId == topicId);
    if (index < 0 || plan[index].status == LessonStatus.done) return;

    final item = plan[index];
    plan[index] = PlanItem(
      kind: item.kind,
      title: item.title,
      brick: item.brick,
      status: LessonStatus.done,
      caption: 'Completed today',
      topicId: item.topicId,
    );

    value = current.copyWith(
      plan: plan,
      doneForToday: current.nextUp == null &&
          plan.every((item) => item.status == LessonStatus.done),
    );
  }

  NextUp _toNextUp(PlanItem item) {
    final minuteMatch = RegExp(r'(\d+)').firstMatch(item.caption);
    final minutes = int.tryParse(minuteMatch?.group(1) ?? '') ?? 5;
    return NextUp(
      kind: item.kind,
      title: item.title,
      description: 'Continue learning ${item.title.toLowerCase()} with a short guided lesson.',
      brick: item.brick,
      minutes: minutes,
      primaryLabel: 'Start',
      topicId: item.topicId,
    );
  }

  /// Shows another state (used by the debug picker).
  void show(TodayState state) => value = state;

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
