import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../api/repositories/lesson_progress_store.dart';
import '../../../models/model.dart';
import 'today_samples.dart';

/// Shared Home state. Lesson and practice screens report completion here so
/// the Today cards update immediately and can be rebuilt after app restart.
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
    _restoreTodaysActivities(countAsNewActivity: true);
  }

  /// Applies the first-check result and restores any activities already
  /// completed today. A first-time check starts a fresh Today plan.
  void completeFirstCheck() {
    final isFirstCompletion = !_progress.firstCheckCompleted;
    unawaited(_progress.markFirstCheckCompleted());

    value = TodaySamples.firstPlan.copyWith(
      userName: value.userName,
      now: value.now,
    );
    _restoreTodaysActivities(
      countAsNewActivity: isFirstCompletion,
    );
  }

  void _restoreTodaysActivities({required bool countAsNewActivity}) {
    final orderedTopicIds = <String>[];
    final initial = TodaySamples.firstPlan;

    if (initial.nextUp?.topicId case final id?) {
      orderedTopicIds.add(id);
    }
    orderedTopicIds.addAll(
      initial.plan
          .map((item) => item.topicId)
          .whereType<String>()
          .where((id) => !orderedTopicIds.contains(id)),
    );

    final remaining = _progress.activityToday
        .where((id) => !orderedTopicIds.contains(id))
        .toList()
      ..sort();

    for (final id in [...orderedTopicIds, ...remaining]) {
      if (!_progress.hasActivityToday(id)) continue;

      _applyLessonCompletion(
        id,
        countAsNewActivity: countAsNewActivity,
      );

      if (_progress.hasCompletedToday(id)) {
        _applyPracticeCompletion(
          id,
          countAsNewActivity: false,
        );
      }
    }
  }

  /// A completed Teach Me lesson means the learner is ready to practise.
  /// It must not mark the topic as fully completed or advance the plan yet.
  void completeLesson(String topicId) {
    if (topicId.isEmpty) return;
    final isNewActivity = !_progress.hasActivityToday(topicId);
    unawaited(_progress.markLessonCompleted(topicId));
    _applyLessonCompletion(
      topicId,
      countAsNewActivity: isNewActivity,
    );
  }

  /// The independent Practice Lesson completes the topic and advances Today.
  void completePractice(String topicId, {required String status}) {
    if (topicId.isEmpty) return;
    final isNewActivity = !_progress.hasActivityToday(topicId);
    unawaited(_progress.markPractised(topicId, status: status));
    _applyPracticeCompletion(
      topicId,
      countAsNewActivity: isNewActivity,
    );
  }

  void _applyLessonCompletion(
    String topicId, {
    required bool countAsNewActivity,
  }) {
    final current = value;
    if (!current.firstCheckDone) return;

    final updated = current.copyWith(
      map: _mapCountsFromProgress(),
      week: _weekAfterActivity(
        current.week,
        countAsNewActivity: countAsNewActivity,
      ),
    );

    // Re-teaching a topic that has already been practised must not put it
    // back into the "Practise next" state or disturb the current queue.
    if (_progress.isPractised(topicId)) {
      value = updated;
      return;
    }

    final next = current.nextUp;
    if (next != null && next.topicId == topicId) {
      value = updated.copyWith(
        nextUp: NextUp(
          kind: next.kind,
          title: next.title,
          description:
              'You have learned ${next.title.toLowerCase()}. Practise it to complete this block.',
          brick: next.brick,
          minutes: next.minutes,
          reasons: next.reasons,
          worksOffline: next.worksOffline,
          downloadSize: next.downloadSize,
          badge: 'Practise next',
          primaryLabel: 'Start practice',
          secondaryLabel: next.secondaryLabel,
          tone: next.tone,
          topicId: topicId,
        ),
      );
      return;
    }

    final index = current.plan.indexWhere(
      (item) => item.topicId == topicId,
    );
    if (index < 0) {
      value = updated;
      return;
    }

    final plan = [...current.plan];
    final item = plan[index];
    if (item.status == LessonStatus.done) {
      value = updated;
      return;
    }

    plan[index] = PlanItem(
      kind: item.kind,
      title: item.title,
      brick: item.brick,
      status: item.status,
      caption: 'Learned · practise next',
      topicId: item.topicId,
    );
    value = updated.copyWith(plan: plan);
  }

  /// Marks a topic as done and advances Next Up only after practice.
  void _applyPracticeCompletion(
    String topicId, {
    required bool countAsNewActivity,
  }) {
    final current = value;
    if (!current.firstCheckDone) return;

    final plan = [...current.plan];
    final updated = current.copyWith(
      map: _mapCountsFromProgress(),
      week: _weekAfterActivity(
        current.week,
        countAsNewActivity: countAsNewActivity,
      ),
    );

    if (current.nextUp?.topicId == topicId) {
      final next = current.nextUp!;

      // Keep a completed history row when the Next Up item wasn't already
      // part of the visible plan.
      final existingIndex = plan.indexWhere(
        (item) => item.topicId == topicId,
      );
      if (existingIndex < 0) {
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
      } else {
        final existing = plan[existingIndex];
        plan[existingIndex] = PlanItem(
          kind: existing.kind,
          title: existing.title,
          brick: existing.brick,
          status: LessonStatus.done,
          caption: 'Completed today',
          topicId: existing.topicId,
        );
      }

      final promoteIndex = plan.indexWhere(
        (item) =>
            item.status == LessonStatus.todo && item.topicId != null,
      );
      final promoted = promoteIndex < 0 ? null : plan.removeAt(promoteIndex);
      final nextUp = promoted == null ? null : _toNextUp(promoted);
      final allDone = nextUp == null &&
          plan.every((item) => item.status == LessonStatus.done);

      value = updated.copyWith(
        clearNextUp: nextUp == null,
        nextUp: nextUp,
        plan: plan,
        doneForToday: allDone,
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
          break;
        case BrickState.lockedIn:
          lockedIn++;
          break;
        case BrickState.solid:
          solid++;
          break;
        case BrickState.building:
          building++;
          break;
        case BrickState.notSure:
          notSure++;
          break;
        case BrickState.unchecked:
          notChecked++;
          break;
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
    final learned = _progress.isLearned(item.topicId ?? '');
    return NextUp(
      kind: item.kind,
      title: item.title,
      description: learned
          ? 'You have learned ${item.title.toLowerCase()}. Practise it to complete this block.'
          : 'Continue learning ${item.title.toLowerCase()} with a short guided lesson.',
      brick: item.brick,
      minutes: minutes,
      badge: learned ? 'Practise next' : null,
      primaryLabel: learned ? 'Start practice' : 'Start',
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
