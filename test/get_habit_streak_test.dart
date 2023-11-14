// ignore_for_file: unused_local_variable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_entity.dart';

void main() {
  test('description', () async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime tomorrow = today.add(const Duration(days: 1));

    final HabitEntity tHabit = HabitEntity(
      hid: '9gPpJwRG9s9BSK9ErueL',
      summary: '11',
      description: '11',
      creator: const UserEntity(
        uid: 'uLoTvqUTRlNGBGdl33K5eL6h4i82',
        email: 'venh.ha@gmail.com',
        displayName: 'Vềnh Hà',
        photoURL:
            'https://lh3.googleusercontent.com/a/ACg8ocI-Sm5oWZbAx6nWUDqu2Y0TRGYYB9ILftudfSSRc7h7NCs=s96-c',
      ),
      created: DateTime.now(),
      updated: DateTime.now(),
      end: DateTime.now(),
      recurrence: 'daily',
      start: DateTime.now(),
    );

    final result = getBestStreakOfHabit(tHabit);
    debugPrint('result: ${result.toString()}');
  });
}

int getBestStreakOfHabit(HabitEntity habit) {
  final List<HabitInstance> instances = <HabitInstance>[
    HabitInstance(DateTime(2021, 6, 1), true),
    HabitInstance(DateTime(2021, 6, 2), false),
    HabitInstance(DateTime(2021, 6, 3), false),
    HabitInstance(DateTime(2021, 6, 4), true),
    HabitInstance(DateTime(2021, 6, 5), true),
    HabitInstance(DateTime(2021, 6, 6), true),
    HabitInstance(DateTime(2021, 6, 7), true),
    HabitInstance(DateTime(2021, 6, 8), true),
    HabitInstance(DateTime(2021, 6, 9), true),
    HabitInstance(DateTime(2021, 6, 10), true),
    HabitInstance(DateTime(2021, 6, 11), true),
    HabitInstance(DateTime(2021, 6, 12), true),
    HabitInstance(DateTime(2021, 6, 13), true),
    HabitInstance(DateTime(2021, 6, 14), true),
    HabitInstance(DateTime(2021, 6, 15), true),
    HabitInstance(DateTime(2021, 6, 16), true),
    HabitInstance(DateTime(2021, 6, 17), true),
  ];

  final sub = instances.sublist(0, 2);

  debugPrint('sub: ${sub.toString()}');
  debugPrint('sub: ${sub.length.toString()}');
  int bestStreakDay = 0;
  int currentStreakDay = 0;

  for (HabitInstance i in instances) {
    if (i.completed) {
      currentStreakDay++;
    } else {
      if (currentStreakDay > bestStreakDay) {
        bestStreakDay = currentStreakDay;
      }

      currentStreakDay = 0;
    }
  }

  if (currentStreakDay > bestStreakDay) {
    bestStreakDay = currentStreakDay;
  }
  return bestStreakDay;
}

class HabitInstance extends Equatable {
  const HabitInstance(this.date, this.completed);
  final DateTime date;
  final bool completed;

  @override
  List<Object?> get props => [date, completed];
}

class Streak extends Equatable {
  const Streak(this.start, this.end, this.length);
  final DateTime start;
  final DateTime end;
  final int length;

  @override
  List<Object?> get props => [start, end, length];
}

List<Map<String, Streak>>? getBestStreakOfHabit2(HabitEntity habit) {
  instances.sort((a, b) => a.date.compareTo(b.date));

  // List<Map<String, Streak>> result = [];
  // int currentStreakDay = 0;
  // DateTime currentStreakStart = instances.first.date;

  // for (int i = 0; i < instances.length; i++) {
  //   final HabitInstance instance = instances[i];
  //   final bool isLastInstance = i == instances.length - 1;
  //   final bool isStreakContinued = instance.completed;

  //   if (isStreakContinued) {
  //     currentStreakDay++;
  //   } else {
  //     if (currentStreakDay > 0) {
  //       final DateTime currentStreakEnd = instances[i - 1].date;
  //       final Streak streak = Streak(currentStreakStart, currentStreakEnd, currentStreakDay);

  //       result.add({'streak': streak.toMap()});
  //       currentStreakDay = 0;
  //     }
  //   }

  //   if (isLastInstance && currentStreakDay > 0) {
  //     final DateTime currentStreakEnd = instance.date;
  //     final Streak streak = Streak(currentStreakStart, currentStreakEnd, currentStreakDay);

  //     result.add({'streak': streak.toMap()});
  //   }

  //   if (!isStreakContinued) {
  //     currentStreakStart = isLastInstance ? instance.date : instances[i + 1].date;
  //   }
  // }

  return null;
}

final List<HabitInstance> instances = <HabitInstance>[
  HabitInstance(DateTime(2021, 6, 1), true),
  HabitInstance(DateTime(2021, 6, 2), false),
  HabitInstance(DateTime(2021, 6, 3), false),
  HabitInstance(DateTime(2021, 6, 4), true),
  HabitInstance(DateTime(2021, 6, 5), true),
  HabitInstance(DateTime(2021, 6, 6), true),
  HabitInstance(DateTime(2021, 6, 7), true),
  HabitInstance(DateTime(2021, 6, 8), true),
  HabitInstance(DateTime(2021, 6, 9), true),
  HabitInstance(DateTime(2021, 6, 10), true),
  HabitInstance(DateTime(2021, 6, 11), true),
  HabitInstance(DateTime(2021, 6, 12), true),
  HabitInstance(DateTime(2021, 6, 13), true),
  HabitInstance(DateTime(2021, 6, 14), true),
  HabitInstance(DateTime(2021, 6, 15), true),
  HabitInstance(DateTime(2021, 6, 16), true),
  HabitInstance(DateTime(2021, 6, 17), true),
];
