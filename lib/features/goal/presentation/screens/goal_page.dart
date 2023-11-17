import 'package:flutter/material.dart';
import 'package:memo_planner/core/widgets/app_bar.dart';
import 'package:memo_planner/features/goal/presentation/widgets/test_item.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return TestItem(index: index);
              },
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
