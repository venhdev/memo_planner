import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../domain/entities/streak_instance_entity.dart';

class BestStreak extends StatelessWidget {
  const BestStreak({
    super.key,
    required this.streaks,
  });

  final List<StreakInstanceEntity> streaks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: streaks.length,
      itemBuilder: (context, index) => buildTopStreakItem(
        streaks[index],
        topStreakColors[index],
      ),
    );
  }
}

Widget buildTopStreakItem(StreakInstanceEntity streak, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(convertDateTimeToString(streak.start, pattern: 'dd/MM'), textAlign: TextAlign.center),
        ),
      ),
      Expanded(
        flex: 3,
        child: Container(
          height: 28,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              streak.length.toString(),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            convertDateTimeToString(streak.end, pattern: 'dd/MM'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}
