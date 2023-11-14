import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/usecase/usecases.dart';
import '../bloc/instance/instance_bloc.dart';

class EditHabitInstanceScreen extends StatefulWidget {
  const EditHabitInstanceScreen({
    super.key,
    required this.iid,
  });

  final String iid;
  @override
  State<EditHabitInstanceScreen> createState() =>
      _EditHabitInstanceScreenState();
}

class _EditHabitInstanceScreenState extends State<EditHabitInstanceScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

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
        future: di<GetCreateHabitInstanceByIid>()(widget.iid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (failure) => MessageScreen(message: failure.message),
                (instance) => buildEditHabitInstanceBody(context, instance),
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

  Container buildEditHabitInstanceBody(
    BuildContext context,
    HabitInstanceEntity instance,
  ) {
    titleController = TextEditingController(text: instance.summary);
    descriptionController = TextEditingController(text: instance.description);

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
            // button to add habit to HabitBloc
            ElevatedButton(
              onPressed: () {
                final updatedInstance = instance.copyWith(
                  summary: titleController.text,
                  description: descriptionController.text,
                  updated: DateTime.now(),
                );
                BlocProvider.of<HabitInstanceBloc>(context).add(
                  InstanceUpdateEvent(
                    instance: updatedInstance,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Edit Habit (Only this one)'),
            ),
          ],
        ),
      ),
    );
  }
}
