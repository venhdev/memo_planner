import 'package:flutter/material.dart';
import 'package:memo_planner/core/widgets/widgets.dart';

import '../../domain/entities/task_entity.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.id,
  });

  final String? id;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _summaryController = TextEditingController(text: 'Task Summary 123');

  // Add additional properties for name, description, due date, and completion status
  final String description = 'Task Description';
  final String? dueDate = null;
  final bool completed = false;

  final tTask = TaskEntity(
    taskId: '1',
    summary: 'Task Summary',
    description: 'Task Description',
    creator: null,
    dueDate: DateTime.now(),
    completed: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          _buildActionButton(color: Colors.green[100], title: 'Mark As Done'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          child: Column(
            children: [
              // task summary
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      onTap: () {
                        showMyDatePicker(context, initDate: tTask.dueDate!);
                      },
                      controller: TextEditingController(
                          // text: DateFormat.yMMMd().format(tTask.dueDate!),
                          ),
                      decoration: InputDecoration(
                        label: const Chip(
                          label: Text('Today'),
                        ),
                        hintText: 'Select a date',
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: dueDate != null ? const Icon(Icons.close) : null,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),

              TextField(
                controller: _summaryController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildActionButton({
    VoidCallback? onTap,
    String title = 'Button',
    Color? color = Colors.green,
  }) {
    return InkWell(
      onTap: () {
        onTap;
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(title, style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
