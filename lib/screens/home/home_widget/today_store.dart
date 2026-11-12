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
    final isNewToday = !_progress.hasCompletedToday(topicId);
    unawaited(_progress.markLessonCompleted(topicId));
    _applyCompletion(topicId, countAsNewActivity: isNewToday);
  }

  /// Called when a learner submits the independent Practice Lesson check.
  void completePractice(String topicId, {required String status}) {
    if (topicId.isEmpty) return;
    final isNewToday = !_progress.hasCompletedToday(topicId);
    unawaited(_progress.markPractised(topicId, status: status));
    _applyCompletion(topicId, countAsNewActivity: isNewToday);
  }

  void _applyCompletion(
    String topicId, {
    bool countAsNewActivity = true,
  }) {
    final current = value;
    if (!current.firstCheckDone) return;

    final next = current.nextUp;
    final plan = [...current.plan];

    final week = _weekAfterActivity(
      current.week,
      countAsNewActivity: countAsNewActivity,
    );
    final updated = current.copyWith(
      map: _mapCountsFromProgress(),
      week: week,
    );

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

      value = updated.copyWith(
        clearNextUp: nextUp == null,
        nextUp: nextUp,
        plan: plan,
        doneForToday: nextUp == null &&
            plan.every((item) => item.status == LessonStatus.done),
      );
      return;
    }

    final index = plan.indexWhere((item) => item.topicId == topicId);
    if (index < 0 || plan[index].status == LessonStatus.done) {
      value = updated;
      return;
    }

    final item = plan[index];
    plan[index] = PlanItem(
      kind: item.kind,
      title: item.title,
      brick: item.brick,
      status: LessonStatus.done,
      caption: 'Completed today',
      topicId: item.topicId,
    );

    value = updated.copyWith(
      plan: plan,
      doneForToday: updated.nextUp == null &&
          plan.every((item) => item.status == LessonStatus.done),
    );
  }

  MapCounts _mapCountsFromProgress() {
    var mastered = 0;
    var lockedIn = 0;
    var solid = 0;
    var building = 0;
    var notSure = 0;
    var notChecked = 0;

    final wall = buildWall(afterFirstCheck: true);
    for (final skill in wall.all) {
      final state = switch (_progress.statusFor(skill.topicId ?? '')) {
        BrickProgressStatus.notSure => BrickState.notSure,
        BrickProgressStatus.building => BrickState.building,
        BrickProgressStatus.solid => BrickState.solid,
        BrickProgressStatus.mastered => BrickState.mastered,
        BrickProgressStatus.lockedIn => BrickState.lockedIn,
        null => skill.state,
      };

      switch (state) {
        case BrickState.mastered:
          mastered++;
        case BrickState.lockedIn:
          lockedIn++;
        case BrickState.solid:
          solid++;
        case BrickState.building:
          building++;
        case BrickState.notSure:
          notSure++;
        case BrickState.unchecked:
          notChecked++;
      }
    }

    return MapCounts(
      mastered: mastered,
      lockedIn: lockedIn,
      solid: solid,
      building: building,
      notSure: notSure,
      notChecked: notChecked,
    );
  }

  WeekProgress _weekAfterActivity(
    WeekProgress previous, {
    required bool countAsNewActivity,
  }) {
    if (!countAsNewActivity) return previous;

    final days = [...previous.learnedDays];
    if (days.length == 7) {
      days[6] = true;
    } else {
      days.add(true);
      while (days.length > 7) {
        days.removeAt(0);
      }
    }

    return WeekProgress(
      learnedDays: days,
      lessons: previous.lessons + 1,
      blocksMovedUp: previous.blocksMovedUp,
    );
  }

  NextUp _toNextUp(PlanItem item) {
    final minuteMatch = RegExp(r'(\d+)').firstMatch(item.caption);
    final minutes = int.tryParse(minuteMatch?.group(1) ?? '') ?? 5;
    return NextUp(
      kind: item.kind,
      title: item.title,
      description:
          'Continue learning ${item.title.toLowerCase()} with a short guided lesson.',
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
