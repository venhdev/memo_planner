import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/core/widgets/message_screen.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MessageScreenWithAction(
        message: 'Back to Habit Page',
        onPressed: () {
          context.go('/habit');
        },
        buttonText: 'Habit',
      ),
    );
  }
}
