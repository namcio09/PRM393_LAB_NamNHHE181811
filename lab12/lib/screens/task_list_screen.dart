import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_assets.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _didPrecacheBadge = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecacheBadge) {
      precacheImage(const AssetImage(AppAssets.tasklyBadge), context);
      _didPrecacheBadge = true;
    }
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
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.tasklyBadge,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                ElevatedButton.icon(
                  key: const Key('addTaskButton'),
                  onPressed: _handleAddTask,
                  icon: const Icon(Icons.add_task),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Selector<TaskProvider, List<Task>>(
                selector: (_, provider) => provider.tasks,
                builder: (context, tasks, _) {
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text('No tasks yet. Add one!'),
                    );
                  }
                  return ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTile(
                        key: ValueKey(task.id),
                        task: task,
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
    final provider = context.read<TaskProvider>();
    final created = provider.addTask(_titleController.text);
    if (created) {
      _titleController.clear();
    }
  }

  void _openDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
  }
}
