
import 'package:flutter/material.dart';

import '../../../../../core/constants/enum.dart';

class TargetEditScreen extends StatelessWidget {
  const TargetEditScreen({
    super.key,
    this.type = EditType.add,
  });

  final EditType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == EditType.add ? 'Add Target' : 'Edit Target'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Placeholder()
        ),
      ),
    );
  }
}
