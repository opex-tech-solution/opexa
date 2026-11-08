
import '../../../models/model.dart';

/// "Good morning" / "Good afternoon" / "Good evening" for the given time.
String greetingFor(DateTime now) {
  final hour = now.hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// "Friday 6 November"
String formatLongDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]} ${date.day} ${_months[date.month - 1]}';

/// "4 solid · 1 building · 9 not checked yet": only the kinds that exist,
/// strongest first.
String mapSummary(MapCounts m) {
  final parts = <String>[
    if (m.mastered > 0) '${m.mastered} mastered',
    if (m.lockedIn > 0) '${m.lockedIn} locked in',
    if (m.solid > 0) '${m.solid} solid',
    if (m.building > 0) '${m.building} building',
    if (m.notSure > 0) '${m.notSure} not sure yet',
    if (m.notChecked > 0) '${m.notChecked} not checked yet',
  ];
  return parts.join(' · ');
}

/// "About 10 min · Works offline · about 5 KB"
String lessonMeta({
  required int minutes,
  required bool worksOffline,
  String? downloadSize,
}) {
  final parts = <String>[
    'About $minutes min',
    if (worksOffline) 'Works offline',
    ?downloadSize,
  ];
  return parts.join(' · ');
}

/// First letter of the weekday: M T W T F S S.
String weekdayInitial(DateTime date) => 'MTWTFSS'[date.weekday - 1];

/// The seven day labels of the "This week" card, oldest first, ending today.
List<String> weekInitials(DateTime today) => [
  for (var back = 6; back >= 0; back--)
    weekdayInitial(DateTime(today.year, today.month, today.day - back)),
];

/// " day learning" / " days learning" (the number is drawn separately, bigger).
String daysLearningSuffix(int days) => days == 1 ? ' day learning' : ' days learning';

/// "0 lessons", "1 lesson · 1 block up", "3 lessons · 2 blocks up".
String weekSummary(WeekProgress week) {
  final lessons = week.lessons == 1 ? '1 lesson' : '${week.lessons} lessons';
  final blocks = week.blocksMovedUp.length;
  if (blocks == 0) return lessons;
  return '$lessons · ${blocks == 1 ? '1 block' : '$blocks blocks'} up';
}
