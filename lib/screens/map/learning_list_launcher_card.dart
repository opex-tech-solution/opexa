import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../api/repositories/widget.dart';
import '../routes/widget.dart';

class LearningListLauncherCard extends StatefulWidget {
  const LearningListLauncherCard({super.key});

  @override
  State<LearningListLauncherCard> createState() =>
      _LearningListLauncherCardState();
}

class _LearningListLauncherCardState extends State<LearningListLauncherCard> {
  String _summaryText = "Loading learning list...";

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final data = await LearningListRepository.fetch();
    if (!mounted) return;
    setState(() {
      _summaryText = data.summary;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () =>
          context.push('${AppRoutes.mainMap}/${AppRoutes.mainMapLearningList}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.format_list_numbered_outlined,
                color: Theme.of(context).canvasColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your learning list",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _summaryText,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
