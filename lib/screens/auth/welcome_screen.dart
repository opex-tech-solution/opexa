import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opexa/screens/routes/app_routes.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  // 0 = School code tab active, 1 = Phone number tab active
  int _selectedLoginTab = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Arrow Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                onPressed: () => context.go(AppRoutes.onboarding),
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
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Log in in the way you signed up.",
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF7E7672),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Custom Segmented Toggle Tab at the Top
                    Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF322418)
                            : const Color(0xFFEBE2DE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedLoginTab = 0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _selectedLoginTab == 0
                                      ? (isDark
                                            ? const Color(0xFF4A3727)
                                            : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: _selectedLoginTab == 0 && !isDark
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  "School code",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedLoginTab == 0
                                        ? (isDark
                                              ? Colors.white
                                              : Colors.black87)
                                        : (isDark
                                              ? Colors.white60
                                              : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedLoginTab = 1),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _selectedLoginTab == 1
                                      ? (isDark
                                            ? const Color(0xFF4A3727)
                                            : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: _selectedLoginTab == 1 && !isDark
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  "Phone number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedLoginTab == 1
                                        ? (isDark
                                              ? Colors.white
                                              : Colors.black87)
                                        : (isDark
                                              ? Colors.white60
                                              : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dynamic Fields based on Active Tab
                    if (_selectedLoginTab == 0) ...[
                      // School Code Field View
                      const Text(
                        "School sign-in code",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "OPX-000-000",
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
                    ] else ...[
                      // Phone Number & Password View
                      const Text(
                        "Phone number",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF322418)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Text("🇳🇬"),
                                SizedBox(width: 6),
                                Text(
                                  "+234",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "8030000000",
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF322418)
                              : Colors.white,
                          suffixIcon: const Icon(Icons.visibility_off_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () =>
                              context.push(AppRoutes.forgotPasswordScreen),
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Theme.of(context).shadowColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      onPressed: () => context.go(AppRoutes.mainHome),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).shadowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log in',
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
                        "New to OpexA? ",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF7E7672),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.learningPath),
                        child: Text(
                          "Get started",
                          style: TextStyle(
                            color: Theme.of(context).shadowColor,
                            fontWeight: FontWeight.bold,
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
}
