import 'package:flutter/material.dart';
import '../../theme/widget.dart';
import '../map/widget.dart';
/// Called when the student taps "Your learning list".
typedef OpenLearningListCallback = void Function(BuildContext context);

/// The Map tab content. Meant to be a branch of the app's bottom-nav shell,
/// so it has no tab bar of its own.
class MathMapScreen extends StatelessWidget {
  const MathMapScreen({super.key, required this.onOpenLearningList});

  final OpenLearningListCallback onOpenLearningList;

  @override
  Widget build(BuildContext context) {
    return MathThemeScope(
      child: Scaffold(
        body: SafeArea(
          bottom: false, // the shell's bottom bar handles the bottom inset
          child: MapTab(onOpenLearningList: () => onOpenLearningList(context)),
        ),
      ),
    );
  }
}
