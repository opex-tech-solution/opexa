import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opexa/screens/map/map_tab.dart';
import 'package:opexa/theme/app_colors.dart';

void main() {
  Future<void> pumpMap(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const <ThemeExtension<dynamic>>[AppColors.light],
        ),
        home: Scaffold(body: MapTab(onOpenLearningList: () {})),
      ),
    );
  }

  testWidgets('Map opens on Now and can switch to first-check snapshot', (
    WidgetTester tester,
  ) async {
    await pumpMap(tester);

    expect(find.text('Map'), findsOneWidget);
    expect(find.text('YOUR NEXT PRACTICE'), findsOneWidget);
    expect(find.text('Your wall right after your first check'), findsNothing);

    await tester.tap(find.text('After my first check'));
    await tester.pumpAndSettle();

    expect(find.text('Your wall right after your first check'), findsOneWidget);
    expect(find.text('YOUR NEXT PRACTICE'), findsNothing);

    await tester.tap(find.text('Now'));
    await tester.pumpAndSettle();

    expect(find.text('YOUR NEXT PRACTICE'), findsOneWidget);
    expect(find.text('Your wall right after your first check'), findsNothing);
  });
}
