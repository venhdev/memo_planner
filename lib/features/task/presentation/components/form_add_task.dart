import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/core/notification/reminder.dart';
import 'package:memo_planner/core/utils/helpers.dart';
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:memo_planner/features/task/domain/entities/task_entity.dart';
import 'package:memo_planner/features/task/domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class FormAddTask extends StatefulWidget {
  const FormAddTask( this.lid,{super.key});

  final String lid;

  @override
  State<FormAddTask> createState() => _FormAddTaskState();
}

class _FormAddTaskState extends State<FormAddTask> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String label = 'Set Due Date';
  Color labelColor = Colors.black;
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    log('render FormAddTask');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    onSubmittedAddTask(context, _controller.text);
                  }
                },
                label: const Text('Add'),
                icon: const Icon(Icons.add_task),
              ),
            ],
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Add New Task',
              prefixIcon: Icon(Icons.title),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                onSubmittedAddTask(context, value);
              }
            },
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionChip(
                avatar: Icon(Icons.calendar_today, color: labelColor),
                label: Text(label, style: TextStyle(color: labelColor)),
                onPressed: () async {
                  final pickedDate = await showMyDatePicker(context, initDate: DateTime.now());
                  if (pickedDate != null) {
                    // > change color to red if date is in the past
                    if (pickedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                      labelColor = Colors.red;
                    } else {
                      labelColor = Colors.blue;
                    }
                    setState(() {
                      label = convertDateTimeToString(pickedDate, pattern: 'dd/MM');
                    });
                  }
                },
                tooltip: 'Set Due Date',
              ),

              // Button Clear
              TextButton(
                onPressed: () {
                  setState(() {
                    label = 'Set Due Date';
                    labelColor = Colors.black;
                    _controller.clear();
                    _focusNode.requestFocus();
                  });
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSubmittedAddTask(BuildContext context, String value) {
    // > add task to list
    final currentUser = context.read<AuthenticationBloc>().state.user;
    di<TaskRepository>().addTask(
      TaskEntity(
        tid: null,
        lid: widget.lid,
        taskName: value,
        description: null,
        priority: null,
        completed: false,
        dueDate: dueDate,
        reminders: dueDate != null
          ? Reminder(rid: generateNotificationId(dueDate!))
          : null,
        creator: currentUser,
        assignedMembers: null,
        created: DateTime.now(),
        updated: DateTime.now(),
      )
    );
    // > clear text field
    _controller.clear();
    // > set focus to text field
    _focusNode.requestFocus();
  }
}
