import 'package:flutter/material.dart';

/// TODO: replace with the real Home screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('Home', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
