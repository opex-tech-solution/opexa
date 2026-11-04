import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widget.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // The order here MUST match the order of the branches in AppRouter.
  static const _items = <AppNavItem>[
    AppNavItem(label: 'Home', icon: Icons.home_outlined),
    AppNavItem(label: 'Map', icon: Icons.map_outlined),
    AppNavItem(label: 'Readiness', icon: Icons.widgets_outlined),
    AppNavItem(label: 'Me', icon: Icons.person_outline),
  ];

  void _onSelected(int index) {
    navigationShell.goBranch(
      index,
      // Tapping the tab you are already on returns it to its first page.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onSelected: _onSelected,
      ),
    );
  }
}
