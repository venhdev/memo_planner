import 'package:flutter/material.dart';
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart';
import 'package:memo_planner/features/task/domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/common_screen.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import 'avatar.dart';

class DialogAssignMember extends StatelessWidget {
  const DialogAssignMember({super.key, required this.lid, required this.tid});

  final String lid;
  final String tid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: di<TaskListRepository>().getOneTaskListStream(lid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final map = snapshot.data?.data()!;
            if (map == null) return const MessageScreen(message: 'Task List has been deleted!');
            final taskList = TaskListModel.fromMap(map);
            return StreamBuilder(
              stream: di<TaskRepository>().getOneTaskStream(lid, tid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final map = snapshot.data?.data()!;
                    if (map == null) return const MessageScreen(message: 'Task has been deleted!');
                    final task = TaskModel.fromMap(map);
                    return _build(taskList, task);
                  } else if (snapshot.hasError) {
                    return MessageScreen(message: snapshot.error.toString());
                  } else {
                    return const LoadingScreen();
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const MessageScreen(message: 'No data');
                } else {
                  return const MessageScreen(message: 'Error [DialogAssignMember]');
                }
              },
            );
          } else if (snapshot.hasError) {
            return MessageScreen(message: snapshot.error.toString());
          } else {
            return const LoadingScreen();
          }
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  Widget _build(TaskListModel taskList, TaskEntity task) {
    //? always have 1 member in taskList (creator)
    return SimpleDialog(
      children: [
        const Text(
          'Select Member',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        for (final memberEmail in taskList.members!)
          ListTile(
            onTap: () {
              // assign or unassign task
              if (!task.assignedMembers!.contains(memberEmail)) {
                di<TaskRepository>().assignTask(lid, tid, memberEmail);
              } else {
                di<TaskRepository>().unassignTask(lid, tid, memberEmail);
              }
            },
            title: Text(memberEmail),
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Avatar(memberEmail: memberEmail),
            ),
            trailing: Builder(
              builder: (context) {
                if (task.assignedMembers!.contains(memberEmail)) {
                  return const Icon(Icons.check);
                } else {
                  return const Icon(Icons.add);
                }
              },
            ),
          ),
      ],
    );
  }
}
