import 'package:flutter/material.dart';
import 'learning_list_page.dart';
import 'map_tab.dart';
import '../../theme/app_colors.dart';
import '../../theme/math_theme_scope.dart';

class MapShell extends StatefulWidget {
  const MapShell({super.key, this.userName, this.openLearningList = false});
  final String? userName;
  final bool openLearningList;

  @override
  State<MapShell> createState() => _MapShellState();
}

class _MapShellState extends State<MapShell> {
  int _tab = 1;

  @override
  void initState() {
    super.initState();
    if (widget.openLearningList) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openLearningList();
      });
    }
  }

  void _openLearningList() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const MathThemeScope(child: LearningListPage())));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _Placeholder('Today'),
      MapTab(onOpenLearningList: _openLearningList),
      const _Placeholder('Readiness'),
      const _Placeholder('Me'),
    ];
    return Scaffold(
      body: SafeArea(bottom: false, child: pages[_tab]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: C.bg,
        indicatorColor: C.outlineSoft,
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Readiness'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Me'),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Center(
        child: Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: C.muted)),
      );
}
