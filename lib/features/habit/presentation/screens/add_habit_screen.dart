import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/features/habit/domain/entities/rrule.dart';

import '../../domain/entities/habit_entity.dart';
import '../bloc/habit/habit_bloc.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  List<String> list = RRULE.list;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Title',
                hintText: 'What is your habit?',
              ),
            ),
            TextFormField(
              controller: descriptionController,
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
                value: list.first,
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
                      summary: titleController.text,
                      description: descriptionController.text,
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
