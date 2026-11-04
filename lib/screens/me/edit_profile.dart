import 'package:flutter/material.dart';
import '../../widgets/widget.dart';

class EditMeProfile extends StatefulWidget {
  const EditMeProfile({super.key});

  @override
  State<EditMeProfile> createState() => _EditMeProfileState();
}

class _EditMeProfileState extends State<EditMeProfile> {
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
                    "Edit profile",
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      "Your map uses your class to show what’s Foundations, your class and Stretch.",
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    OpexTextField(
                      label: "What should we call you?",
                      hintText: "e.g. Tobi",
                      controller: _nicknameController,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "A first name or nickname is fine.",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).shadowColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save',
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
