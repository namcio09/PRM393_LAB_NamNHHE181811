import 'package:flutter_test/flutter_test.dart';

import 'package:lab11/models/task.dart';

void main() {
  group('Task model', () {
    test('defaults to not completed', () {
      final task = Task(id: '1', title: 'Demo task');

      expect(task.completed, isFalse);
    });

    test('toggle switches completion state', () {
      final task = Task(id: '2', title: 'Toggle me');

      final toggled = task.toggle();
      final toggledBack = toggled.toggle();

      expect(toggled.completed, isTrue);
      expect(toggledBack.completed, isFalse);
    });
  });
}
