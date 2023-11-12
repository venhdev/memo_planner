import 'package:flutter/material.dart';

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
                (s) => buildBody(s),
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
    if (s.streaks.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '3 Best Streaks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          CalendarStreak(dateRange: s.getDateRange),
          const SizedBox(height: 20),
          BestStreak(streaks: s.streaks),
        ],
      );
    } else {
      return const MessageScreen(message: 'No Data');
    }
  }
}
