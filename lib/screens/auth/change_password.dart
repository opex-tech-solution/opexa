import 'package:flutter/material.dart';

class ChooseNewPasswordScreen extends StatelessWidget {
  const ChooseNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: isDark ? Colors.white70 : Colors.black87),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Choose a new password",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF2C221E)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "For +234 803 000 0000.",
                      style: TextStyle(fontSize: 15, color: isDark ? Colors.white70 : const Color(0xFF7E7672)),
                    ),
                    const SizedBox(height: 24),
                    const Text("New password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "At least 8 characters",
                        filled: true,
                        fillColor: isDark ? const Color(0xFF322418) : Colors.white,
                        suffixIcon: const Icon(Icons.visibility_off_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Use at least 8 characters. Mixing letters and numbers makes it stronger.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 20),
                    const Text("Type it again", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Same new password",
                        filled: true,
                        fillColor: isDark ? const Color(0xFF322418) : Colors.white,
                        suffixIcon: const Icon(Icons.visibility_off_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24488A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Save new password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
