import 'package:flutter/material.dart';

/// TODO: replace with the real Readiness screen.
class ReadinessScreen extends StatelessWidget {
  const ReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('Readiness', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
