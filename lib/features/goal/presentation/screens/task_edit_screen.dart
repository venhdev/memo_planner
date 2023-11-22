import 'package:flutter/material.dart';
import 'package:memo_planner/core/constants/enum.dart';

import '../widgets/add_task_form.dart';

class TaskEditScreen extends StatelessWidget {
  const TaskEditScreen({
    super.key,
    required this.type,
    this.id,
  });

  final EditType type;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12.0),
        AddTaskForm(type: type),
        const SizedBox(height: 72.0),
      ],
    );
  }
}
