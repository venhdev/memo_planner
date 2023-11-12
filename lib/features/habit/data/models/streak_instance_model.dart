import '../../domain/entities/streak_instance_entity.dart';

class StreakModel extends StreakInstanceEntity {
  const StreakModel({
    required super.start,
    required super.end,
    required super.length,
  });

  List<DateTime> getDateRange(List<StreakInstanceEntity> streaks) {
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
}
