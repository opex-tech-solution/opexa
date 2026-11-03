import 'package:flutter/material.dart';
import '../../theme/widget.dart';
import 'widget.dart';

/// Entry point for the whole diagnostic check (questions -> quick fix ->
/// fresh questions -> "your map is ready").
class MathDiagnosticScreen extends StatelessWidget {
  const MathDiagnosticScreen({super.key, this.userName, this.onOpenMap});

  final String? userName;

  /// Called when the student leaves the check for the map.
  final OpenMapCallback? onOpenMap;

  @override
  Widget build(BuildContext context) {
    return MathThemeScope(
      child: DiagnosticFlow(userName: userName, onOpenMap: onOpenMap),
    );
  }
}
