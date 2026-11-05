import 'package:flutter/material.dart';

class WhatsNew extends StatelessWidget {
  const WhatsNew({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar Header
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
                    "What's new",
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
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListView(
                  children: [
                    _buildData(
                      context,
                      Icons.auto_awesome_outlined,
                      "Version 0.11.4 · this version",
                      "Answers can’t be sent twice: once you answer in a check, a lesson or Teach me, the buttons pause until your answer is saved and the next screen is ready.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.11.3",
                      "Fix: the Map, Today and “Results and your map” links in How OpexA works now open those screens.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.11.2",
                      "Fix: tapping an answer twice quickly in a lesson check no longer records it twice or skips a question.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.11.1",
                      "Fix: tapping an answer twice quickly in a check no longer skips the next question or stops the check from moving on.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.11",
                      "Fairer first check: if your answer is right but a step in your working goes wrong, OpexA checks that step instead of skipping it. New Quick look: once your block to build is fixed, your Foundation track checks earlier blocks you haven’t been checked on yet. Each block now shows where it is, from Checked to Locked in. Today shows how your next lesson starts. New in Help: How OpexA works, the eight-step learning loop.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.10",
                      "Lessons now learn what helps you. Each lesson starts one of three ways: try it first, see an example first, or an everyday example. OpexA remembers which way works for you on number and algebra blocks, tries another way when something doesn’t click, and shows it all in What OpexA knows. You can always pick a different way.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.9",
                      "Teach me: every topic that isn’t Solid now has its own short teaching session before practice, with everyday examples, worked steps, a common mistake and a quick check. Tap Listen to hear it read aloud. New: Your learning list, foundations first.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.8",
                      "Design update from the audit: deep-blue buttons, warm dark mode and larger maths. New brick-style blocks and a map that builds like a wall, with a then-and-now view. Today leads with one “Next up”, answers have big lettered tiles, confidence buttons sit at the bottom, and lessons never put “Skip” first. Illustrations for empty, error and offline moments, a celebration when a block moves up, and a “This week” card on Today.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.7",
                      "Lessons for every Maths block. Tester start screen, session notes and feedback. Small-phone, contrast and accessibility fixes.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.6",
                      "Me, privacy and Guardian invites. Notifications, Larger text and Reduce motion. Offline, error and resume states.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.5",
                      "Readiness for the SS streams.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.4",
                      "Today’s plan with three tracks, and lessons that build blocks.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.3",
                      "Your map, and why a block was chosen.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.2",
                      "The first Maths check.",
                    ),
                    _buildData(
                      context,
                      Icons.check,
                      "Version 0.1",
                      "Sign-up, sign-in and About me.",
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

  Widget _buildData(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, size: 15),
          title: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            value,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
