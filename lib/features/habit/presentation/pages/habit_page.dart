import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/core/constants/constants.dart';
import 'package:memo_planner/features/habit/data/models/habit_model.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_entity.dart';
import 'package:memo_planner/features/habit/domain/usecase/delete_habit.dart';
import 'package:memo_planner/features/habit/presentation/bloc/bloc/habit_bloc.dart';

import '../../../../core/utils/di.dart';
import '../widgets/widgets.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Habit Page'),
          AddHabitForm(
            titleController: _titleController,
            descriptionController: _descriptionController,
          ),
          const SizedBox(height: 20.0),
          StreamBuilder(
              stream: di<FirebaseFirestore>()
                  .collection(pathToUsers)
                  .doc('venh.ha@gmail.com')
                  .collection(pathToHabits)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final habits = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          final QueryDocumentSnapshot habit = habits[index];
                          return ListTile(
                            onTap: () {
                              debugPrint('hid: ${habit['hid']}');
                              debugPrint('habit: $habit');
                              debugPrint('habit id: ${habit.reference.id}');
                              debugPrint('habit start: ${habit['start']}');

                              final Timestamp startTimestamp = habit['start'];

                              debugPrint('startTimestamp: $startTimestamp');
                              debugPrint('startTimestamp second: ${startTimestamp.seconds}');



                              

                              final startFromFire =
                                  DateTime.fromMicrosecondsSinceEpoch(startTimestamp.seconds);
                              debugPrint('startFromFire: $startFromFire');

                              debugPrint(DateTime.now().toString());
                            },
                            title: Text(habit['summary']),
                            subtitle: Text(habit['description']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                final dataMap =
                                    habit.data() as Map<String, dynamic>;

                                final HabitEntity habitEntity =
                                    HabitModel.fromDocument(dataMap).toEntity();

                                debugPrint('HabitEntity: $habitEntity');

                                BlocProvider.of<HabitBloc>(context)
                                    .add(HabitDeleteEvent(habit: habitEntity));

                                debugPrint('END onPressed delete');
                              },
                            ),
                          );
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }
}
