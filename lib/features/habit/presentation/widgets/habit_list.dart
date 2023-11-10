import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/loading_screen.dart';
import '../../data/models/habit_model.dart';
import 'widgets.dart';

class HabitList extends StatefulWidget {
  const HabitList({
    super.key,
    required this.habitStream,
    required this.focusDate,
  });

  final Stream<QuerySnapshot> habitStream;
  final DateTime focusDate;

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.habitStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final habits = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return HabitItem(
                    habit: HabitModel.fromDocument(
                        habit.data() as Map<String, dynamic>),
                    focusDate: widget.focusDate,
                  );
                }),
          );
        }
        return const LoadingScreen();
      },
    );
  }
}
