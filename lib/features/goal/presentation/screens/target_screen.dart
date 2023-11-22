import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12.0),
            TargetList(),
            SizedBox(height: 72.0),
          ],
        ),
      ),
    );
  }
}
