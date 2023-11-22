import 'package:flutter/material.dart';
import 'package:memo_planner/core/widgets/message_screen.dart';

class EmptyTaskView extends StatelessWidget {
  const EmptyTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: MessageScreen(
        message: 'Every task is done',
        enableBack: false,
      ),
    );
  }
}
