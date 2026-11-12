import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../api/repositories/widget.dart';
import '../../models/model.dart';
import '../../theme/widget.dart';
import '../../widgets/widget.dart';
import '../routes/widget.dart';

/// "Your learning list": the topics to learn, in order, grouped as
/// Your class / Stretch / Not checked yet. Content comes from
/// assets/json/learning_list.json; what is learned or paused comes from
/// [LessonProgressStore].
class LearningListPage extends StatefulWidget {
  const LearningListPage({super.key});

  @override
  State<LearningListPage> createState() => _LearningListPageState();
}

class _LearningListPageState extends State<LearningListPage> {
  late final Future<LearningListData> _future = LearningListRepository.fetch();
  final LessonProgressStore _progress = LessonProgressStore.instance;

  // ── actions ────────────────────────────────────────────────────────────

  void _learn(LearningListTopic topic) {
    navBarVisible.value = false;
    context.push(
      '${AppRoutes.mainMap}/${AppRoutes.mainMapLearningLearningScreen}',
      extra: Skill(topic.name, BrickState.unchecked, contentId: topic.topicId),
    );
  }

  void _practise(String topicId) {
    navBarVisible.value = false;
    context.push<PracticeLessonResult>(
      '${AppRoutes.mainMap}/${AppRoutes.mainMapPracticeLesson}/'
      '${Uri.encodeComponent(topicId)}',
    ).whenComplete(() {
      if (mounted) navBarVisible.value = true;
    });
  }

  /// Learned topics go straight to practice; everything else starts with the
  /// short teaching lesson.
  void _open(LearningListTopic topic) {
    if (_progress.isLearned(topic.topicId)) {
      _practise(topic.topicId);
    } else {
      _learn(topic);
    }
  }

  // ── build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: c.textPrimary),
                    tooltip: 'Back',
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Your learning list',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<LearningListData>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'We could not load your learning list. Please try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: c.textSecondary),
                        ),
                      ),
                    );
                  }
                  final data = snapshot.data!;
                  return ListenableBuilder(
                    listenable: _progress,
                    builder: (context, _) => _list(context, data),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context, LearningListData data) {
    final paused = _progress.latestInProgress;
    var number = 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _introCard(context, data),
        if (paused != null) ...[
          const SizedBox(height: 14),
          _pausedCard(context, paused),
        ],
        for (final section in data.sections) ...[
          const SizedBox(height: 22),
          _sectionHeader(context, section),
          const SizedBox(height: 10),
          for (final topic in section.topics) ...[
            _topicRow(context, topic, ++number),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }

  Widget _introCard(BuildContext context, LearningListData data) {
    final c = context.colors;
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.intro,
            style: TextStyle(fontSize: 14, height: 1.45, color: c.textPrimary),
          ),
          if (data.introNote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              data.introNote,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: c.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _pausedCard(BuildContext context, InProgressLesson paused) {
    final c = context.colors;
    return _card(
      context,
      borderColor: c.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have a ${paused.kind} lesson on ${paused.topicName.toLowerCase()} in progress.',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton(
              onPressed: () => _practise(paused.topicId),
              style: FilledButton.styleFrom(
                backgroundColor: c.surfaceInset,
                foregroundColor: c.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Carry on with it'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, LearningListSection section) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                section.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: c.textPrimary,
                ),
              ),
            ),
            Text(
              section.trailing,
              style: TextStyle(fontSize: 12, color: c.textSecondary),
            ),
          ],
        ),
        if (section.caption != null) ...[
          const SizedBox(height: 4),
          Text(
            section.caption!,
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: c.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _topicRow(BuildContext context, LearningListTopic topic, int number) {
    final c = context.colors;
    final learned = _progress.isLearned(topic.topicId);
    final practised = _progress.isPractised(topic.topicId);

    final subtitle = [
      if (topic.startHere) 'Start here',
      practised
          ? 'Practised'
          : learned
              ? 'Learned. Practise next'
              : 'About ${topic.minutes} min',
    ].join(' · ');

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _open(topic),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: topic.startHere ? c.accent : c.divider,
              width: topic.startHere ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              BrickFace(topic.brick, width: 36, height: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.name,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.3,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _pill(
                context,
                practised ? 'Practise again' : learned ? 'Practise' : 'Learn',
                primary: learned,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(BuildContext context, String label, {required bool primary}) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: primary ? c.accent : c.surfaceInset,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: primary ? c.onAccent : c.textPrimary,
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required Widget child,
    Color? borderColor,
  }) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor ?? c.divider,
          width: borderColor == null ? 1 : 1.5,
        ),
      ),
      child: child,
    );
  }
}
