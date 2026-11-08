import 'package:flutter/material.dart';

import '../../../theme/widget.dart';
import '../../../widgets/widget.dart';

/// The big card at the top of Today: illustration, headline, text, one button.
class ResumeCard extends StatelessWidget {
  const ResumeCard({
    super.key,
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.onPressed,
    this.imageAsset = defaultImageAsset,
  });

  /// Drop the illustration at this path (it must be listed under `assets:` in
  /// pubspec.yaml; `assets/images/` already is). Until then a placeholder shows.
  static const String defaultImageAsset = 'assets/images/home.png';

  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onPressed;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 1.96,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: c.surfaceInset,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: c.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: buttonLabel,
            trailingIcon: Icons.arrow_forward,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
