import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opexa/api/repositories/practice_lesson_repository.dart';
import 'package:opexa/models/skill.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads practice content for each topic ID in the catalog', () async {
    final catalog =
        jsonDecode(
              await rootBundle.loadString(
                'assets/json/opexa_math_content.json',
              ),
            )
            as Map<String, dynamic>;
    final topics = catalog['topics'] as List<dynamic>;
    final repository = PracticeLessonRepository();
    final catalogIds = topics
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toSet();

    for (final skill in buildWall().all) {
      expect(
        skill.topicId,
        isNotNull,
        reason: 'Map skill "${skill.name}" needs a catalog topic ID',
      );
      expect(
        catalogIds,
        contains(skill.topicId),
        reason: 'Map skill "${skill.name}" references a missing topic',
      );
    }

    for (final item in topics) {
      final topic = item as Map<String, dynamic>;
      final topicId = topic['id'] as String;
      final lesson = await repository.getPracticeLesson(topicId);

      expect(lesson, isNotNull, reason: 'Missing practice lesson for $topicId');
      expect(lesson!.topicId, topicId);
      expect(lesson.title, topic['name']);
      expect(lesson.guidedPractice, isNotEmpty);
      expect(lesson.independentCheck, isNotEmpty);
      expect(lesson.haveAGo.question.options, isNotEmpty);
      expect(lesson.whatIf.options, isNotEmpty);
      expect(lesson.result.showScore, isTrue);
      expect(lesson.result.recommendedNextActions, isNotEmpty);
    }
  });

  test('returns null for an unknown topic ID', () async {
    final repository = PracticeLessonRepository();

    expect(await repository.getPracticeLesson('unknown_topic'), isNull);
  });
}
