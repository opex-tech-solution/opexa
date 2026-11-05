import 'package:flutter/material.dart';

class WhatOpexAKnowsSchoolScreen extends StatelessWidget {
  const WhatOpexAKnowsSchoolScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: isDark ? Colors.white70 : Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "What OpexA knows",
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
                      "This is everything OpexA keeps about you, in plain words.",
                      style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // SECTION: About you
                    _buildSectionTitle("About you"),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildDataRow("Name", "Amaka Obi"),
                          _buildDataRow("We call you", "Amaka"),
                          _buildDataRow("Class", "JSS2"),
                          _buildDataRow("School", "Government Secondary School, Garki"),
                          _buildDataRow("School sign-in code", "OPX-482-913"),
                          _buildDataRow("School system", "Nigerian national curriculum"),
                          _buildDataRow("Subjects you enjoy", "English"),
                          _buildDataRow("Subjects you find tough", "Mathematics", showDivider: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Your learning
                    _buildSectionTitle("Your learning"),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildDataRow("First check", "Done · 12 answers saved"),
                          _buildDataRow("Your blocks", "7 solid · 7 not checked yet"),
                          _buildDataRow("Lessons", "7 lessons and quick checks done", showDivider: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: What helps you learn
                    _buildSectionTitle("What helps you learn"),
                    
                    // On Number Blocks Card
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
                            "ON NUMBER BLOCKS",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 12),
                          _buildLearningStatRow(Icons.edit_outlined, "Try it first", "0 of 2 went well"),
                          const SizedBox(height: 8),
                          _buildLearningStatRow(Icons.visibility_outlined, "See an example first", "3 of 3 went well", badge: "Helps most"),
                          const SizedBox(height: 8),
                          _buildLearningStatRow(Icons.shopping_basket_outlined, "An everyday example", "1 of 2 went well"),
                          const SizedBox(height: 12),
                          const Text(
                            "How sure we are: moderate. Seen across a few blocks so far.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // On Algebra Blocks Card
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
                            "ON ALGEBRA BLOCKS",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No lessons here yet.",
                            style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // How lessons start card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("How lessons start", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text("OpexA chooses, from what has helped you", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Options list cards
                    _buildOptionCard("Let OpexA choose", "Uses what has helped you, and tries another way when something doesn't click.", isSelected: true, cardColor: Theme.of(context).cardColor, isDark: isDark),
                    const SizedBox(height: 8),
                    _buildOptionCard("Always try it first", "You have a go with the tool, then we explain the idea.", cardColor: Theme.of(context).cardColor, isDark: isDark),
                    const SizedBox(height: 8),
                    _buildOptionCard("Always see an example first", "We show you the idea and a worked example, then you have a go.", cardColor: Theme.of(context).cardColor, isDark: isDark),
                    const SizedBox(height: 8),
                    _buildOptionCard("Always an everyday example", "We explain it with something from everyday life, then you have a go.", cardColor: Theme.of(context).cardColor, isDark: isDark),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "Only lessons where you answered the check on your own count. This is never a label like “visual learner”, and it changes as you learn. Your teacher sees the same.",
                        style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Sharing and settings
                    _buildSectionTitle("Sharing and settings"),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildDataRow("Who sees your progress", "You, your teacher and your school"),
                          _buildDataRow("Appearance", "Same as phone"),
                          _buildDataRow("Low-data mode", "Off"),
                          _buildDataRow("Accessibility", "Reduce motion"),
                          _buildDataRow("Reminders", "Daily at 4:00 pm", showDivider: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: Where it's kept footer box
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
                            "WHERE IT'S KEPT",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "On this phone, so OpexA works offline. In the full app it’s also backed up securely, so you don’t lose it if you change phones.",
                            style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Delete / School Managed Notice
                    _buildSectionTitle("Delete"),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "Your school manages your record. To have it deleted, ask your school.",
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54, height: 1.3),
                      ),
                    ),
                    const SizedBox(height: 32),
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
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildLearningStatRow(IconData icon, String title, String stat, {String? badge}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1B4988), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F1FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1B4988))),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Text(stat, style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
      ],
    );
  }

  Widget _buildOptionCard(String title, String subtitle, {bool isSelected = false, required Color cardColor, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF6B9BFA) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white60 : Colors.black54)),
        ],
      ),
    );
  }
}
