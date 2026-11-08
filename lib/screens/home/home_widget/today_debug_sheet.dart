import 'package:flutter/material.dart';
import 'today_samples.dart';
import 'today_store.dart';

/// Debug builds only: long-press the "Today" title to open this and switch the
/// screen between the design board's states.
Future<void> showTodayStatePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Preview a Today state (debug only)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
          for (final sample in TodaySamples.all)
            ListTile(
              title: Text(sample.label),
              trailing: identical(TodayStore.instance.value, sample.state)
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                TodayStore.instance.show(sample.state);
                Navigator.of(sheetContext).pop();
              },
            ),
        ],
      ),
    ),
  );
}
