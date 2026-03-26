// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab12/main.dart';

void main() {
  testWidgets('Task creation flow updates the list view', (tester) async {
    await tester.pumpWidget(const TasklyApp());

    expect(find.text('Taskly'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('taskInputField')), 'Write tests');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    expect(find.text('Write tests'), findsOneWidget);
  });
}
