import 'package:flutter/material.dart';
import '../../widgets/widget.dart';
import 'widget.dart';

// ==========================================
// 2. "ABOUT YOU" - HOME LEARNING PATH
// ==========================================
class HomeAboutYouScreen extends StatefulWidget {
  const HomeAboutYouScreen({super.key});

  @override
  State<HomeAboutYouScreen> createState() => _HomeAboutYouScreenState();
}

class _HomeAboutYouScreenState extends State<HomeAboutYouScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  String? selectedClass = "JSS2";
  // Dropdown open states
  bool _isSchoolSystemOpen = false;
  bool _isToughSubjectsOpen = false;

  // Selected values
  String? _selectedSchoolSystem = "Nigerian national curriculum";
  final List<String> _selectedEnjoyedSubjects = [];
  final List<String> _selectedToughSubjects = [];

  // Options lists
  final List<String> _schoolSystems = [
    "Nigerian national curriculum",
    "British curriculum",
    "Other or not sure",
  ];

  final List<String> _toughSubjectOptions = [
    "Mathematics",
    "English",
    "Physics",
    "None of these",
  ];

  final List<String> _enjoyedSubjectOptions = [
    "Mathematics",
    "English",
    "Physics",
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OpexStepHeader(currentStep: 3, totalSteps: 6),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "About you",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "This helps OpexA talk to you and start at the right level.",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF7E7672),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Full Name Field
                    const Text(
                      "Your full name",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        hintText: "e.g. Tobi Adeyemi",
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF322418)
                            : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nickname Field
                    const Text(
                      "What should we call you?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        hintText: "e.g. Tobi",
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF322418)
                            : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "A first name or nickname is fine.",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Class",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.95,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: ["JSS1", "JSS2", "JSS3", "SS1", "SS2", "SS3"]
                          .map((cls) {
                            final isSelected = selectedClass == cls;
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => setState(() => selectedClass = cls),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).splashColor.withOpacity(0.3)
                                      : (isDark
                                            ? const Color(0xFF322418)
                                            : Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF7EB2FC)
                                        : (isDark
                                              ? const Color(0xFF75695F)
                                              : Colors.grey.shade300),
                                    width: isSelected ? 1.2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    cls,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "From your school record. Change it if it’s wrong.",
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    OpexCustomDropdown(
                      label: "School system",
                      hintText: "Choose school system",
                      displayValue:
                          _selectedSchoolSystem ?? _schoolSystems.first,
                      isOpen: _isSchoolSystemOpen,
                      onTap: () {
                        setState(() {
                          _isSchoolSystemOpen = !_isSchoolSystemOpen;
                          _isToughSubjectsOpen = false; // Close other dropdown
                        });
                      },
                      child: Column(
                        children: _schoolSystems.map((system) {
                          bool isSelected = _selectedSchoolSystem == system;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedSchoolSystem = system;
                                _isSchoolSystemOpen = false;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              color: isSelected
                                  ? (isDark
                                        ? const Color(0xFF4A3727)
                                        : const Color(0xFFE8F1FF))
                                  : Colors.transparent,
                              child: Text(
                                system,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).splashColor
                                      : (isDark
                                            ? Colors.white
                                            : Colors.black87),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        children: [
                          const TextSpan(
                            text: "Subjects you enjoy ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: "(optional)",
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _enjoyedSubjectOptions.map((subject) {
                        final isSelected = _selectedEnjoyedSubjects.contains(
                          subject,
                        );
                        return InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedEnjoyedSubjects.remove(subject);
                              } else {
                                _selectedEnjoyedSubjects.add(subject);
                              }
                            });
                          },
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF30343A)
                                  : (isDark
                                        ? const Color(0xFF322418)
                                        : Colors.white),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).splashColor.withOpacity(0.3)
                                    : (isDark
                                          ? const Color(0xFF75695F)
                                          : Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Color(0xFF7EB2FC),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  subject,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // ==========================================
                    // 2. SUBJECTS YOU FIND TOUGH (Multi-Select Checkboxes)
                    // ==========================================
                    OpexCustomDropdown(
                      label: "Subjects you find tough (optional)",
                      hintText: "Choose subjects",
                      displayValue: _selectedToughSubjects.isEmpty
                          ? ""
                          : _selectedToughSubjects.join(", "),
                      isOpen: _isToughSubjectsOpen,
                      onTap: () {
                        setState(() {
                          _isToughSubjectsOpen = !_isToughSubjectsOpen;
                          _isSchoolSystemOpen = false; // Close other dropdown
                        });
                      },
                      child: Column(
                        children: _toughSubjectOptions.map((subject) {
                          bool isChecked = _selectedToughSubjects.contains(
                            subject,
                          );
                          return Material(
                            color: Colors.transparent,
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                subject,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                              value: isChecked,
                              activeColor: const Color(0xFF0052FF),
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    if (subject == "None of these") {
                                      _selectedToughSubjects.clear();
                                    } else {
                                      _selectedToughSubjects.remove(
                                        "None of these",
                                      );
                                    }
                                    _selectedToughSubjects.add(subject);
                                  } else {
                                    _selectedToughSubjects.remove(subject);
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "No judgement. It helps us know where to start.",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomePrivacyScreen(),
                            ),
                          );
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
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. PRIVACY SCREEN - HOME LEARNING PATH (With Guardian Card)
// ==========================================
class HomePrivacyScreen extends StatefulWidget {
  const HomePrivacyScreen({super.key});

  @override
  State<HomePrivacyScreen> createState() => _HomePrivacyScreenState();
}

class _HomePrivacyScreenState extends State<HomePrivacyScreen> {
  // Toggle state to switch between button view and input form view
  bool _isAddingGuardian = false;

  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianPhoneController =
      TextEditingController();

  @override
  void dispose() {
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OpexStepHeader(currentStep: 4, totalSteps: 6),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Your data and who sees it",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You learn at home, so you decide who sees your progress.",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF7E7672),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Privacy Bullet 1
                    _buildPrivacyRow(
                      context,
                      Icons.lock_outline,
                      "Your progress is private to you.",
                      isDark,
                    ),
                    const SizedBox(height: 16),

                    // Privacy Bullet 2
                    _buildPrivacyRow(
                      context,
                      Icons.person_outline,
                      "If you add a Guardian, they can see your progress and help you.",
                      isDark,
                    ),
                    const SizedBox(height: 16),

                    // Privacy Bullet 3
                    _buildPrivacyRow(
                      context,
                      Icons.visibility_outlined,
                      "You can see everything OpexA knows about you in Me.",
                      isDark,
                    ),
                    const SizedBox(height: 24),

                    // Add a Guardian Container Box
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF322418) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add a Guardian (optional)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "A parent, guardian or tutor who helps you learn. You can also use OpexA completely on your own.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!_isAddingGuardian) ...[
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isAddingGuardian = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.person_add_outlined,
                                  size: 18,
                                  color: Theme.of(context).splashColor,
                                ),
                                label: Text(
                                  "Add a Guardian",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).splashColor,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).canvasColor.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            // Their name field
                            const Text(
                              "Their name",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _guardianNameController,
                              decoration: InputDecoration(
                                hintText: "e.g. Mrs Adeyemi",
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF241A10)
                                    : const Color(0xFFFAF6F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Their phone number field
                            const Text(
                              "Their phone number",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF241A10)
                                        : const Color(0xFFFAF6F2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text("🇳🇬"),
                                      SizedBox(width: 4),
                                      Text(
                                        "+234",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _guardianPhoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: "803 123 4567",
                                      filled: true,
                                      fillColor: isDark
                                          ? const Color(0xFF241A10)
                                          : const Color(0xFFFAF6F2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Invite them action button
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle invite submission action
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).canvasColor.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Invite them',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).splashColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AssessmentIntroScreen(),
                      ),
                    );
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
                    'Continue on my own',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyRow(
    BuildContext context,
    IconData icon,
    String text,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).splashColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).splashColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
