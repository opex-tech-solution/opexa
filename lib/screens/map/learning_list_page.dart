import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../api/repositories/widget.dart';
import '../../models/model.dart';

class LearningListPage extends StatefulWidget {
  const LearningListPage({super.key});

  @override
  State<LearningListPage> createState() => _LearningListPageState();
}

class _LearningListPageState extends State<LearningListPage> {
  late Future<List<LearningTopic>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = LearningRepository.fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: isDark ? Colors.white70 : Colors.black87),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Your learning list",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // FutureBuilder Loading JSON Data
            Expanded(
              child: FutureBuilder<List<LearningTopic>>(
                future: _topicsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading topics: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No learning topics found."));
                  }

                  final topics = snapshot.data!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Topics to learn. Select any block to view its status and lessons.",
                          style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        Material(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: topics.asMap().entries.map((entry) {
                              final index = entry.key;
                              final topic = entry.value;
                              final showDivider = index < topics.length - 1;

                              return _buildTopicTile(context, topic, isDark, showDivider);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicTile(BuildContext context, LearningTopic topic, bool isDark, bool showDivider) {
    Color badgeColor;
    String badgeText = "";

    if (topic.status == "solid") {
      badgeColor = const Color(0xFF6B9BFA);
    } else if (topic.status == "building") {
      badgeColor = const Color(0xFF6B9BFA);
    } else {
      badgeColor = Colors.grey.shade300;
      badgeText = "?";
    }

    return Column(
      children: [
        ListTile(
          onTap: () {
            // Navigate using GoRouter passing the topic title
            context.push('/block-detail/${Uri.encodeComponent(topic.title)}');
          },
          leading: Container(
            width: 32,
            height: 24,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                badgeText,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),
          title: Text(
            topic.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            topic.category,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ),
        if (showDivider) const Divider(height: 1, indent: 56, color: Colors.white12),
      ],
    );
  }
}
