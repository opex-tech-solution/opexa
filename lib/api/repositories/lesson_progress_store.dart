import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

/// A practice lesson the learner stopped part-way through.
class InProgressLesson {
  const InProgressLesson({
    required this.topicId,
    required this.topicName,
    required this.savedAt,
    this.kind = 'Class',
    this.snapshot,
  });

  final String topicId;
  final String topicName;
  final String kind; // "Class", "Foundation", ...
  final DateTime savedAt;

  /// Exact place to resume from; null means "start at the beginning".
  final Map<String, dynamic>? snapshot;

  Map<String, dynamic> toJson() => {
        'topic_id': topicId,
        'name': topicName,
        'kind': kind,
        'saved_at': savedAt.toIso8601String(),
        'snapshot': snapshot,
      };

  factory InProgressLesson.fromJson(Map<String, dynamic> json) {
    final snap = json['snapshot'];
    return InProgressLesson(
      topicId: '${json['topic_id'] ?? ''}',
      topicName: '${json['name'] ?? ''}',
      kind: '${json['kind'] ?? 'Class'}',
      savedAt: DateTime.tryParse('${json['saved_at'] ?? ''}') ?? DateTime.now(),
      snapshot: snap is Map ? Map<String, dynamic>.from(snap) : null,
    );
  }
}

/// What the learner has learned, practised and paused. Kept on the phone, so
/// it works offline ("Your answers are saved on this phone").
///
/// Call [load] once in main() before runApp, like ThemeController.init().
class LessonProgressStore extends ChangeNotifier {
  LessonProgressStore._();

  static final LessonProgressStore instance = LessonProgressStore._();

  static const String _prefsKey = 'lesson_progress_v1';
  static const String _seedAsset = 'assets/json/learning_list.json';

  final Set<String> _learned = {};
  final Set<String> _practised = {};
  final Map<String, InProgressLesson> _inProgress = {};

  bool isLearned(String topicId) => _learned.contains(topicId);
  bool isPractised(String topicId) => _practised.contains(topicId);
  InProgressLesson? inProgressFor(String topicId) => _inProgress[topicId];

  /// The most recently paused lesson, for "Carry on with it".
  InProgressLesson? get latestInProgress {
    InProgressLesson? latest;
    for (final item in _inProgress.values) {
      if (latest == null || item.savedAt.isAfter(latest.savedAt)) latest = item;
    }
    return latest;
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null) {
        _apply(jsonDecode(raw));
      } else {
        await _seedFromAsset();
        await _save();
      }
    } catch (error) {
      debugPrint('Could not load lesson progress: $error');
    }
  }

  Future<void> markLearned(String topicId) async {
    if (topicId.isEmpty || !_learned.add(topicId)) return;
    notifyListeners();
    await _save();
  }

  /// Practice finished: counts as practised and is no longer "in progress".
  Future<void> markPractised(String topicId) async {
    if (topicId.isEmpty) return;
    _practised.add(topicId);
    _learned.add(topicId);
    _inProgress.remove(topicId);
    notifyListeners();
    await _save();
  }

  Future<void> saveInProgress({
    required String topicId,
    required String topicName,
    required String kind,
    required Map<String, dynamic> snapshot,
  }) async {
    _inProgress[topicId] = InProgressLesson(
      topicId: topicId,
      topicName: topicName,
      kind: kind,
      savedAt: DateTime.now(),
      snapshot: snapshot,
    );
    notifyListeners();
    await _save();
  }

  Future<void> clearInProgress(String topicId) async {
    if (_inProgress.remove(topicId) == null) return;
    notifyListeners();
    await _save();
  }

  // ── storage ────────────────────────────────────────────────────────────

  void _apply(dynamic data) {
    if (data is! Map) return;
    _learned
      ..clear()
      ..addAll((data['learned'] as List? ?? const []).map((e) => '$e'));
    _practised
      ..clear()
      ..addAll((data['practised'] as List? ?? const []).map((e) => '$e'));
    _inProgress.clear();
    for (final item in (data['in_progress'] as List? ?? const [])) {
      if (item is Map) {
        final parsed = InProgressLesson.fromJson(Map<String, dynamic>.from(item));
        if (parsed.topicId.isNotEmpty) _inProgress[parsed.topicId] = parsed;
      }
    }
  }

  Future<void> _seedFromAsset() async {
    final raw = await rootBundle.loadString(_seedAsset);
    final decoded = jsonDecode(raw);
    final seed = decoded is Map ? decoded['initial_state'] : null;
    if (seed is! Map) return;

    _learned.addAll((seed['learned'] as List? ?? const []).map((e) => '$e'));
    final paused = seed['in_progress'];
    if (paused is Map) {
      final item = InProgressLesson(
        topicId: '${paused['topic_id'] ?? ''}',
        topicName: '${paused['name'] ?? ''}',
        kind: '${paused['kind'] ?? 'Class'}',
        savedAt: DateTime.now(),
      );
      if (item.topicId.isNotEmpty) _inProgress[item.topicId] = item;
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefsKey,
        jsonEncode({
          'learned': _learned.toList(),
          'practised': _practised.toList(),
          'in_progress': _inProgress.values.map((e) => e.toJson()).toList(),
        }),
      );
    } catch (error) {
      debugPrint('Could not save lesson progress: $error');
    }
  }
}
