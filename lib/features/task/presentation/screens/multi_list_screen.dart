import 'package:flutter/material.dart';

import '../../../../core/constants/enum.dart';

/// Show only the tasks of a single list
class MultiTaskListScreen extends StatelessWidget {
  const MultiTaskListScreen({super.key, required this.type});

  final GroupType type;

  @override //stream builder + type => filter
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.name.toUpperCase()),
      ),
      body: const Placeholder(),
    );
  }
}
