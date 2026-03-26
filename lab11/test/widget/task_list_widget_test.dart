import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab11/controllers/task_controller.dart';
import 'package:lab11/data/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  Widget _wrap(TaskController controller) {
    return MaterialApp(
      home: TaskListScreen(controller: controller),
    );
  }

  testWidgets('shows empty state when no tasks', (tester) async {
    final controller = TaskController(repository: TaskRepository());

    await tester.pumpWidget(_wrap(controller));

    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });

  testWidgets('adds a task and updates the list', (tester) async {
    final controller = TaskController(repository: TaskRepository());

    await tester.pumpWidget(_wrap(controller));

    await tester.enterText(find.byKey(const Key('taskInputField')), 'Buy milk');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);
  });

  testWidgets('shows multiple tasks after sequential additions', (tester) async {
    final controller = TaskController(repository: TaskRepository());

    await tester.pumpWidget(_wrap(controller));

    await tester.enterText(find.byKey(const Key('taskInputField')), 'Task One');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('taskInputField')), 'Task Two');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    expect(find.text('Task One'), findsOneWidget);
    expect(find.text('Task Two'), findsOneWidget);
  });
}
