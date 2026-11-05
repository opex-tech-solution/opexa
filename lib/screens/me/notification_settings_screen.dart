import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Toggle states
  bool _dailyReminder = true;
  bool _quickCheckReminders = true;
  bool _guardianMessages = true;
  bool _quietHours = true;
  bool _schoolHours = false;

  // Selected times
  String _reminderTime = "4:00 pm";
  String _quietFromTime = "9:00 pm";
  String _quietToTime = "6:00 am";

  // Full list of times for dropdown selection
  final List<String> _timeOptions = [
    "12:00 am",
    "1:00 am",
    "2:00 am",
    "3:00 am",
    "4:00 am",
    "5:00 am",
    "6:00 am",
    "7:00 am",
    "8:00 am",
    "9:00 am",
    "10:00 am",
    "11:00 am",
    "12:00 pm",
    "1:00 pm",
    "2:00 pm",
    "3:00 pm",
    "4:00 pm",
    "5:00 pm",
    "6:00 pm",
    "7:00 pm",
    "8:00 pm",
    "9:00 pm",
    "10:00 pm",
    "11:00 pm",
  ];

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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Notification settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION: Reminders
                    _buildSectionTitle("Reminders"),
                    Material(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            icon: Icons.access_time_outlined,
                            title: "Daily reminder",
                            subtitle: "Every day at $_reminderTime",
                            value: _dailyReminder,
                            onChanged: (v) =>
                                setState(() => _dailyReminder = v),
                            isDark: isDark,
                          ),
                          if (_dailyReminder) ...[
                            const Divider(
                              height: 1,
                              indent: 56,
                              color: Colors.white12,
                            ),
                            _buildDropdownTile(
                              title: "Remind me at",
                              selectedValue: _reminderTime,
                              items: _timeOptions,
                              onChanged: (val) {
                                if (val != null)
                                  setState(() => _reminderTime = val);
                              },
                              isDark: isDark,
                            ),
                          ],
                          const Divider(
                            height: 1,
                            indent: 56,
                            color: Colors.white12,
                          ),
                          _buildSwitchTile(
                            icon: Icons.lock_outline,
                            title: "Quick-check reminders",
                            subtitle:
                                "When a Mastered block is ready to lock in",
                            value: _quickCheckReminders,
                            onChanged: (v) =>
                                setState(() => _quickCheckReminders = v),
                            isDark: isDark,
                          ),
                          const Divider(
                            height: 1,
                            indent: 56,
                            color: Colors.white12,
                          ),
                          _buildSwitchTile(
                            icon: Icons.chat_bubble_outline,
                            title: "Messages from your Guardian",
                            subtitle: "From Mrs Adeyemi",
                            value: _guardianMessages,
                            onChanged: (v) =>
                                setState(() => _guardianMessages = v),
                            isDark: isDark,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Quiet times
                    _buildSectionTitle("Quiet times"),
                    Material(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            icon: Icons.nightlight_outlined,
                            title: "Quiet hours",
                            subtitle:
                                "No reminders $_quietFromTime to $_quietToTime",
                            value: _quietHours,
                            onChanged: (v) => setState(() => _quietHours = v),
                            isDark: isDark,
                          ),
                          if (_quietHours) ...[
                            const Divider(
                              height: 1,
                              indent: 16,
                              color: Colors.white12,
                            ),
                            _buildDropdownTile(
                              title: "From",
                              selectedValue: _quietFromTime,
                              items: _timeOptions,
                              onChanged: (val) {
                                if (val != null)
                                  setState(() => _quietFromTime = val);
                              },
                              isDark: isDark,
                            ),
                            const Divider(
                              height: 1,
                              indent: 16,
                              color: Colors.white12,
                            ),
                            _buildDropdownTile(
                              title: "To",
                              selectedValue: _quietToTime,
                              items: _timeOptions,
                              onChanged: (val) {
                                if (val != null)
                                  setState(() => _quietToTime = val);
                              },
                              isDark: isDark,
                            ),
                          ],
                          const Divider(
                            height: 1,
                            indent: 56,
                            color: Colors.white12,
                          ),
                          _buildSwitchTile(
                            icon: Icons.account_balance_outlined,
                            title: "School hours",
                            subtitle:
                                "No reminders 8 am to 2 pm, Monday to Friday",
                            value: _schoolHours,
                            onChanged: (v) => setState(() => _schoolHours = v),
                            isDark: isDark,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer Helper Notice
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "In this prototype, reminders show inside OpexA only, under the bell on Today. Phone notifications come with the full app.",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.black54,
                          height: 1.4,
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    bool showDivider = true,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: const Color(0xFF1B4988),
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey.shade600,
      secondary: Icon(
        icon,
        color: isDark ? Colors.white70 : Colors.black54,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                icon: const Icon(Icons.chevron_right, size: 18),
                dropdownColor: isDark ? const Color(0xFF382D24) : Colors.white,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: items.map((String time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
