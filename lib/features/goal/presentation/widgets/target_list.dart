import 'package:flutter/material.dart';
import 'package:memo_planner/features/goal/presentation/widgets/target_item.dart';

class TargetList extends StatelessWidget {
  const TargetList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return const TargetItem();
      },
    );
  }
}
