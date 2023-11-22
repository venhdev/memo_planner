import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/core/widgets/widgets.dart';

import '../../data/models/task_model.dart';
import '../bloc/task/task_bloc.dart';
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
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatus.loaded || state.status == TaskStatus.success) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  const AddTaskQuick(),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: state.stream!,
                    builder: (context, snapshot) {
                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: state.stream!,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.active) {
                            if (snapshot.hasData) {
                              var tasks = snapshot.data!.docs;
                              var completedTasks = tasks.where((element) => element['completed'] == true).toList();
                              var uncompletedTasks = tasks.where((element) => element['completed'] == false).toList();
                              //convert to task model
                              var completedTaskModel = completedTasks.map((e) => TaskModel.fromDocument(e.data())).toList();
                              var uncompletedTaskModel = uncompletedTasks.map((e) => TaskModel.fromDocument(e.data())).toList();

                              if (tasks.isNotEmpty) {
                                return Expanded(
                                  child: ListView(
                                    children: [
                                      TaskList(uncompletedTaskModel),
                                      _buildShowCompleted(),
                                      Visibility(
                                        visible: showCompletedTask,
                                        child: TaskList(completedTaskModel),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const MessageScreen(message: 'No task found');
                              }
                            } else if (snapshot.hasError) {
                              return MessageScreen.error(snapshot.error.toString());
                            } else {
                              return MessageScreen.error();
                            }
                          } else {
                            return const LoadingScreen();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state.status == TaskStatus.failure) {
            return MessageScreen.error(state.message);
          } else if (state.status == TaskStatus.loading) {
            return const LoadingScreen();
          } else {
            return MessageScreen.error();
          }
        },
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
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
