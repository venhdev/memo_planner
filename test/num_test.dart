import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('description', () {
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
    List<int> list = [
      1,
      8,
      3,
      5,
      6,
      4,
      7,
      2,
    ];

    list.sort((a, b) => a.compareTo(b));
    instances.sort((a, b) => a.date.compareTo(b.date));

    debugPrint('list: ${list.toString()}');
    debugPrint('instances: ${instances.toString()}');
  });
}


class HabitInstance extends Equatable {
  const HabitInstance(this.date, this.completed);
  final DateTime date;
  final bool completed;

  @override
  List<Object?> get props => [date, completed];
}