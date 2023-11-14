import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo_planner/core/widgets/message_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class EmptyHabit extends StatelessWidget {
  const EmptyHabit({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/no-data.svg',
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            'You have no habits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Add your habits to make your life better',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
    return Builder(builder: (context) {
      final progressingHabits = widget.habits.where((element) {
        final habit = HabitModel.fromDocument(element.data());
        return isInProgress(habit.start!, habit.end!, widget.focusDate);
      }).toList();

      return Expanded(
        child: ListView.builder(
          itemCount: progressingHabits.length,
          itemBuilder: (context, index) {
            final habitMap = progressingHabits[index].data();
            var habit = HabitModel.fromDocument(habitMap);
            if (!isInProgress(habit.start!, habit.end!, widget.focusDate)) {
              return const Placeholder(
                fallbackHeight: 100,
              );
            }
            return HabitItem(
              habit: habit,
              focusDate: widget.focusDate,
            );
          },
        ),
      );
    });
  }
}

bool isInProgress(DateTime start, DateTime end, DateTime focusDate) {
  return (start.isBefore(focusDate) && end.isAfter(focusDate)) ||
      (end.isAtSameMomentAs(focusDate)) ||
      (start.isAtSameMomentAs(focusDate));
}
