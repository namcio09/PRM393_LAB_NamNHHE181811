import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab11/controllers/task_controller.dart';
import 'package:lab11/data/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('completes add, edit, and save workflow', (tester) async {
    final controller = TaskController(repository: TaskRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: TaskListScreen(controller: controller),
      ),
    );

    await tester.enterText(find.byKey(const Key('taskInputField')), 'Original title');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('detailTitleField')), 'Updated title');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}
