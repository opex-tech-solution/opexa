import 'package:flutter/material.dart';

class TopicScreen extends StatelessWidget {
  final String topic;
  const TopicScreen({super.key, required this.topic});

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
                  Expanded(
                    child: Text(
                      topic,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                    // Topic Header Card
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$topic with negative numbers",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Not Checked Yet Status Banner Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "NOT CHECKED YET",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "We haven't seen enough yet. We'll check this as you go.",
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isDark ? Colors.white70 : Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Progress Timeline Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WHERE THIS BLOCK IS",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 430,
                              child: Row(
                                children: [
                                  _timelineStep("Checked", true),
                                  _timelineConnector(false),
                                  _timelineStep("Taught", false),
                                  _timelineConnector(false),
                                  _timelineStep("Practised", false),
                                  _timelineConnector(false),
                                  _timelineStep("Solid", false),
                                  _timelineConnector(false),
                                  _timelineStep("Mastered", false),
                                  _timelineConnector(false),
                                  _timelineStep("Locked in", false),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(
                                Icons.radio_button_checked,
                                size: 16,
                                color: Color(0xFF1B4988),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Next: your plan checks this block as you go.",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: Theme.of(context).shadowColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Next lesson starts: try it first.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Action CTA
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu_book_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Teach me this topic",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF24488A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // What Shows This Section
                    const Text(
                      "What shows this",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "Nothing yet. We'll check this as you go.",
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Needs Section
                    const Text(
                      "Needs",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 130,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B4988),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Add & subtract integers",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Unlocks Section
                    const Text(
                      "Unlocks",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _unlockCard(
                            "Expanding brackets",
                            false,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _unlockCard("Substituting", false, isDark),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _unlockCard(
                            "Two-step equations",
                            true,
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // In SS This Supports Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "IN SS THIS SUPPORTS",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Physics, Chemistry, Further Mathematics, Financial Accounting, Economics and Geography",
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isDark ? Colors.white70 : Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Footer Subtitle
                    const Text(
                      "Usually met in JSS1 · Foundations",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _timelineStep(String label, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFF1B4988) : Colors.grey.shade300,
          ),
          child: isSelected
              ? const Center(
                  child: Icon(Icons.check, size: 10, color: Colors.white),
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isSelected ? const Color(0xFF1B4988) : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _timelineConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF1B4988) : Colors.grey.shade300,
      ),
    );
  }

  Widget _unlockCard(String title, bool isSolid, bool isDark) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF382D24) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 24,
            decoration: BoxDecoration(
              color: isSolid ? const Color(0xFF6B9BFA) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                isSolid ? "" : "?",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSolid ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
