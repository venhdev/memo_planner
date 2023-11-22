import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task_entity.dart';
import '../bloc/task/task_bloc.dart';

class AddTaskQuick extends StatefulWidget {
  const AddTaskQuick({super.key});

  @override
  State<AddTaskQuick> createState() => _AddTaskQuickState();
}

class _AddTaskQuickState extends State<AddTaskQuick> {
  final _controller = TextEditingController();
  String _quickTaskText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              setState(() {
                _quickTaskText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Add quick task',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              suffixIcon: Visibility(
                visible: _controller.text.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // BlocProvider.of<TaskBloc>(context).add(TaskEventAdded(
            //   task: TaskEntity(summary: _quickTaskText),
            // ));
            context.read<TaskBloc>().add(
                  TaskEventAdded(
                    task: TaskEntity(summary: _quickTaskText),
                  ),
                );
            _controller.clear();
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
