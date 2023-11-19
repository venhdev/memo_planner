// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/widgets.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool showCompletedTask = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TaskList(),
            _buildShowCompleted(),
            Visibility(
              visible: showCompletedTask,
              child: CompletedTaskList(),
            ),
            SizedBox(height: 72),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/goal/task/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildShowCompleted() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showCompletedTask = !showCompletedTask;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completed tasks',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(
                showCompletedTask ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
