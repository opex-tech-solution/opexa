import 'package:flutter/material.dart';
import 'widget.dart';

// ==========================================
// 2. SCHOOL CODE SCREEN WITH VALIDATION
// ==========================================
class SchoolCodeScreen extends StatefulWidget {
  const SchoolCodeScreen({super.key});

  @override
  State<SchoolCodeScreen> createState() => _SchoolCodeScreenState();
}

class _SchoolCodeScreenState extends State<SchoolCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _hasError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _validateAndContinue() {
    final text = _codeController.text.trim();

    // Regular expression matching pattern: OPX-XXX-XXX (case-insensitive)
    final RegExp codeRegex = RegExp(
      r'^OPX-[A-Za-z0-9]{3}-[A-Za-z0-9]{3}$',
      caseSensitive: false,
    );

    if (text.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please enter your school sign-in code.';
      });
    } else if (!codeRegex.hasMatch(text)) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid format. Use format like OPX-482-913';
      });
    } else {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });

      // Proceed to the next step (e.g., School About You screen)
      Navigator.of(context).pushNamed('/school-about-you');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connected to Step 2 of 6 stepper header
              const OpexStepHeader(currentStep: 2, totalSteps: 6),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Enter your school code",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF2C221E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your school gives every learner a sign-in code. It's on the card from your teacher.",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF7E7672),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // School sign-in code field
                      const Text(
                        "School sign-in code",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _codeController,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: "OPX-000-000",
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF322418)
                              : Colors.white,
                          errorText: _hasError ? _errorMessage : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasError
                                  ? Colors.red
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasError
                                  ? Colors.red
                                  : const Color(0xFF0052FF),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (_hasError) {
                            setState(() {
                              _hasError = false;
                              _errorMessage = '';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Letters and numbers, like OPX-123-456.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Continue Button & Footer Link
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _validateAndContinue,
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
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        // Handle lost card / help action
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Lost your card? ",
                              style: TextStyle(color: Color(0xFF7E7672)),
                            ),
                            TextSpan(
                              text: "Get help",
                              style: TextStyle(
                                color: Theme.of(context).shadowColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
