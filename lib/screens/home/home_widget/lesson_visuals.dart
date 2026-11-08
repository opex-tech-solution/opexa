import 'package:flutter/material.dart';

import '../../../models/model.dart';

/// "Foundation", "Class", "Stretch", "Quick check".
String lessonKindLabel(LessonKind kind) => switch (kind) {
  LessonKind.foundation => 'Foundation',
  LessonKind.klass => 'Class',
  LessonKind.stretch => 'Stretch',
  LessonKind.quickCheck => 'Quick check',
};

IconData lessonKindIcon(LessonKind kind) => switch (kind) {
  LessonKind.foundation => Icons.layers_outlined,
  LessonKind.klass => Icons.menu_book_outlined,
  LessonKind.stretch => Icons.bar_chart,
  LessonKind.quickCheck => Icons.lock_outline,
};
