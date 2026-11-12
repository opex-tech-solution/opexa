import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opexa/api/repositories/lesson_progress_store.dart';
import 'package:opexa/screens/home/home_widget/today_store.dart';
import 'package:opexa/models/model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Today advances its plan and weekly progress as topics are completed', () async {
    SharedPreferences.setMockInitialValues({});

    final progress = LessonProgressStore.instance;
    await progress.load();
    await progress.markFirstCheckCompleted();

    TodayStore.instance.completeFirstCheck();

    expect(TodayStore.instance.value.nextUp?.title, 'Add & subtract integers');

    TodayStore.instance.completeLesson('addition_subtraction_integers');

    expect(TodayStore.instance.value.nextUp?.title, 'Two-step equations');
    expect(
      TodayStore.instance.value.plan.first.status,
      LessonStatus.done,
    );

    TodayStore.instance.completeLesson('two_step_equations');

    expect(TodayStore.instance.value.nextUp?.title, 'Word problems');

    TodayStore.instance.completePractice('word_problems', status: 'solid');

    final today = TodayStore.instance.value;
    expect(today.nextUp, isNull);
    expect(today.doneForToday, isTrue);
    expect(today.lessonsDone, 3);
    expect(today.lessonsTotal, 3);
    expect(today.week.lessons, 3);
    expect(today.week.daysLearning, 1);
    expect(progress.statusFor('word_problems'), BrickProgressStatus.solid);
  });
}
