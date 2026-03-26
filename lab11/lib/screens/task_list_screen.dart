import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.controller});

  final TaskController controller;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task title',
                    ),
                    onSubmitted: (_) => _handleAddTask(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  key: const Key('addTaskButton'),
                  onPressed: _handleAddTask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  final tasks = widget.controller.tasks;
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text('No tasks yet. Add one!'),
                    );
                  }
                  return ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _TaskTile(
                        task: task,
                        onToggle: () => widget.controller.toggleTask(task),
                        onTap: () => _openDetail(task),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddTask() {
    final created = widget.controller.addTask(_titleController.text);
    if (created) {
      _titleController.clear();
    }
  }

  void _openDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          controller: widget.controller,
          task: task,
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey('task-${task.id}'),
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
