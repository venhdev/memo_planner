import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';

class CalendarStreak extends StatefulWidget {
  const CalendarStreak({
    super.key,
    required this.dateRange,
  });

  final List<DateTime> dateRange;

  @override
  State<CalendarStreak> createState() => _CalendarStreakState();
}

class _CalendarStreakState extends State<CalendarStreak> {
  @override
  Widget build(BuildContext context) {
    return CleanCalendar(
      datesForStreaks: widget.dateRange,
      // for (var streak in widget.streaks)
      //   for (int i = 0; i < streak.length; i++)
      //     streak.start.add(Duration(days: i)),
      currentDateProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
          datesBackgroundColor: Colors.lightGreen.shade100,
          datesBorderColor: Colors.green,
          datesTextColor: Colors.black,
        ),
      ),
      generalDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
          datesBackgroundColor: Colors.lightGreen.shade100,
          datesBorderColor: Colors.blue.shade100,
          datesTextColor: Colors.black,
        ),
      ),
      streakDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
          datesBackgroundColor: Colors.green,
          datesBorderColor: Colors.blue,
          datesTextColor: Colors.white,
        ),
      ),
      leadingTrailingDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
        ),
      ),
    );
  }
}
