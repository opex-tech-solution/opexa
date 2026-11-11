import 'dart:convert';

import 'package:flutter/services.dart';
import '../../models/model.dart';

/// Loads the grouped learning list from assets/json/learning_list.json.
class LearningListRepository {
  LearningListRepository._();

  static const String _asset = 'assets/json/learning_list.json';
  static LearningListData? _cache;

  static Future<LearningListData> fetch() async {
    final cached = _cache;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString(_asset);
    final data = LearningListData.fromJson(
      Map<String, dynamic>.from(jsonDecode(raw) as Map),
    );
    return _cache = data;
  }

  /// Finds the content ID for a lesson title such as "Two-step equations".
  static String? contentIdForName(String name) {
    final wanted = name.trim().toLowerCase();
    for (final skill in buildWall().all) {
      if (skill.name.toLowerCase() == wanted) return skill.contentId;
    }
    return null;
  }
}
