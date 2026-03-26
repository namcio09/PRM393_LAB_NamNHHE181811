// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab3/main.dart';

void main() {
  testWidgets('renders lab exercises', (tester) async {
    await tester.pumpWidget(LabApp(future: runExercises()));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Exercise 1 – Product Repository'), findsWidgets);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Exercise 5 – Factory Singleton'), findsWidgets);
  });
}
