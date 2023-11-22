import 'package:flutter/material.dart';
import 'package:memo_planner/core/widgets/message_screen.dart';

class EmptyTaskView extends StatelessWidget {
  const EmptyTaskView({super.key, this.message = 'Every task is done'});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MessageScreen(
        message: message!,
        enableBack: false,
      ),
    );
  }
}
