import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/model.dart';
import '../../theme/widget.dart';
import '../routes/widget.dart';
import 'home_widget/home_widget.dart';

/// Opened from the bell on Today: the list of notifications, or the empty
/// state ("Nothing new").
///
/// Opening it clears the bell badge. Items that were new when it opened keep
/// their "New" tag until the screen is closed.
class NotificationsScreen extends StatefulWidget {
  /// Pass [notifications] to show a fixed list (tests, screenshots).
  const NotificationsScreen({super.key, this.notifications});

  final List<AppNotification>? notifications;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<AppNotification> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.notifications ?? TodayStore.instance.value.notifications;
    if (widget.notifications == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => TodayStore.instance.markNotificationsRead(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: c.textPrimary),
          child: IconTheme.merge(
            data: IconThemeData(color: c.textPrimary),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.divider)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Back',
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (_items.isEmpty)
                          const _EmptyCard()
                        else
                          for (final item in _items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _NotificationCard(item: item),
                            ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () => context.push(
                              '${AppRoutes.mainHome}/'
                              '${AppRoutes.mainHomeNotifications}/'
                              '${AppRoutes.mainHomeNotificationSettings}',
                            ),
                            icon: const Icon(Icons.settings_outlined, size: 18),
                            label: const Text('Notification settings'),
                            style: FilledButton.styleFrom(
                              backgroundColor: c.accentContainer,
                              foregroundColor: c.onAccentContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.visibility_outlined, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.body,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.isNew ? '${item.whenLabel} · New' : item.whenLabel,
                  style: TextStyle(fontSize: 12, color: c.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.divider),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/Illustration.png'),
          const SizedBox(height: 16),
          const Text(
            'Nothing new',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Quick checks that are due, messages from your teacher and replies '
            'from OpexA show up here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
