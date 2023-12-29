import 'package:equatable/equatable.dart';

import 'habit_entity.dart';
import 'streak_instance_entity.dart';

class StreakEntity extends Equatable {
  const StreakEntity({
    required this.habit,
    required this.streaks,
  });

  final HabitEntity habit;
  final List<StreakInstanceEntity> streaks;

  List<DateTime> get getDateRange {
    final List<DateTime> dateRange = [];
    for (var streak in streaks) {
      dateRange.add(streak.start);
      final int numberOfDays = streak.end.difference(streak.start).inDays;
      // Iterate over the range of dates and add them to the list
      for (int i = 1; i <= numberOfDays; i++) {
        final DateTime currentDate = streak.start.add(Duration(days: i));
        dateRange.add(currentDate);
      }
    }
    return dateRange;
  }

  @override
  List<Object?> get props => [habit, streaks];
}
