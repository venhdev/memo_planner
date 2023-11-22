import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/core/widgets/widgets.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task/task_bloc.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    this.task,
  });
  final TaskEntity? task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _summaryController = TextEditingController();
  final _descriptionController = TextEditingController();

  // a copy task to edit
  late TaskEntity _task;

  @override
  void initState() {
    super.initState();
    _summaryController.text = widget.task!.summary!;
    _descriptionController.text = widget.task!.description ?? '';
    _task = widget.task!;
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            context.read<TaskBloc>().add(TaskEventUpdated(_task)),
            context.go('/goal'),
          },
        ),
        actions: [
          widget.task!.completed!
              ? buildActionButton(
                  color: Colors.red[100],
                  title: 'Undo',
                  onTap: () {
                    context.read<TaskBloc>().add(TaskEventUpdated(_task.copyWith(completed: false)));
                    context.go('/goal');
                  },
                )
              : buildActionButton(
                  color: Colors.green[100],
                  title: 'Done',
                  onTap: () {
                    context.read<TaskBloc>().add(TaskEventUpdated(_task.copyWith(completed: true)));
                    context.go('/goal');
                  },
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              // task summary
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.title),
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) => _task = _task.copyWith(summary: value),
              ),

              // due date
              MyDatePicker(
                date: _task.dueDate,
                onTap: () async {
                  var datePicked = await showMyDatePicker(context, initDate: _task.dueDate == null ? DateTime.now() : _task.dueDate!);
                  if (datePicked != null) {
                    setState(() {
                      _task = _task.copyWith(dueDate: datePicked);
                    });
                  }
                },
                onPressedClose: () {
                  setState(() {
                    _task = _task.copyWith(dueDateNull: true, dueDate: null);
                  });
                },
              ),
              MyTimePicker(
                date: _task.dueDate,
                onTap: () async {
                  var timePicked =
                      await showMyTimePicker(context, initTime: _task.dueDate == null ? TimeOfDay.now() : TimeOfDay.fromDateTime(_task.dueDate!));
                  if (timePicked != null) {
                    setState(() {
                      _task = _task.copyWith(
                          dueDate: DateTime(
                        _task.dueDate!.year,
                        _task.dueDate!.month,
                        _task.dueDate!.day,
                        timePicked.hour,
                        timePicked.minute,
                      ));
                    });
                  }
                },
                onPressedClose: () {
                  setState(() {
                    _task = _task.copyWith(dueDateNull: true, dueDate: null);
                  });
                },
              ),

              const SizedBox(height: 20.0),

              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onChanged: (value) => _task = _task.copyWith(description: value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
