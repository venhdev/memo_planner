import 'package:flutter/material.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/widgets/picker.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({
    super.key,
    required this.type,
  });

  final EditType type;

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // task summary
          TextFormField(),
          // task description
          TextFormField(),
          // task due date
          TextButton.icon(
            onPressed: () => {
              showMyDatePicker(context, initDate: DateTime.now()).then((value) {
                if (value != null) {
                  setState(() {
                    _dueDate = value;
                  });
                }
              }),
            },
            icon: const Icon(Icons.calendar_month),
            label: Text(_dueDate == null ? 'Select due date' : 'Due date: ${_dueDate!.toIso8601String()}'),
          ),
        ],
      ),
    );
  }
}
