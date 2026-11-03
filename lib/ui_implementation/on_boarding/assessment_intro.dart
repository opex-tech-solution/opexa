// ==========================================
// 4. FINAL SETUP SCREEN: ASSESSMENT INTRO
// ==========================================
import 'package:flutter/material.dart';
import 'widget.dart';

class AssessmentIntroScreen extends StatelessWidget {
  const AssessmentIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OpexStepHeader(currentStep: 6, totalSteps: 6),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    // Question Block Question Mark Visual Graphic
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBlockCard("?"),
                        const SizedBox(width: 8),
                        _buildBlockCard("?"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBlockCard("?"),
                        const SizedBox(width: 8),
                        _buildBlockCard("?"),
                        const SizedBox(width: 8),
                        _buildBlockCard("?"),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "Let's find out where your blocks are",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Next is a short Maths check.",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF7E7672),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Feature Check List items
                    _buildFeatureRow(
                      context,
                      Icons.coffee_outlined,
                      "About 10 to 15 minutes",
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureRow(
                      context,
                      Icons.check_circle_outline,
                      "No grades and no rankings",
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureRow(
                      context,
                      Icons.help_outline,
                      "“I don’t know” is a fine answer",
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureRow(
                      context,
                      Icons.refresh,
                      "Stop anytime and pick up where you left off",
                      isDark,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Action when user clicks to start assessment check
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).shadowColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Start my first check',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Skip or do it later action
                    },
                    child: Text(
                      "I'll do it later",
                      style: TextStyle(
                        color: Theme.of(context).shadowColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockCard(String text) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    IconData icon,
    String text,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).splashColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
