import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/habit_entity.dart';
import '../bloc/bloc/habit_bloc.dart';

class AddHabitForm extends StatelessWidget {
  const AddHabitForm({
    super.key,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
  })  : _titleController = titleController,
        _descriptionController = descriptionController;

  final TextEditingController _titleController;
  final TextEditingController _descriptionController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Habit Title',
              hintText: 'What is your habit?',
            ),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Describe your habit',
            ),
          ),

          // button to add habit to HabitBloc
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<HabitBloc>(context).add(
                HabitAddEvent(
                  habit: HabitEntity(
                    hid: null,
                    summary: _titleController.text,
                    description: _descriptionController.text,
                    start: DateTime.now(),
                    end: DateTime.now(),
                    created: DateTime.now(),
                    updated: DateTime.now(),
                    creator: null,
                    completions: const [],
                  ),
                ),
              );
            },
            child: const Text('Add Habit'),
          ),
        ],
      ),
    );
  }
}
