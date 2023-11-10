import 'package:flutter/material.dart';
import 'package:clean_calendar/clean_calendar.dart';

import '../../../../config/dependency_injection.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/usecase/get_top_streak.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({
    super.key,
    required this.hid,
  });

  final String hid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: di<GetTopStreakUC>()(hid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final streaks = snapshot.data;
          return _buildBody(streaks!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildBody(List<StreakEntity> streaks) {
    return Column(
      children: [
        CleanCalendar(
          enableDenseViewForDates: true,
          // Setting start date of calendar.
          startDateOfCalendar: DateTime(2023, 11, 1),
          // Setting end date of calendar.
          endDateOfCalendar: DateTime(2023, 11, 29),
          datesForStreaks: streaks.map((e) => e.start).toList(),
        )
      ],
    );
  }
}
