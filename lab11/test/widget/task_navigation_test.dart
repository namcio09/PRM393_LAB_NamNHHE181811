import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab11/controllers/task_controller.dart';
import 'package:lab11/data/task_repository.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('navigates to TaskDetailScreen on tap', (tester) async {
    final repository = TaskRepository(
      initialTasks: [Task(id: 'task-1', title: 'Seed Task')],
    );
    final controller = TaskController(repository: repository);

    await tester.pumpWidget(
      MaterialApp(
        home: TaskListScreen(controller: controller),
      ),
    );

    await tester.tap(find.text('Seed Task'));
    await tester.pumpAndSettle();

    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}
