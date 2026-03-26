// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab9/main.dart';

void main() {
  testWidgets('Lab9 app loads asset catalog view', (tester) async {
    await tester.pumpWidget(const Lab9App());

    expect(find.text('Lab 9.1 • Asset Catalog'), findsOneWidget);

    await tester.pumpAndSettle();

    // Should render at least one asset card once JSON loads.
    expect(find.byType(ListTile), findsWidgets);
  });
}
