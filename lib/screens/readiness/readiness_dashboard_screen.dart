import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/widget.dart';

class ReadinessDashboardScreen extends StatelessWidget {
  const ReadinessDashboardScreen({super.key});

  void _showHowStreamsWorkModal(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
                  "How SS streams work",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2C221E),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Every SS learner takes the core subjects, then follows Business, Humanities or Science. Each stream builds on different Maths blocks.",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "You, your family and your school decide your stream. Readiness just shows which blocks you’ve built for each one.",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Maths only for now. Each stream also has a trade subject.",
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
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).shadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Readiness",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "LOOKING AHEAD TO SS1",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Each SS stream builds on different Maths blocks. This shows what you’re building, not what to choose.",
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showHowStreamsWorkModal(context),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Theme.of(context).shadowColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "How SS streams work",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CORE MATHS CARD
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
                      "CORE MATHS · EVERY STREAM",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "General Mathematics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        children: const [
                          TextSpan(
                            text: "4 ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(text: "of 8 "),
                          TextSpan(
                            text: "blocks in place",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 4 / 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6B9BFA),
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _blockBadge("?", false),
                        _blockBadge("", true),
                        _blockBadge("", true),
                        _blockBadge("?", false),
                        _blockBadge("", true),
                        _blockBadge("", true),
                        _blockBadge("", true),
                        _blockBadge("?", false),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(height: 1, color: Colors.white12),
                    ),
                    const Text(
                      "NEXT TO BUILD",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _nextBuildChip("Add & subtract integers", true),
                        _nextBuildChip("Whole numbers", false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "The three streams",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // STREAM 1: Business
              _streamCard(
                context,
                icon: Icons.work_outline,
                title: "Business",
                subtitle: "Financial Accounting · Economics · Commerce",
                completedCount: 4,
                totalCount: 12,
                isDark: isDark,
                cardColor: Theme.of(context).cardColor,
              ),
              const SizedBox(height: 16),

              // STREAM 2: Humanities
              _streamCard(
                context,
                icon: Icons.account_balance_outlined,
                title: "Humanities",
                subtitle: "Geography · Economics",
                completedCount: 4,
                totalCount: 10,
                isDark: isDark,
                cardColor: Theme.of(context).cardColor,
              ),
              const SizedBox(height: 16),

              // STREAM 3: Science
              _streamCard(
                context,
                icon: Icons.science_outlined,
                title: "Science",
                subtitle: "Physics · Chemistry · Further Mathematics",
                completedCount: 4,
                totalCount: 14,
                isDark: isDark,
                cardColor: Theme.of(context).cardColor,
                onTap: () {
                  GoRouter.of(context).push(
                    '${AppRoutes.mainReadiness}/${AppRoutes.mainReadinessScience}',
                  );
                },
              ),
              const SizedBox(height: 24),

              const Text(
                "Your teacher and school see the same evidence. Blocks count as in place once they are Solid or stronger.",
                style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blockBadge(String label, bool isSolid) {
    return Container(
      width: 28,
      height: 24,
      decoration: BoxDecoration(
        color: isSolid ? const Color(0xFF6B9BFA) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSolid ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _nextBuildChip(String label, bool isBlue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isBlue ? const Color(0xFF6B9BFA) : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int completedCount,
    required int totalCount,
    required bool isDark,
    required Color cardColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF1B4988), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
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
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: "$completedCount ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(text: "of $totalCount "),
                  const TextSpan(
                    text: "blocks in place",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completedCount / totalCount,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF6B9BFA),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "NEXT TO BUILD",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _nextBuildChip("Add & subtract integers", true),
                _nextBuildChip("Whole numbers", false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
