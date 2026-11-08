import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../theme/widget.dart';

/// "Today" and the bell. The bell shows a small badge with the unread count.
class TodayHeader extends StatelessWidget {
  const TodayHeader({
    super.key,
    required this.unreadCount,
    required this.onBellTap,
    this.onTitleLongPress,
  });

  final int unreadCount;
  final VoidCallback onBellTap;

  /// Debug builds use this to open the state picker.
  final VoidCallback? onTitleLongPress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 6, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: onTitleLongPress,
              child: const Text(
                'Today',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: unreadCount > 0
                    ? 'Notifications, $unreadCount new'
                    : 'Notifications',
                onPressed: onBellTap,
                icon: const Icon(Iconsax.notification, size: 26),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 17,
                    height: 17,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.panelBorder,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
