import 'package:flutter/foundation.dart';

import '../data/task_repository.dart';
import '../models/task.dart';

class TaskController extends ChangeNotifier {
  TaskController({TaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  final TaskRepository _repository;

  List<Task> get tasks => _repository.tasks;

  bool addTask(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    _repository.addTask(trimmed);
    notifyListeners();
    return true;
  }

  void toggleTask(Task task) {
    final updated = task.toggle();
    _repository.updateTask(updated);
    notifyListeners();
  }

  Task? updateTaskTitle(Task task, String nextTitle) {
    final trimmed = nextTitle.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final updated = task.copyWith(title: trimmed);
    final saved = _repository.updateTask(updated);
    if (saved != null) {
      notifyListeners();
    }
    return saved;
  }

  Task? findTask(String id) => _repository.getTask(id);
}
