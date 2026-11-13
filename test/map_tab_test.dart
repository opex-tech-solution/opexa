import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opexa/screens/map/map_tab.dart';
import 'package:opexa/theme/app_colors.dart';

void main() {
  testWidgets('Map tab builds using the current Today state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const <ThemeExtension<dynamic>>[AppColors.light],
        ),
        home: Scaffold(body: MapTab(onOpenLearningList: () {})),
      ),
    );

    expect(find.text('Map'), findsOneWidget);
  });
}
