import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/buttons.dart';

class InterstitialScreen extends StatelessWidget {
  const InterstitialScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.button,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String body;
  final String button;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: C.surface, borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: C.muted, size: 26),
                ),
                const SizedBox(height: 18),
                Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13.5, color: C.muted, height: 1.4)),
              ]),
            ),
          ),
        ),
        PrimaryButton(label: button, onPressed: onPressed),
      ]),
    );
  }
}
