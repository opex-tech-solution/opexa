import 'package:flutter/material.dart';

import 'widget.dart';

// ==========================================
// 2. LEARNING PATH SELECTION SCREEN
// ==========================================
class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  // 0 = "Through my school" selected, 1 = "I learn at home" selected
  int _selectedPath = 0;

  void _onContinuePressed() {
    if (_selectedPath == 0) {
      // Navigate to School Code input screen
      Navigator.of(context).pushNamed('/school-about-you');

      // Or if using standard MaterialPageRoute directly:
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => const SchoolCodeScreen()),
      // );
    } else {
      // Navigate to Home Account Creation screen
      Navigator.of(context).pushNamed('/home-about-you');

      // Or:
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header (Step 1 of 6)
            const OpexStepHeader(currentStep: 1, totalSteps: 6),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "How do you learn?",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This decides how you sign in. You can use OpexA either way.",
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF7E7672),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Option 1: Through my school
                    _buildPathCard(
                      index: 0,
                      icon: Icons.account_balance_outlined,
                      title: "Through my school",
                      subtitle: "Sign in with the code your school gave you",
                      isSelected: _selectedPath == 0,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    // Option 2: I learn at home
                    _buildPathCard(
                      index: 1,
                      icon: Icons.home_outlined,
                      title: "I learn at home",
                      subtitle: "Create an account with your phone number",
                      isSelected: _selectedPath == 1,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button & Footer Link
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).shadowColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue',
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
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF7E7672),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Login / Welcome Back screen
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: Theme.of(context).shadowColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable builder for the selectable cards
  Widget _buildPathCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPath = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).shadowColor.withOpacity(0.1)
              : (isDark ? const Color(0xFF322418) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).shadowColor.withOpacity(0.7)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Theme.of(context).splashColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : const Color(0xFF7E7672),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).shadowColor
                  : Colors.grey.shade400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
