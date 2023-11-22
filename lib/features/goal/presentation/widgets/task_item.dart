// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/core/utils/helpers.dart';
import 'package:memo_planner/features/goal/domain/entities/task_entity.dart';
import 'package:memo_planner/features/goal/presentation/bloc/task/task_bloc.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
  });
  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => context.go('/goal/task/detail/${task.taskId}'),
      onTap: () => context.go('/goal/task/detail', extra: task),
      child: Card(
        color: Colors.green[50],
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: Text(task.summary!, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Row(
            children: [
              Icon(Icons.lock_clock, color: Colors.black),
              SizedBox(width: 5),
              Text(getRemainingTime(task.dueDate)),
            ],
          ),
          // TODO change to checkbox by status
          trailing: Checkbox(
            value: task.completed,
            onChanged: (value) {
              context.read<TaskBloc>().add(TaskEventUpdated(task.copyWith(completed: value)));
            },
          ),
        ),
      ),
    );
  }
}
