import 'package:flutter/material.dart';

import '../../../theme/widget.dart';

/// Shown above the header when the phone has no connection.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.panel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Offline. Everything you do is saved on this phone.',
              style: TextStyle(fontSize: 14, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
