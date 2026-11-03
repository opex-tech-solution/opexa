import 'dart:async';
import 'package:flutter/material.dart';
import 'widget.dart'; // Points to your onboarding screen file

class OpexxaSplashScreen extends StatefulWidget {
  const OpexxaSplashScreen({super.key});

  @override
  State<OpexxaSplashScreen> createState() => _OpexxaSplashScreenState();
}

class _OpexxaSplashScreenState extends State<OpexxaSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the AnimationController (duration: 1.2 seconds)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 2. Define Fade Animation (0.0 to 1.0)
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // 3. Define Scale Animation (starts slightly smaller at 0.85 up to 1.0)
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // Gives a slight, modern pop-in feel
      ),
    );

    // 4. Define Slide Animation (moves up slightly from bottom: Offset(0, 0.15) to Offset.zero)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start the animation immediately when the screen loads
    _controller.forward();

    // Navigate to Onboarding screen after 5 seconds total
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose controllers to prevent memory leaks
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Combined Fade, Scale, and Slide Transition for the Logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset('assets/images/logo.png', height: 120),
                    ),
                  ),
                ),
                const Spacer(),
                // Tagline with its own smooth fade-in
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    "Find the gap, build the block, prove the truth",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
