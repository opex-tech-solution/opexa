import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opexa/models/lesson_content.dart';
import 'package:opexa/models/skill.dart';
import 'package:opexa/screens/map/teaching_lesson_page.dart';
import 'package:opexa/theme/app_colors.dart';

void main() {
  testWidgets('allows changing an answer and scores the final choice', (
    tester,
  ) async {
    const topic = TopicContent(
      id: 'test_topic',
      name: 'Test topic',
      subjectId: 'math',
      summary: '',
      level: '',
      estimatedLessonMinutes: 1,
      lessonSteps: [],
      practiceQuestions: [
        AssessmentQuestion(
          id: 'question',
          prompt: 'Choose an answer',
          type: 'multiple_choice',
          options: [
            AnswerOption(id: 'A', text: 'First choice'),
            AnswerOption(id: 'B', text: 'Second choice'),
          ],
          correctOptionId: 'A',
          explanation: 'Explanation',
          difficulty: 'easy',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: const QuickPracticeScreen(
          skill: Skill('Test skill', BrickState.unchecked),
          topicContent: topic,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('First choice'));
    await tester.pump();
    expect(find.text('Correct'), findsOneWidget);

    await tester.tap(find.text('Second choice'));
    await tester.pump();
    expect(find.text('Not quite'), findsOneWidget);

    await tester.tap(find.text('Finish practice'));
    await tester.pump();
    expect(find.text('You got 0 of 1 questions right.'), findsOneWidget);
  });
}
