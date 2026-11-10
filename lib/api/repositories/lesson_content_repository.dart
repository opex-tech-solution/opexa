import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/model.dart';

/// Loads Teach Me content from a bundled JSON asset.
///
/// The repository is intentionally the only layer that knows where content
/// comes from. It can later be replaced or extended with an HTTP/API source
/// without changing the teaching or practice widgets.
class LessonContentRepository {
  LessonContentRepository({
    this.assetPath = 'assets/json/opexa_math_content.json',
  });

  final String assetPath;
  Future<LessonContentCatalog>? _catalogFuture;

  Future<LessonContentCatalog> loadCatalog() async {
    try {
      return await (_catalogFuture ??= _loadCatalog());
    } catch (_) {
      // Allow a retry after an asset/read/JSON error.
      _catalogFuture = null;
      rethrow;
    }
  }

  Future<LessonContentCatalog> _loadCatalog() async {
    final rawJson = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(rawJson);

    if (decoded is! Map) {
      throw const FormatException(
        'The OpexA content file must contain a JSON object at its root.',
      );
    }

    return LessonContentCatalog.fromJson(Map<String, dynamic>.from(decoded));
  }

  Future<TopicContent?> getTopicById(String topicId) async {
    final catalog = await loadCatalog();
    return catalog.topicById(topicId);
  }

  /// Resolves current Map labels to stable JSON topic IDs.
  ///
  /// Prefer supplying [topicId] directly from the Map model when possible.
  /// The aliases below keep the existing Skill(name, state) calls working
  /// while the Map is migrated to stable IDs.
  Future<TopicContent?> getTopicForSkill({
    required String skillName,
    String? topicId,
  }) async {
    final catalog = await loadCatalog();
    final resolvedId = topicId?.trim().isNotEmpty == true
        ? topicId!.trim()
        : topicIdForSkillName(skillName);

    if (resolvedId != null) return catalog.topicById(resolvedId);

    final normalizedName = _normalize(skillName);
    for (final topic in catalog.topics) {
      if (_normalize(topic.name) == normalizedName) return topic;
    }
    return null;
  }

  static String? topicIdForSkillName(String skillName) {
    final normalized = _normalize(skillName);

    const aliases = <String, String>{
      'substitution': 'substitution',
      'substituting': 'substitution',
      'simultaneous equations': 'simultaneous_equations',
      'quadratic equation': 'quadratic_equations',
      'quadratic equations': 'quadratic_equations',
      'addition and subtraction of integers': 'addition_subtraction_integers',
      'add and subtract integers': 'addition_subtraction_integers',
      'addition subtraction integers': 'addition_subtraction_integers',
      'expanding brackets': 'expanding_brackets',
      'expanding bracket': 'expanding_brackets',
      'multiplying and dividing integers': 'multiplying_dividing_integers',
      'multiply and divide integers': 'multiplying_dividing_integers',
      'multiply divide integers': 'multiplying_dividing_integers',
      'inequality': 'inequalities',
      'inequalities': 'inequalities',
      'harder equations': 'harder_equations',
      'word problem': 'word_problems',
      'word problems': 'word_problems',
      'two step equation': 'two_step_equations',
      'two step equations': 'two_step_equations',
      'simplifying': 'simplifying_expressions',
      'simplifying expressions': 'simplifying_expressions',
      'one step equation': 'one_step_equations',
      'one step equations': 'one_step_equations',
      'negative number': 'negative_numbers',
      'negative numbers': 'negative_numbers',
      'order of operations': 'order_of_operations',
      'letters for numbers': 'letters_for_numbers',
      'whole number': 'whole_numbers',
      'whole numbers': 'whole_numbers',
    };

    return aliases[normalized];
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', ' and ')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
