import 'package:flutter/material.dart';

class OpexStepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OpexStepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back, // or arrow_back
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: List.generate(totalSteps, (index) {
                bool isActive = index < currentStep;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF0052FF)
                          : (isDark ? Colors.white24 : Colors.black12),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
