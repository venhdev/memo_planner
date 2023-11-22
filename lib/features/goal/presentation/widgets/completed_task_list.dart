import 'package:flutter/material.dart';

class CompletedTaskList extends StatelessWidget {
  const CompletedTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return const Placeholder();
      },
    );
  }
}
