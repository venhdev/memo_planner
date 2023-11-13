import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/core/widgets/widgets.dart';
import 'package:memo_planner/features/habit/domain/usecase/get_habit_by_hid.dart';

import '../../../../config/dependency_injection.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/rrule.dart';
import '../bloc/habit/habit_bloc.dart';

class EditHabitScreen extends StatefulWidget {
  const EditHabitScreen({
    super.key,
    required this.hid,
  });

  final String hid;
  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  List<String> list = RRULE.list;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: di<GetHabitByHidUC>()(widget.hid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (failure) => MessageScreen(message: failure.message),
                (habit) => buildEditHabitBody(context, habit),
              );
            } else {
              return MessageScreen(message: snapshot.error.toString());
            }
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }

  Container buildEditHabitBody(BuildContext context, HabitEntity habit) {
    titleController = TextEditingController(text: habit.summary);
    descriptionController = TextEditingController(text: habit.description);

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
                final updatedHabit = habit.copyWith(
                  summary: titleController.text,
                  description: descriptionController.text,
                  updated: DateTime.now(),
                );
                BlocProvider.of<HabitBloc>(context).add(
                  HabitUpdateEvent(
                    habit: updatedHabit,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Edit Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
