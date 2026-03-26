import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
  });

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => provider.toggleTask(task),
      ),
      title: Text(
        task.title,
        style: textTheme.bodyLarge?.copyWith(
          decoration: task.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
