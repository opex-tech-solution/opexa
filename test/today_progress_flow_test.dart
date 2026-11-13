import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opexa/api/repositories/lesson_progress_store.dart';
import 'package:opexa/models/model.dart';
import 'package:opexa/screens/home/home_widget/today_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Today keeps a learned topic in Next Up until its practice is completed',
    () async {
      SharedPreferences.setMockInitialValues({});

      final progress = LessonProgressStore.instance;
      await progress.load();

      TodayStore.instance.completeFirstCheck();
      expect(
        TodayStore.instance.value.nextUp?.title,
        'Add & subtract integers',
      );

      TodayStore.instance.completeLesson('addition_subtraction_integers');

      // Teach Me is complete, but the topic is still waiting for practice.
      expect(
        TodayStore.instance.value.nextUp?.title,
        'Add & subtract integers',
      );
      expect(
        TodayStore.instance.value.nextUp?.primaryLabel,
        'Start practice',
      );
      expect(
        TodayStore.instance.value.nextUp?.badge,
        'Practise next',
      );

      TodayStore.instance.completePractice(
        'addition_subtraction_integers',
        status: 'solid',
      );

      expect(
        TodayStore.instance.value.nextUp?.title,
        'Two-step equations',
      );
      expect(
        TodayStore.instance.value.plan.first.status,
        LessonStatus.done,
      );

      TodayStore.instance.completeLesson('two_step_equations');
      expect(
        TodayStore.instance.value.nextUp?.title,
        'Two-step equations',
      );
      expect(
        TodayStore.instance.value.nextUp?.primaryLabel,
        'Start practice',
      );

      TodayStore.instance.completePractice(
        'two_step_equations',
        status: 'building',
      );
      expect(
        TodayStore.instance.value.nextUp?.title,
        'Word problems',
      );

      TodayStore.instance.completeLesson('word_problems');
      expect(
        TodayStore.instance.value.nextUp?.primaryLabel,
        'Start practice',
      );

      TodayStore.instance.completePractice('word_problems', status: 'solid');

      final today = TodayStore.instance.value;
      expect(today.nextUp, isNull);
      expect(today.doneForToday, isTrue);
      expect(today.lessonsDone, 3);
      expect(today.lessonsTotal, 3);
      expect(today.week.lessons, 3);
      expect(today.week.daysLearning, 1);
      expect(progress.statusFor('word_problems'), BrickProgressStatus.solid);
      expect(progress.hasCompletedToday('word_problems'), isTrue);
      expect(progress.isLearned('word_problems'), isTrue);
      expect(progress.isPractised('word_problems'), isTrue);
    },
  );
}
