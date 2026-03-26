import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.controller,
    required this.task,
  });

  final TaskController controller;
  final Task task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _titleController = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('detailTitleField'),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSave,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    final updated = widget.controller.updateTaskTitle(_task, _titleController.text);
    if (updated != null) {
      setState(() {
        _task = updated;
      });
      Navigator.of(context).pop();
    }
  }
}
