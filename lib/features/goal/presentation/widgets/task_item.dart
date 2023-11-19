// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.completed,
  });

  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // slide RTL to delete
      // slide LTR to edit
      child: Card(
        color: Colors.green[50],
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListTile(
          title: Text('Task summary', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Row(
            children: [
              //TODO change to clock icon by time
              Icon(Icons.lock_clock, color: Colors.black),
              SizedBox(width: 5),
              Text('2 days'),
            ],
          ),
          // TODO change to checkbox by status
          trailing: Checkbox(
            value: completed,
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }
}
