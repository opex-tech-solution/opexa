import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/widget.dart';

class BlockDetailDeepScreen extends StatelessWidget {
  const BlockDetailDeepScreen({super.key});

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
                      "Add & subtract integers",
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
                            color: const Color(0xFF6B9BFA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Adding and subtracting integers",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Adding and taking away when negative numbers are involved",
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

                    // Building Status Banner Card
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
                            "BUILDING",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "This is the block to build. You're working on it.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () => context.push(
                                '${AppRoutes.mainMap}/${AppRoutes.mainMapBlockDetails}/${AppRoutes.mainMapWhyThisBlock}',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8F1FF),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Why this block?",
                                style: TextStyle(
                                  color: Color(0xFF1B4988),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "Next: Teach me, then a lesson.",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: Color(0xFF6B9BFA),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Next lesson starts: try it first.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _evidenceTile(
                            "2x + 9 = 3: you answered x = 3 (fairly sure).",
                            "From your first check",
                            isDark,
                          ),
                          _evidenceTile(
                            "What is 3 − 9? You answered 6 (fairly sure).",
                            "From your first check",
                            isDark,
                          ),
                          _evidenceTile(
                            "−3 − 5: you answered −2 (fairly sure).",
                            "From your first check",
                            isDark,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "› Show all 6",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B9BFA),
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B9BFA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Negative numbers",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
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
                            context,
                            "Multiply & divide integers",
                            false,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _unlockCard(
                            context,
                            "Simplifying",
                            false,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _unlockCard(
                            context,
                            "One-step equations",
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
                            "General Mathematics, Physics, Chemistry, Financial Accounting and Geography",
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

  Widget _evidenceTile(
    String title,
    String subtitle,
    bool isDark, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.edit_note, size: 20, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 46, color: Colors.white12),
      ],
    );
  }

  Widget _unlockCard(
    BuildContext context,
    String title,
    bool isSolid,
    bool isDark,
  ) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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

  //Color cardColorOf(bool isDark) => isDark ? const Color(0xFF382D24) : Colors.white;
}
