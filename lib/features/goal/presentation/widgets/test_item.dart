import 'package:flutter/material.dart';

class TestItem extends StatelessWidget {
  const TestItem({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.blueGrey[200],
      child: Text('Item $index'),
    );
  }
}
