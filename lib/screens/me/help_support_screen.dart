import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/widget.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
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
                    "Help",
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
                    // SECTION: How OpexA works
                    _buildSectionTitle("How OpexA works"),
                    GestureDetector(
                      onTap: () {
                        // Navigate to "How OpexA works" screen
                        GoRouter.of(context).push(
                          '${AppRoutes.mainMe}/${AppRoutes.mainMeHelpSupport}/${AppRoutes.mainHowOpexAWorks}',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.route_outlined,
                              color: isDark
                                  ? Colors.white70
                                  : Theme.of(context).cardColor,
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your learning loop",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Eight steps, from your first check to a block that's locked in",
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark
                                          ? Colors.white60
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Common questions
                    _buildSectionTitle("Common questions"),
                    FaqTile(
                      question: "What is the first check?",
                      answer:
                          'A short Maths check that finds which blocks you can already do and which one is holding you back. There are no grades and no rankings',
                    ),
                    const SizedBox(height: 10),
                    FaqTile(
                      question: "What do the block colours mean?",
                      answer:
                          'Grey with a question mark: not checked yet. Half filled: building. Blue: Solid, you can do it on your own. Dark blue with a star: Mastered. Amber with a lock: Locked in, still there after a week. Peach with dots: not sure yet.',
                    ),
                    const SizedBox(height: 10),
                    FaqTile(
                      question: "Why does OpexA say “Not sure yet”?",
                      answer:
                          'Your answers pointed different ways, so OpexA asks a few more questions before deciding. It’s about being fair to you.',
                    ),
                    const SizedBox(height: 10),
                    FaqTile(
                      question: "Does OpexA work offline?",
                      answer:
                          'Yes. Checks and lessons work offline and are saved on this phone. Logging in, creating an account, changing your password and inviting a Guardian need the internet',
                    ),
                    const SizedBox(height: 10),
                    FaqTile(
                      question: "How do I use less data?",
                      answer:
                          'Turn on Low-data mode in Me. Animations wait for a tap, pictures are hidden and lessons show their size.',
                    ),
                    const SizedBox(height: 10),
                    FaqTile(
                      question: "I forgot my password",
                      answer:
                          "On the log-in screen, tap “Forgot password?”. We’ll text you a code so you can set a new one.",
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Get help (Support Card)
                    _buildSectionTitle("Get help"),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.sports_soccer_outlined,
                                color: Color(0xFF2D58A2),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "OpexA support",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Tell us what's wrong and we'll reply here, under the bell on Today. We usually reply within a day.",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black54,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  showOpexASupportBottomSheet(context),
                              icon: const Icon(
                                Icons.chat_bubble_outline_outlined,
                                size: 16,
                                color: Color(0xFF2D58A2),
                              ),
                              label: const Text(
                                "Message OpexA support",
                                style: TextStyle(
                                  color: Color(0xFF2D58A2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF2D58A2,
                                ).withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: About
                    _buildSectionTitle("About"),
                    Material(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.info_outline,
                              color: isDark ? Colors.white70 : Colors.black54,
                              size: 22,
                            ),
                            title: Text(
                              "OpexA learner app",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              "Version 0.11.4 · prototype · Maths only for now",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ),
                          const Divider(height: 1, color: Colors.white12),
                          ListTile(
                            onTap: () {
                              GoRouter.of(context).push(
                                '${AppRoutes.mainMe}/${AppRoutes.mainMeHelpSupport}/${AppRoutes.mainMeWhatsNew}',
                              );
                            },
                            leading: Icon(
                              Icons.auto_awesome_outlined,
                              color: isDark ? Colors.white70 : Colors.black54,
                              size: 22,
                            ),
                            title: Text(
                              "What's new",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              "Changes in each version",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
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

  void showOpexASupportBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TextEditingController problemController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the sheet to adjust when keyboard opens
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          // Adjust padding to lift content above the keyboard
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Handle Indicator
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
              const SizedBox(height: 16),

              // Modal Header Title
              Text(
                "Message OpexA support",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2C221E),
                ),
              ),
              const SizedBox(height: 16),

              // Field Label
              Text(
                "What’s the problem?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Problem Input Textarea
              TextField(
                controller: problemController,
                maxLines: 4,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "Tell us what happened",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF382D24) : Colors.white,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6B9BFA),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Send CTA Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final message = problemController.text.trim();
                    if (message.isNotEmpty) {
                      // Send message logic here
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B9BFA),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Text Link Button
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const FaqTile({super.key, required this.question, required this.answer});

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
        ),
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        // Smoothly rotates the right-facing chevron 90 degrees (0.25 turns) downward when expanded
        trailing: AnimatedRotation(
          turns: _isExpanded ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.answer,
                style: const TextStyle(fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
