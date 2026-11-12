import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../api/repositories/lesson_content_repository.dart';
import '../../api/repositories/lesson_progress_store.dart';
import '../../models/model.dart';
import '../../theme/widget.dart';
import '../routes/widget.dart';
import 'home_widget/home_widget.dart';
/// The "Today" tab.
///
/// It draws a [TodayState]: before the first check it shows the starting card
/// and the three tracks; after it, the map, the next lesson, today's plan and
/// the week. With no [state] it follows [TodayStore.instance], so it updates
/// when the learner makes progress. Pass a [state] to show a fixed one (tests,
/// screenshots).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.state});

  final TodayState? state;

  @override
  Widget build(BuildContext context) {
    final fixed = state;
    if (fixed != null) return _TodayView(state: fixed);
    return ValueListenableBuilder<TodayState>(
      valueListenable: TodayStore.instance,
      builder: (context, current, _) => _TodayView(state: current),
    );
  }
}

class _TodayView extends StatelessWidget {
  const _TodayView({required this.state});

  final TodayState state;

  // ── actions ──────────────────────────────────────────────────────────────

  void _openNotifications(BuildContext context) => context.push(
    '${AppRoutes.mainHome}/${AppRoutes.mainHomeNotifications}',
  );

  void _openFirstCheck(BuildContext context) => context.push(
    AppRoutes.mathDiagnostic,
    extra: MathFlowArgs(userName: state.userName),
  );

  Future<void> _openLesson(
    BuildContext context, {
    required String? topicId,
    required String title,
    required BrickState brick,
    required LessonKind kind,
  }) async {
    final resolvedId =
        topicId ?? LessonContentRepository.topicIdForSkillName(title);
    if (resolvedId == null || resolvedId.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Learning content for "$title" is not available yet.')),
        );
      return;
    }

    final skill = Skill(title, brick, topicId: resolvedId);
    navBarVisible.value = false;
    try {
      if (kind == LessonKind.quickCheck) {
        final quickPath = AppRoutes.mainHomeQuickPractice.replaceFirst(
          ':topicId',
          Uri.encodeComponent(resolvedId),
        );
        await context.push(
          '${AppRoutes.mainHome}/$quickPath',
          extra: skill,
        );
      } else if (LessonProgressStore.instance.isLearned(resolvedId)) {
        await context.push(
          '${AppRoutes.mainMap}/${AppRoutes.mainMapPracticeLesson}/'
          '${Uri.encodeComponent(resolvedId)}',
        );
      } else {
        await context.push(
          '${AppRoutes.mainMap}/${AppRoutes.mainMapSkillDetails}/'
          '${AppRoutes.mainMapLearningLearningScreen}',
          extra: skill,
        );
      }
    } finally {
      if (context.mounted) navBarVisible.value = true;
    }
  }

  // ── layout ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final today = state.now ?? DateTime.now();

    return Scaffold(
      body: SafeArea(
        bottom: false, // the bottom navigation bar handles this inset
        child: DefaultTextStyle.merge(
          style: TextStyle(color: c.textPrimary),
          child: IconTheme.merge(
            data: IconThemeData(color: c.textPrimary),
            child: Column(
              children: [
                if (state.offline) const OfflineBanner(),
                TodayHeader(
                  unreadCount: state.unreadCount,
                  onBellTap: () => _openNotifications(context),
                  onTitleLongPress: kDebugMode
                      ? () => showTodayStatePicker(context)
                      : null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${greetingFor(today)}, ${state.userName}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatLongDate(today),
                          style: TextStyle(fontSize: 13, color: c.textSecondary),
                        ),
                        const SizedBox(height: 20),
                        ..._content(context, today),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, DateTime today) {
    return state.firstCheckDone
        ? _afterFirstCheck(context, today)
        : _beforeFirstCheck(context);
  }

  /// States 1 and 3: the first check is not finished.
  List<Widget> _beforeFirstCheck(BuildContext context) {
    final started = state.stage == FirstCheckStage.inProgress;
    return [
      ResumeCard(
        title: started ? 'Pick up where you left off' : 'Let’s find your starting point',
        body: started
            ? 'You’re part way through your first check. We’ll start at the '
                  'exact question where you stopped.'
            : 'Take a quick check so OpexA can see what you already know, spot '
                  'the next block to work on, and guide you on what to do today.',
        buttonLabel: started ? 'Continue my first check' : 'Start my first check',
        // push (not go): leaving the check returns to Today.
        onPressed: () => _openFirstCheck(context),
      ),
      const SizedBox(height: 24),
      const SectionHeading('Your three tracks'),
      const SizedBox(height: 10),
      for (final track in kTracks)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TrackTile(
            track: track,
            onTap: () => showTrackInfoSheet(context, track),
          ),
        ),
    ];
  }

  /// States 4 and 6 to 11: there is a map and a plan.
  List<Widget> _afterFirstCheck(BuildContext context, DateTime today) {
    final map = state.map;
    final prompt = state.classPrompt;
    final nextUp = state.nextUp;
    final learningList = state.learningList;

    final learningListCard = learningList == null
        ? null
        : LearningListCard(
            summary: learningList,
            onTap: () => context.push(AppRoutes.mathLearningList),
          );

    return [
      if (map != null) ...[
        MapSummaryCard(counts: map, onTap: () => context.go(AppRoutes.mainMap)),
        const SizedBox(height: 16),
      ],
      if (prompt != null) ...[
        ClassTopicCard(
          prompt: prompt,
          onSelect: TodayStore.instance.selectClassTopic,
        ),
        const SizedBox(height: 24),
      ],
      if (nextUp != null) ...[
        const SectionHeading('Next up'),
        const SizedBox(height: 10),
        NextUpCard(
          nextUp: nextUp,
          onPrimary: () => unawaited(
            _openLesson(
              context,
              topicId: nextUp.topicId,
              title: nextUp.title,
              brick: nextUp.brick,
              kind: nextUp.kind,
            ),
          ),
          onSecondary: TodayStore.instance.takeTodayOff,
        ),
        const SizedBox(height: 16),
        if (learningListCard != null) ...[
          learningListCard,
          const SizedBox(height: 24),
        ],
      ] else ...[
        if (learningListCard != null) ...[
          learningListCard,
          const SizedBox(height: 16),
        ],
        if (state.doneForToday) ...[
          const DoneForTodayCard(),
          const SizedBox(height: 24),
        ],
      ],
      if (state.plan.isNotEmpty) ...[
        PlanCard(
          state: state,
          onOpen: (item) => unawaited(
            _openLesson(
              context,
              topicId: item.topicId,
              title: item.title,
              brick: item.brick,
              kind: item.kind,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
      const SectionHeading('This week'),
      const SizedBox(height: 10),
      WeekCard(week: state.week, today: today),
    ];
  }
}
