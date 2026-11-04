import 'package:flutter/material.dart';
import '../../theme/widget.dart';
import '../map/widget.dart';

/// Full-screen learning list (opened above the bottom bar).
class MathLearningListScreen extends StatelessWidget {
  const MathLearningListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MathThemeScope(child: LearningListPage());
  }
}
