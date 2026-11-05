import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class WhatOpexAKnowsScreen extends StatelessWidget {
  const WhatOpexAKnowsScreen({super.key});

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
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
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
                          _buildDataRow("Name", "Tobi Adeyemi"),
                          _buildDataRow("We call you", "Tobi"),
                          _buildDataRow("Class", "SS1"),
                          _buildDataRow("Where you learn", "At home"),
                          _buildDataRow("Phone number", "+234 803 000 0000"),
                          _buildDataRow(
                            "School system",
                            "Nigerian national curriculum",
                          ),
                          _buildDataRow(
                            "Subjects you enjoy",
                            "Physics, Mathematics",
                          ),
                          _buildDataRow("Subjects you find tough", "English"),
                          _buildDataRow(
                            "SS stream",
                            "Not placed yet",
                            showDivider: false,
                          ),
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
                          _buildDataRow(
                            "First check",
                            "Done · 6 answers saved",
                          ),
                          _buildDataRow(
                            "Your blocks",
                            "1 mastered · 3 solid · 10 not checked yet",
                          ),
                          _buildDataRow(
                            "Lessons",
                            "2 lessons and quick checks done",
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SECTION: What helps you learn
                    _buildSectionTitle("What helps you learn"),
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
                            "How lessons start",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "We're still finding out. After a few lessons, this shows which way of starting a lesson helps you most.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.3,
                            ),
                          ),
                        ],
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
                          _buildDataRow(
                            "Who sees your progress",
                            "You and Mrs Adeyemi",
                          ),
                          _buildDataRow("Appearance", "Same as phone"),
                          _buildDataRow("Low-data mode", "Off"),
                          _buildDataRow("Accessibility", "Reduce motion"),
                          _buildDataRow(
                            "Reminders",
                            "Daily at 4:00 pm",
                            showDivider: false,
                          ),
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
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "On this phone, so OpexA works offline. In the full app it's also backed up securely, so you don't lose it if you change phones.",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Delete Account Button
                    _buildSectionTitle("Delete"),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.trash,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFFBAD0F4)
                              : Color(0xFF2D58A2),
                          size: 20,
                        ),
                        label: Text(
                          "Delete my account and data",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Color(0xFFBAD0F4)
                                : Color(0xFF2D58A2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF7EB2FC,
                          ).withOpacity(0.1),
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

  Widget _buildDataRow(String label, String value, {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            subtitle: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.white12,
          ),
      ],
    );
  }
}
