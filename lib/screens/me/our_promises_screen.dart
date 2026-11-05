import 'package:flutter/material.dart';

class OurPromisesScreen extends StatelessWidget {
  const OurPromisesScreen({super.key});

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
                    "Our promises",
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
                    Text(
                      "How OpexA looks after your data, in plain words.",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Promises Container Card
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildPromiseTile(
                            icon: Icons.storage_outlined,
                            title: "We keep as little as we can",
                            description:
                                "Only what OpexA needs to help you learn: your name, class, answers and progress.",
                            isDark: isDark,
                          ),
                          _buildPromiseTile(
                            icon: Icons.lock_outline,
                            title: "Never sold, never used for ads",
                            description:
                                "Your answers and progress are not sold to anyone or used for advertising.",
                            isDark: isDark,
                          ),
                          _buildPromiseTile(
                            icon: Icons.auto_awesome_outlined,
                            title: "Not used to train general AI",
                            description:
                                "Your answers, with your name on them, are never used to train general AI models.",
                            isDark: isDark,
                          ),
                          _buildPromiseTile(
                            icon: Icons.visibility_outlined,
                            title: "You can see what we keep",
                            description:
                                "Everything OpexA knows about you is in Me, under \"What OpexA knows\".",
                            isDark: isDark,
                          ),
                          _buildPromiseTile(
                            icon: Icons.group_outlined,
                            title: "Other learners never see your work",
                            description:
                                "Your answers and blocks are private to you and the people in \"Who sees my progress\".",
                            isDark: isDark,
                          ),
                          _buildPromiseTile(
                            icon: Icons.delete_outline,
                            title: "You can ask us to delete it",
                            description:
                                "You can delete your account and data yourself, in Me.",
                            isDark: isDark,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Bottom Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to What OpexA knows screen
                        },
                        icon: const Icon(
                          Icons.storage_outlined,
                          size: 18,
                          color: Color(0xFF1B4988),
                        ),
                        label: const Text(
                          "See what OpexA knows",
                          style: TextStyle(
                            color: Color(0xFF1B4988),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8F1FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _buildPromiseTile({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isDark ? Colors.white70 : Colors.black54,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Colors.white12),
      ],
    );
  }
}
