import 'package:flutter/material.dart';

class ScienceStreamScreen extends StatelessWidget {
  const ScienceStreamScreen({super.key});

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
                    "Science",
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
                    // Stream Description Header
                    Text(
                      "Science",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "SS subjects that use these Maths blocks:\nPhysics, Chemistry and Further Mathematics.",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "4 of 14 blocks in place",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Next to build
                    const Text(
                      "Next to build",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Next to Build Card 1 (In Progress / Partial)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B9BFA),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Add & subtract integers",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Securing add & subtract integers supports SS Physics and Chemistry.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Unlocks multiply & divide integers, simplifying and one-step equations",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8F1FF),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Make this my next Foundation lesson",
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
                    const SizedBox(height: 12),

                    // Next to Build Card 2 (Unchecked)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    "?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Whole numbers",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Securing whole numbers supports General Mathematics.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Unlocks negative numbers, order of operations and letters for numbers",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8F1FF),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Make this my next Foundation lesson",
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
                    const SizedBox(height: 24),

                    // SECTION: Core Maths
                    const Text(
                      "Core Maths",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _mathBlockTile(
                            "Whole numbers",
                            "General Mathematics",
                            false,
                          ),
                          _mathBlockTile(
                            "Negative numbers",
                            "General Mathematics · Physics",
                            true,
                          ),
                          _mathBlockTile(
                            "Add & subtract integers",
                            "General Mathematics · Physics · Chemistry",
                            true,
                          ),
                          _mathBlockTile(
                            "Order of operations",
                            "General Mathematics · Physics",
                            false,
                          ),
                          _mathBlockTile(
                            "Letters for numbers",
                            "General Mathematics · Physics · Chemistry",
                            true,
                          ),
                          _mathBlockTile(
                            "One-step equations",
                            "General Mathematics · Physics · Chemistry",
                            true,
                          ),
                          _mathBlockTile(
                            "Two-step equations",
                            "General Mathematics · Physics · Chemistry",
                            true,
                          ),
                          _mathBlockTile(
                            "Word problems",
                            "General Mathematics · Physics",
                            false,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Extra for Science
                    const Text(
                      "Extra for Science",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _mathBlockTile(
                            "Multiply & divide integers",
                            "Physics · Chemistry · Further Mathematics",
                            false,
                          ),
                          _mathBlockTile(
                            "Simplifying",
                            "Physics · Chemistry · Further Mathematics",
                            false,
                          ),
                          _mathBlockTile(
                            "Expanding brackets",
                            "Further Mathematics · Physics",
                            false,
                          ),
                          _mathBlockTile(
                            "Substituting",
                            "Physics · Chemistry",
                            false,
                          ),
                          _mathBlockTile(
                            "Harder equations",
                            "Further Mathematics · Physics",
                            false,
                          ),
                          _mathBlockTile(
                            "Simultaneous equations",
                            "Further Mathematics · Physics",
                            false,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer Notice
                    Text(
                      "This shows what you’re building, not which stream to choose.",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? Colors.white60 : Colors.black54,
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

  Widget _mathBlockTile(
    String title,
    String subtitle,
    bool isSolid, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
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
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 20,
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 56, color: Colors.white12),
      ],
    );
  }
}
