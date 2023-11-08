import 'package:flutter/material.dart';
import 'package:memo_planner/features/habit/presentation/widgets/form_add_habit.dart';

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    return AddHabitForm(
      titleController: titleController,
      descriptionController: descriptionController,
    );
  }
}
