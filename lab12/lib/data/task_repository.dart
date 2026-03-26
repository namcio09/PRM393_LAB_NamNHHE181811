import '../models/task.dart';

class TaskRepository {
  TaskRepository({List<Task>? initialTasks})
      : _tasks = List<Task>.from(initialTasks ?? []),
        _idCounter = 0;

  final List<Task> _tasks;
  int _idCounter;

  List<Task> get tasks => List.unmodifiable(_tasks);

  Task addTask(String title) {
    final trimmedTitle = title.trim();
    final task = Task(
      id: _generateId(),
      title: trimmedTitle,
    );
    _tasks.add(task);
    return task;
  }

  void addExisting(Task task) {
    _tasks.add(task);
  }

  bool deleteTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return false;
    }
    _tasks.removeAt(index);
    return true;
  }

  Task? updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index == -1) {
      return null;
    }
    _tasks[index] = updatedTask;
    return updatedTask;
  }

  Task? getTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return null;
    }
    return _tasks[index];
  }

  String _generateId() {
    _idCounter++;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return 'task_${timestamp}_$_idCounter';
  }
}
