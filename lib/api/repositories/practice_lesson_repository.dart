import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../models/model.dart';

/// Loads a topic's optional guided-practice lesson from the shared OpexA
/// Mathematics JSON catalog. It reads the JSON directly so the existing
/// LessonContentCatalog model does not need to change.
class PracticeLessonRepository {
  PracticeLessonRepository({
    this.assetPath = 'assets/json/opexa_math_content.json',
  });

  final String assetPath;
  Future<Map<String, dynamic>>? _catalogFuture;

  Future<Map<String, dynamic>> _loadCatalog() async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException(
        'The content catalog root must be a JSON object.',
      );
    }
    return Map<String, dynamic>.from(decoded);
  }

  Future<Map<String, dynamic>> _catalog() async {
    try {
      return await (_catalogFuture ??= _loadCatalog());
    } catch (_) {
      _catalogFuture = null;
      rethrow;
    }
  }

  Future<PracticeLessonContent?> getPracticeLesson(String topicId) async {
    final catalog = await _catalog();
    final topics = catalog['topics'];
    if (topics is! List) {
      throw const FormatException(
        'The content catalog does not contain a topics list.',
      );
    }

    for (final item in topics) {
      if (item is! Map) continue;
      final topic = Map<String, dynamic>.from(item);
      if (topic['id'] != topicId) continue;

      final lesson = topic['practice_lesson'];
      if (lesson == null) return null;
      if (lesson is! Map) {
        throw FormatException(
          'The practice_lesson for "$topicId" must be an object.',
        );
      }
      return PracticeLessonContent.fromTopicJson(
        topicId: topicId,
        topicName: _requiredString(topic, 'name', topicId),
        topicLevel: _requiredString(topic, 'level', topicId),
        topicSummary: _requiredString(topic, 'summary', topicId),
        json: Map<String, dynamic>.from(lesson),
      );
    }
    return null;
  }

  String _requiredString(Map<String, dynamic> topic, String field, String id) {
    final value = topic[field];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Topic "$id" must have a non-empty "$field".');
    }
    return value;
  }
}
