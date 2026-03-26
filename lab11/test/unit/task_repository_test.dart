import 'package:flutter_test/flutter_test.dart';

import 'package:lab11/data/task_repository.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('TaskRepository', () {
    test('addTask stores a task with trimmed title', () {
      final repository = TaskRepository();

      final added = repository.addTask('  Learn Flutter  ');

      expect(repository.tasks.length, 1);
      expect(added.title, 'Learn Flutter');
      expect(repository.tasks.first.title, 'Learn Flutter');
    });

    test('deleteTask removes matching task', () {
      final seedTask = Task(id: 'seed-1', title: 'Seed task');
      final repository = TaskRepository(initialTasks: [seedTask]);

      final deleted = repository.deleteTask(seedTask.id);

      expect(deleted, isTrue);
      expect(repository.tasks, isEmpty);
    });

    test('updateTask replaces the stored task by id', () {
      final seedTask = Task(id: 'seed-2', title: 'Original');
      final repository = TaskRepository(initialTasks: [seedTask]);

      final updated = repository.updateTask(seedTask.copyWith(title: 'Updated title'));

      expect(updated?.title, 'Updated title');
      expect(repository.tasks.first.title, 'Updated title');
    });
  });
}
