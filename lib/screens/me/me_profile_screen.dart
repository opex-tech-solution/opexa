import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/widget.dart';
import '../routes/widget.dart';

class MeProfileScreen extends StatefulWidget {
  const MeProfileScreen({super.key});

  @override
  State<MeProfileScreen> createState() => _MeProfileScreenState();
}

class _MeProfileScreenState extends State<MeProfileScreen> {
  // Toggle states
  bool _lowDataMode = false;
  bool _largerText = false;
  bool _reduceMotion = true;
  bool _slowerVoice = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF241A10)
        : const Color(0xFFF5EEEC);
    final cardColor = isDark ? const Color(0xFF382D24) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Header
              Text(
                "Me",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2C221E),
                ),
              ),
              const SizedBox(height: 16),

              // Profile Card Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: avatarColorFor('Tobi Adeyemi'),
                          child: Text(
                            initialsFor('Tobi Adeyemi'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tobi Adeyemi",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _buildTag("SS1", isDark),
                                  const SizedBox(width: 6),
                                  _buildTag(
                                    "Learns at home",
                                    isDark,
                                    icon: Icons.home_outlined,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Signs in with phone and password",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            GoRouter.of(context).push(
                              '${AppRoutes.mainMe}/${AppRoutes.mainMeEditProfile}',
                            );
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Color(0xFF6B9BFA),
                          ),
                          label: const Text(
                            "Edit profile",
                            style: TextStyle(
                              color: Color(0xFF6B9BFA),
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF6B9BFA)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECTION: About me
              _buildSectionTitle("About me"),
              _buildGroupContainer(
                cardColor: cardColor,
                isDark: isDark,
                children: [
                  _buildNavTile(
                    icon: Icons.person_outline,
                    title: "We call you",
                    subtitle: "Tobi",
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildNavTile(
                    icon: Icons.menu_book_outlined,
                    title: "School system",
                    subtitle: "Nigerian national curriculum",
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildNavTile(
                    icon: Icons.auto_awesome_outlined,
                    title: "Subjects you enjoy",
                    subtitle: "Physics, Mathematics",
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildNavTile(
                    icon: Icons.adjust_outlined,
                    title: "Subjects you find tough",
                    subtitle: "English",
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildNavTile(
                    icon: Icons.grid_view_outlined,
                    title: "Your SS stream",
                    subtitle: "Not placed yet · optional",
                    isDark: isDark,
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION: Privacy
              _buildSectionTitle("Privacy"),
              _buildGroupContainer(
                cardColor: cardColor,
                isDark: isDark,
                children: [
                  _buildNavTile(
                    icon: Icons.visibility_outlined,
                    title: "Who sees your progress",
                    subtitle: "You and Mrs Adeyemi",
                    isDark: isDark,
                    onTap: () {
                      GoRouter.of(context).push(
                        '${AppRoutes.mainMe}/${AppRoutes.mainMeWhoSeesProgress}',
                      );
                    },
                  ),
                  _buildNavTile(
                    icon: Icons.storage_outlined,
                    title: "What OpexA knows about me",
                    subtitle: "Everything we keep, in plain words",
                    isDark: isDark,
                    onTap: () {
                      GoRouter.of(context).push(
                        '${AppRoutes.mainMe}/${AppRoutes.mainMeWhatOpexAKnows}',
                      );
                    },
                  ),
                  _buildNavTile(
                    icon: Icons.shield_outlined,
                    title: "Our promises",
                    subtitle: "How we look after your data",
                    isDark: isDark,
                    onTap: () {
                      GoRouter.of(
                        context,
                      ).push('${AppRoutes.mainMe}/${AppRoutes.mainOurPromise}');
                    },
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION: Account
              _buildSectionTitle("Account"),
              _buildGroupContainer(
                cardColor: cardColor,
                isDark: isDark,
                children: [
                  _buildNavTile(
                    icon: Icons.phone_outlined,
                    title: "Phone number",
                    subtitle: "+234 803 000 0000",
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildNavTile(
                    icon: Icons.lock_outline,
                    title: "Change password",
                    subtitle: "",
                    isDark: isDark,
                    onTap: () {
                      GoRouter.of(context).push(
                        '${AppRoutes.mainMe}/${AppRoutes.mainChangePassword}',
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION: Appearance
              _buildSectionTitle("Appearance"),
              // Phone / Light / Dark: applies instantly and is remembered.
              const AppearanceSelector(),
              const SizedBox(height: 24),

              // SECTION: Settings
              _buildSectionTitle("Settings"),
              _buildGroupContainer(
                cardColor: cardColor,
                isDark: isDark,
                children: [
                  _buildSwitchTile(
                    icon: Icons.wifi_off_outlined,
                    title: "Low-data mode",
                    subtitle: "Off · turn on for slow or costly data",
                    value: _lowDataMode,
                    onChanged: (v) => setState(() => _lowDataMode = v),
                    isDark: isDark,
                  ),
                  _buildNavTile(
                    icon: Icons.notifications_none_outlined,
                    title: "Notifications",
                    subtitle: "Daily at 4:00 pm · quiet hours on",
                    isDark: isDark,
                    onTap: () {
                      GoRouter.of(context).push(
                        '${AppRoutes.mainMe}/${AppRoutes.mainMeNotificationSettings}',
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION: Accessibility
              _buildSectionTitle("Accessibility"),
              _buildGroupContainer(
                cardColor: cardColor,
                isDark: isDark,
                children: [
                  _buildSwitchTile(
                    icon: Icons.text_fields,
                    title: "Larger text",
                    subtitle: "Makes text bigger across OpexA",
                    value: _largerText,
                    onChanged: (v) => setState(() => _largerText = v),
                    isDark: isDark,
                  ),
                  _buildSwitchTile(
                    icon: Icons.accessibility_new,
                    title: "Reduce motion",
                    subtitle:
                        "Fewer animations. Answers and progress still show clearly.",
                    value: _reduceMotion,
                    onChanged: (v) => setState(() => _reduceMotion = v),
                    isDark: isDark,
                  ),
                  _buildSwitchTile(
                    icon: Icons.volume_up_outlined,
                    title: "Slower voice",
                    subtitle: "Listen reads teaching more slowly",
                    value: _slowerVoice,
                    onChanged: (v) => setState(() => _slowerVoice = v),
                    isDark: isDark,
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION: Help
              _buildSectionTitle("Help"),
              _buildGroupContainer(
                cardColor: cardColor,
                isDark: isDark,
                children: [
                  _buildNavTile(
                    icon: Icons.help_outline,
                    title: "Help and questions",
                    subtitle: "Common questions and OpexA support",
                    isDark: isDark,
                    onTap: () {
                      GoRouter.of(context).push(
                        '${AppRoutes.mainMe}/${AppRoutes.mainMeHelpSupport}',
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Log Out Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _logoutConfirmModal(context),
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFF6B9BFA),
                    size: 20,
                  ),
                  label: const Text(
                    "Log out",
                    style: TextStyle(
                      color: Color(0xFF6B9BFA),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8F1FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "OpexA learner app · prototype",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
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
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildGroupContainer({
    required Color cardColor,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(
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
          subtitle: subtitle.isNotEmpty
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                )
              : null,
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
        if (showDivider) Divider(height: 1),
      ],
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
    return Column(
      children: [
        SwitchListTile(
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
        ),
        if (showDivider) Divider(height: 1, indent: 56),
      ],
    );
  }

  Widget _buildTag(String text, bool isDark, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2017) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _logoutConfirmModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Log out?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2C221E),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Your Progress stays saved. Login again with school sign-in code.",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      GoRouter.of(
                        context,
                      ).push(AppRoutes.welcomeScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => GoRouter.of(context).pop,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
