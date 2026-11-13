import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/today_state.dart';

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
  final String kind;
  final DateTime savedAt;
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

/// Offline-first learner progress shared by Today, Map, Teach Me and Practice.
///
/// This store is the common source of truth for completion. The JSON catalogue
/// defines learning content; this store records what the learner has done.
class LessonProgressStore extends ChangeNotifier {
  LessonProgressStore._();

  static final LessonProgressStore instance = LessonProgressStore._();

  static const String _prefsKey = 'lesson_progress_v1';
  static const String _seedAsset = 'assets/json/learning_list.json';

  final Set<String> _learned = {};
  final Set<String> _practised = {};
  final Set<String> _completedToday = {};
  final Set<String> _activityToday = {};
  final Map<String, Set<String>> _activityHistory = {};
  final Map<String, String> _statusByTopic = {};
  final Map<String, InProgressLesson> _inProgress = {};

  bool _firstCheckCompleted = false;
  String _activityDate = _dateKey(DateTime.now());

  bool get firstCheckCompleted => _firstCheckCompleted;
  Set<String> get completedToday => Set.unmodifiable(_completedToday);
  Set<String> get activityToday => Set.unmodifiable(_activityToday);
  Set<String> get learnedTopicIds => Set.unmodifiable(_learned);

  /// Seven-day activity summary used by the Today screen.
  WeekProgress get weekProgress {
    final today = DateTime.now();
    final days = List<bool>.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      return _activityHistory[_dateKey(date)]?.isNotEmpty ?? false;
    });
    final lessons = _activityHistory.values.fold<int>(
      0,
      (total, topics) => total + topics.length,
    );
    return WeekProgress(learnedDays: days, lessons: lessons);
  }
  bool isLearned(String topicId) => _learned.contains(topicId);
  bool isPractised(String topicId) => _practised.contains(topicId);
  bool hasCompletedToday(String topicId) => _completedToday.contains(topicId);
  bool hasActivityToday(String topicId) => _activityToday.contains(topicId);
  InProgressLesson? inProgressFor(String topicId) => _inProgress[topicId];

  BrickProgressStatus? statusFor(String topicId) {
    final status = _statusByTopic[topicId];
    return switch (status) {
      'solid' => BrickProgressStatus.solid,
      'building' => BrickProgressStatus.building,
      'mastered' => BrickProgressStatus.mastered,
      'locked_in' => BrickProgressStatus.lockedIn,
      'not_sure' => BrickProgressStatus.notSure,
      _ => null,
    };
  }

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
      }
      _ensureCurrentDay();
      await _save();
      notifyListeners();
    } catch (error) {
      debugPrint('Could not load lesson progress: $error');
    }
  }

  Future<void> markFirstCheckCompleted() async {
    if (_firstCheckCompleted) return;
    _firstCheckCompleted = true;
    notifyListeners();
    await _save();
  }

  Future<void> markLearned(String topicId) async {
    if (topicId.isEmpty) return;
    _ensureCurrentDay();
    final learnedChanged = _learned.add(topicId);
    final activityChanged = _recordActivity(topicId);
    if (learnedChanged || activityChanged) notifyListeners();
    await _save();
  }

  /// Records the seven-stage Teach Me experience as complete.
  Future<void> markLessonCompleted(String topicId) async {
    if (topicId.isEmpty) return;
    _ensureCurrentDay();
    final learnedChanged = _learned.add(topicId);
    final activityChanged = _recordActivity(topicId);
    final previousStatus = _statusByTopic[topicId];
    _statusByTopic.putIfAbsent(topicId, () => 'building');
    if (learnedChanged || activityChanged || previousStatus == null) {
      notifyListeners();
    }
    await _save();
  }

  /// Records the eight-stage Practice Lesson and its resulting skill state.
  Future<void> markPractised(
    String topicId, {
    String status = 'building',
  }) async {
    if (topicId.isEmpty) return;
    _ensureCurrentDay();
    _learned.add(topicId);
    _practised.add(topicId);
    _completedToday.add(topicId);
    _recordActivity(topicId);
    _statusByTopic[topicId] = status == 'solid' ? 'solid' : 'building';
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

  bool _recordActivity(String topicId) {
    final addedToday = _activityToday.add(topicId);
    final todaysTopics = _activityHistory.putIfAbsent(
      _activityDate,
      () => <String>{},
    );
    final addedToHistory = todaysTopics.add(topicId);
    return addedToday || addedToHistory;
  }

  void _ensureCurrentDay() {
    final now = DateTime.now();
    final today = _dateKey(now);
    if (_activityDate != today) {
      _activityDate = today;
      _completedToday.clear();
      _activityToday.clear();
    }

    final cutoff = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));
    _activityHistory.removeWhere((dateKey, _) {
      final parsed = DateTime.tryParse(dateKey);
      return parsed == null || parsed.isBefore(cutoff);
    });
    _activityHistory.putIfAbsent(today, () => <String>{});
  }

  void _apply(dynamic data) {
    if (data is! Map) return;
    _learned
      ..clear()
      ..addAll((data['learned'] as List? ?? const []).map((e) => '$e'));
    _practised
      ..clear()
      ..addAll((data['practised'] as List? ?? const []).map((e) => '$e'));
    _firstCheckCompleted = data['first_check_completed'] == true;
    _activityDate = '${data['activity_date'] ?? _dateKey(DateTime.now())}';
    _completedToday
      ..clear()
      ..addAll((data['completed_today'] as List? ?? const []).map((e) => '$e'));
    final savedActivity = data['activity_today'];
    _activityToday
      ..clear()
      ..addAll(
        (savedActivity is List
                ? savedActivity
                : (data['completed_today'] as List? ?? const []))
            .map((e) => '$e'),
      );

    _activityHistory.clear();
    final savedHistory = data['activity_history'];
    if (savedHistory is Map) {
      for (final entry in savedHistory.entries) {
        if (entry.value is List) {
          _activityHistory['${entry.key}'] =
              (entry.value as List).map((e) => '$e').toSet();
        }
      }
    } else if (_activityToday.isNotEmpty) {
      // Migrate older progress records into the dated activity history.
      _activityHistory[_activityDate] = Set<String>.from(_activityToday);
    }

    _statusByTopic
      ..clear()
      ..addAll(
        (data['status_by_topic'] as Map? ?? const {}).map(
          (key, value) => MapEntry('$key', '$value'),
        ),
      );
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
          'first_check_completed': _firstCheckCompleted,
          'activity_date': _activityDate,
          'completed_today': _completedToday.toList(),
          'activity_today': _activityToday.toList(),
          'activity_history': {
            for (final entry in _activityHistory.entries)
              entry.key: entry.value.toList(),
          },
          'status_by_topic': _statusByTopic,
          'in_progress': _inProgress.values.map((e) => e.toJson()).toList(),
        }),
      );
    } catch (error) {
      debugPrint('Could not save lesson progress: $error');
    }
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// Neutral status type so the repository does not depend on Map presentation.
enum BrickProgressStatus {
  notSure,
  building,
  solid,
  mastered,
  lockedIn,
}
