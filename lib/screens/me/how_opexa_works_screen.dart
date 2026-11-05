import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/widget.dart';
import '../routes/widget.dart';

class HowOpexAWorksScreen extends StatelessWidget {
  const HowOpexAWorksScreen({super.key});

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
                    "How OpexA works",
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
                    // Intro Paragraph
                    Text(
                      "OpexA works out what you really do, explains why you’re stuck, picks the next step, and checks that it worked. Then it goes round again.",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Step Timeline Items
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 1",
                      title: "Understand",
                      description:
                          "We start with you: your class, your school system, and the subjects you enjoy or find tough.",
                      icon: Icons.person_outline,
                      actionText: "About you",
                      onActionTap: () {
                        GoRouter.of(context).push(
                          '${AppRoutes.mainMe}/${AppRoutes.mainMeHelpSupport}/${AppRoutes.mainHowOpexAWorks}/${AppRoutes.mainMeWhatOpexAKnows}',
                        );
                      },
                      isFirst: true,
                      isDark: isDark,
                    ),
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 2",
                      title: "Diagnose",
                      description:
                          "Your first check. When something goes wrong, we ask one more question to find out why, instead of guessing.",
                      icon: Icons.search,
                      subtext: "First check",
                      isDark: isDark,
                    ),
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 3",
                      title: "Map",
                      description:
                          "Your blocks show what you can do, what’s still building, and what we’re not sure about yet.",
                      icon: Icons.map_outlined,
                      actionText: "Map",
                      onActionTap: () {},
                      isDark: isDark,
                    ),
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 4",
                      title: "Personalise",
                      description:
                          "Today gives you three tracks: Foundation fixes the block that unlocks the most, Class keeps up with this week’s topic, and Stretch takes you further.",
                      icon: Icons.track_changes_outlined,
                      actionText: "Today",
                      onActionTap: () {},
                      isDark: isDark,
                    ),
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 5",
                      title: "Teach",
                      description:
                          "Teach me explains each topic with everyday examples, worked steps and a common mistake. Tap Listen to hear it.",
                      icon: Icons.menu_book_outlined,
                      subtext: "Teach me",
                      isDark: isDark,
                    ),
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 6",
                      title: "Practise",
                      description:
                          "Lessons let you have a go, with hints, before a short check on your own.",
                      icon: Icons.edit_outlined,
                      subtext: "Lessons",
                      isDark: isDark,
                    ),
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 7",
                      title: "Measure",
                      description:
                          "A block only moves up when you answer fresh questions on your own: Solid, then Mastered, then Locked in a week later.",
                      icon: Icons.show_chart,
                      actionText: "Results and your map",
                      onActionTap: () {},
                      isDark: isDark,
                    ),
                    _buildTimelineStep(
                      context: context,
                      stepNumber: "STEP 8",
                      title: "Adapt",
                      description:
                          "OpexA remembers what helps you, like starting with an example, and tries another way when something doesn’t click.",
                      icon: Icons.auto_awesome_outlined,
                      actionText: "What helps you learn",
                      onActionTap: () {},
                      isLast: true,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),

                    // Bottom Loop Restart Notice Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: context.colors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "After Adapt, the loop starts again at Diagnose: every lesson and quick check adds evidence, so your map keeps up with you.",
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildTimelineStep({
    required BuildContext context,
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    String? actionText,
    VoidCallback? onActionTap,
    String? subtext,
    bool isFirst = false,
    bool isLast = false,
    required bool isDark,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator & connecting line column
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.colors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, color: context.colors.accent, size: 20),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Step Details Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepNumber,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? Colors.white70 : Colors.black54,
                      height: 1.35,
                    ),
                  ),
                  if (subtext != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtext,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                  if (actionText != null && onActionTap != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onActionTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            actionText,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: context.colors.accent,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: context.colors.accent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
