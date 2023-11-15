import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo_planner/core/widgets/message_screen.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/widgets/loading_screen.dart';
import '../../data/models/habit_model.dart';
import 'widgets.dart';

class HabitList extends StatelessWidget {
  const HabitList({
    super.key,
    required this.habitStream,
    required this.focusDate,
    this.query = '',
  });

  final SQuerySnapshot habitStream;
  final DateTime focusDate;
  final String query;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: habitStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final habits = snapshot.data!.docs;
            if (habits.isEmpty) {
              return const EmptyHabit();
            }
            final filteredHabits = habits.where((element) {
              final habit = HabitModel.fromDocument(element.data());
              return habit.summary!.contains(query);
            }).toList();
            return FilterHabitList(
                habits: filteredHabits, focusDate: focusDate);
          } else if (snapshot.hasError) {
            return MessageScreen(message: snapshot.error.toString());
          } else {
            return const MessageScreen(message: 'No data found');
          }
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}

class FilterHabitList extends StatefulWidget {
  const FilterHabitList({
    super.key,
    required this.habits,
    required this.focusDate,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> habits;
  final DateTime focusDate;

  @override
  State<FilterHabitList> createState() => _FilterHabitListState();
}

class _FilterHabitListState extends State<FilterHabitList> {
  @override
  Widget build(BuildContext context) {
    final progressingHabits = widget.habits.where((element) {
      final habit = HabitModel.fromDocument(element.data());
      debugPrint(
          'isInProgress: ${isInProgress(habit.start!, habit.end!, widget.focusDate)}');
      return isInProgress(habit.start!, habit.end!, widget.focusDate);
    }).toList();
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: progressingHabits.length,
        itemBuilder: (context, index) {
          final habitMap = progressingHabits[index].data();
          var habit = HabitModel.fromDocument(habitMap);
          return HabitItem(
            habit: habit,
            focusDate: widget.focusDate,
          );
        },
      ),
    );
  }
}

bool isInProgress(DateTime start, DateTime end, DateTime focusDate) {
  return (start.isBefore(focusDate) && end.isAfter(focusDate)) ||
      (end.isAtSameMomentAs(focusDate)) ||
      (start.isAtSameMomentAs(focusDate));
}
