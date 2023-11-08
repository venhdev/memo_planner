import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/features/habit/domain/entities/rrule.dart';

import '../../domain/entities/habit_entity.dart';
import '../bloc/habit/habit_bloc.dart';

List<String> list = <String>[
  FREQ.DAILY.name,
  FREQ.WEEKLY.name,
  FREQ.MONTHLY.name,
  FREQ.YEARLY.name,
];

class AddHabitForm extends StatefulWidget {
  const AddHabitForm({
    super.key,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
  })  : _titleController = titleController,
        _descriptionController = descriptionController;

  final TextEditingController _titleController;
  final TextEditingController _descriptionController;

  @override
  State<AddHabitForm> createState() => _AddHabitFormState();
}

class _AddHabitFormState extends State<AddHabitForm> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: widget._titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Title',
                hintText: 'What is your habit?',
              ),
            ),
            TextFormField(
              controller: widget._descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your habit',
              ),
            ),
            // dropdown to select recurrence
            DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Recurrence',
                  hintText: 'How often do you want to do this habit?',
                ),
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (value) {},
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
            // button to add habit to HabitBloc
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<HabitBloc>(context).add(
                  HabitAddEvent(
                    habit: HabitEntity(
                      hid: null,
                      summary: widget._titleController.text,
                      description: widget._descriptionController.text,
                      start: DateTime.now(),
                      end: DateTime.now(),
                      recurrence: RRULE.daily().toString(),
                      created: DateTime.now(),
                      updated: DateTime.now(),
                      creator: null,
                      instances: const [],
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
