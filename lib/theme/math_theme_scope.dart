import 'package:flutter/material.dart';

import 'widget.dart';

class MathThemeScope extends StatelessWidget {
  const MathThemeScope({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(data: Styles.mathTheme(context), child: child);
  }
}
