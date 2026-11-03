import 'package:flutter/material.dart';
import '../../theme/widget.dart';
import '../map/widget.dart';
/// Entry point for the skills map (Today / Map / Readiness / Me tabs).
class MathMapScreen extends StatelessWidget {
  const MathMapScreen({super.key, this.userName, this.openLearningList = false});

  final String? userName;
  final bool openLearningList;

  @override
  Widget build(BuildContext context) {
    return MathThemeScope(
      child: MapShell(userName: userName, openLearningList: openLearningList),
    );
  }
}
