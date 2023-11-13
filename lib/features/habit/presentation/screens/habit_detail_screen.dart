import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/usecase/get_top_streak.dart';
import '../widgets/widgets.dart';

class HabitDetailScreen extends StatefulWidget {
  const HabitDetailScreen({
    super.key,
    required this.hid,
  });

  final String hid;

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('HabitDetailScreen: build');
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: di<GetTopStreakUC>()(widget.hid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (failure) => MessageScreen(message: failure.message),
                (streak) => buildBody(streak),
              );
            } else if (snapshot.hasError) {
              return MessageScreen(message: snapshot.error.toString());
            } else {
              return const MessageScreen(
                  message: 'Some thing went wrong [e03]');
            }
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }

  Widget buildBody(StreakEntity s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${s.habit.summary}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            IconButton(
                onPressed: () => context.go('/habit/edit-habit/${s.habit.hid}'),
                icon: const Icon(Icons.edit)),
          ],
        ),
        const SizedBox(height: 24),
        Builder(builder: (context) {
          if (s.streaks.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CalendarStreak(dateRange: s.getDateRange),
                const SizedBox(height: 24),
                const Text(
                  'Top 3 Streak',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                BestStreak(streaks: s.streaks),
              ],
            );
          } else {
            return const MessageScreen(message: 'No Data');
          }
        }),
      ],
    );
  }
}
