import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cards.dart';
import '../../widgets/info_widgets.dart';

class LearningListPage extends StatelessWidget {
  const LearningListPage({super.key});

  // TODO: replace with real data. The recording only shows "3 topics, next: Two-step equations".
  static const _topics = ['Two-step equations', 'Negative numbers', 'Order of operations'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.bg,
        title: const Text('Your learning list',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => InfoCard(
          border: i == 0 ? C.text : null,
          child: Row(children: [
            Text('${i + 1}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: C.muted)),
            const SizedBox(width: 14),
            Expanded(
                child: Text(_topics[i],
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
            if (i == 0) const SectionLabel('Next'),
          ]),
        ),
      ),
    );
  }
}
