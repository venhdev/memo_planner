import 'package:flutter/material.dart';

import '../../domain/entities/target_entity.dart';
import 'target_item.dart';

class TargetList extends StatelessWidget {
  const TargetList(this.targetEntities, {super.key});

  final List<TargetEntity> targetEntities;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: targetEntities.length,
      itemBuilder: (context, index) {
        return TargetItem(targetEntities[index]);
      },
    );
  }
}
