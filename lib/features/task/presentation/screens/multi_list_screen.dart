import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart';
import 'package:memo_planner/features/task/domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../../../core/constants/enum.dart';
import '../../../../core/utils/helpers.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../components/task_item.dart';
import '../components/task_list_item.dart';

/// Show only the tasks of a single list
class MultiTaskListScreen extends StatefulWidget {
  const MultiTaskListScreen({super.key, required this.type});

  final GroupType type;

  @override
  State<MultiTaskListScreen> createState() => _MultiTaskListScreenState();
}

class _MultiTaskListScreenState extends State<MultiTaskListScreen> {
  //stream builder + type => filter
  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthenticationBloc>().state.user!.email!;
    return StreamBuilder(
      stream: di<TaskListRepository>().getAllTaskListStreamOfUser(email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final maps = snapshot.data?.docs.map((e) => e.data()).toList();
            if (maps == null) return const MessageScreen(message: 'Has been deleted');
            if (maps.isEmpty) return const MessageScreen(message: 'No data');
            final taskLists = maps.map((e) => TaskListModel.fromMap(e)).toList();
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.type.name.toString().toUpperCase()),
              ),
              body: ListView.builder(
                itemCount: taskLists.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => TaskListFilter(taskList: taskLists[index], type: widget.type),
              ),
            );
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
          return const MessageScreen(message: 'Error [MultiTaskListScreen]');
        }
      },
    );
  }
}

class TaskListFilter extends StatefulWidget {
  const TaskListFilter({
    super.key,
    required this.taskList,
    required this.type,
  });

  final TaskListModel taskList;
  final GroupType type;

  @override
  State<TaskListFilter> createState() => _TaskListFilterState();
}

class _TaskListFilterState extends State<TaskListFilter> {
  // init state
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.red.shade50,
        child: Column(
          children: [
            TaskListItem(
              false,
              taskList: widget.taskList,
              showCount: false,
              showSuffixIcon: true,
              onSuffixIconPressed: () {
                context.go('/task-list/single-list/${widget.taskList.lid}');
              },
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
            ),
            if (isOpen) ...[
              StreamBuilder(
                stream: di<TaskRepository>().getAllTaskStream(widget.taskList.lid!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) return const MessageScreen(message: 'No data');
                      // Filter by type
                      switch (widget.type) {
                        case GroupType.all:
                          break;
                        case GroupType.scheduled:
                          docs.removeWhere((element) => element.data()['dueDate'] == null);
                          break;
                        case GroupType.done:
                          docs.removeWhere((element) => element.data()['completed'] == false);
                          break;
                        case GroupType.today:
                          final today = Timestamp.fromDate(getToday());
                          // this removeWhere more efficient than filter where ? remove directly from the list
                          docs.removeWhere(
                            (element) {
                              if (element.data()['dueDate'] == null) return true;
                              final dueDate = element.data()['dueDate'] as Timestamp;
                              return dueDate.compareTo(today) != 0;
                            },
                          );
                          break;
                        default:
                      }
                      if (docs.isEmpty) {
                        return const MessageScreen(
                          message: 'There is no task',
                          enableBack: false,
                        );
                      }
                      final tasks = docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return TaskItem(task: tasks[index]);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return MessageScreen.error(snapshot.error.toString());
                    } else {
                      return MessageScreen.error('Some thing went wrong [getAllTaskStream]');
                    }
                  } else {
                    return const LoadingScreen();
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
