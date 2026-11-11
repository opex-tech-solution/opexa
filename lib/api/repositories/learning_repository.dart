import 'dart:convert';
import 'package:flutter/services.dart';

import '../../models/model.dart';

class LearningRepository {
  // Loads the robust JSON file from assets
  static Future fetchLearningData() async {
    final jsonString = await rootBundle.loadString('assets/json/learning_topics.json');
    return json.decode(jsonString);
  }

  // Returns a list of all parsed learning topics
  static Future<List<LearningTopic>> fetchTopics() async {
    final data = await fetchLearningData();
    final List list = data['topics'];
    return list.map((item) => LearningTopic.fromJson(item)).toList();
  }

  // Generates the summary text for launcher cards
  static Future<String> fetchNextTopicSummary() async {
    final data = await fetchLearningData();
    int total = data['total_topics'];
    
    List topics = data['topics'];
    var nextTopic = topics.firstWhere(
      (t) => t['status'] == 'building' || t['status'] == 'unchecked',
      orElse: () => topics.first,
    );
    
    String title = nextTopic['title'];
    return "$total topics to learn. Next: $title";
  }
}
