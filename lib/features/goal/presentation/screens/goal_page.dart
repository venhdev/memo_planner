import 'package:flutter/material.dart';
import 'package:memo_planner/core/widgets/message_screen.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[100],
      child: const MessageScreen(message: 'Coming soon', enableBack: false),
    );
  }
}
