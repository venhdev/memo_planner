import 'dart:developer';

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

enum MultiListMenuItem { hide }

class MultiTaskListScreen extends StatefulWidget {
  const MultiTaskListScreen({super.key, required this.type});

  final GroupType type;

  @override
  State<MultiTaskListScreen> createState() => _MultiTaskListScreenState();
}

class _MultiTaskListScreenState extends State<MultiTaskListScreen> {
  bool hideDone = false;
  @override
  Widget build(BuildContext context) {
    log('render [MultiTaskListScreen] with type: ${widget.type.name}');
    return StreamBuilder(
      stream: di<TaskListRepository>().getAllTaskListStreamOfUser(
        context.read<AuthenticationBloc>().state.user!.email!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final maps = snapshot.data?.docs.map((e) => e.data()).toList();
            if (maps == null) return const MessageScreen(message: 'Has been deleted');
            if (maps.isEmpty) return const MessageScreen(message: 'No data');
            final taskLists = maps.map((e) => TaskListModel.fromMap(e)).toList();
            return Scaffold(
              appBar: _buildAppBar(),
              body: ListView.builder(
                itemCount: taskLists.length,
                itemBuilder: (context, index) =>
                    TaskListFilter(taskList: taskLists[index], type: widget.type, hideDone: hideDone),
              ),
            );
          } else if (snapshot.hasError) {
            return MessageScreen(message: snapshot.error.toString());
          } else {
            return const LoadingScreen();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const MessageScreen(message: 'Error [ConnectionState.none]');
        } else {
          return const MessageScreen(message: 'Error [MultiTaskListScreen]');
        }
      },
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: Text(widget.type.name.toUpperCase()),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          // PopupMenu
          if (widget.type != GroupType.done)
            PopupMenuButton<MultiListMenuItem>(
              // Callback that sets the selected popup menu item.
              onSelected: (MultiListMenuItem result) {
                switch (result) {
                  case MultiListMenuItem.hide:
                    setState(() {
                      hideDone = !hideDone;
                    });
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MultiListMenuItem>>[
                PopupMenuItem<MultiListMenuItem>(
                  value: MultiListMenuItem.hide,
                  child: Row(
                    children: [
                      Icon(hideDone ? Icons.visibility : Icons.visibility_off),
                      const SizedBox(width: 4.0),
                      Text(hideDone ? 'Show All' : 'Hide Done'),
                    ],
                  ),
                ),
              ],
            )
        ],
      );
}

class TaskListFilter extends StatefulWidget {
  const TaskListFilter({
    super.key,
    required this.taskList,
    required this.type,
    required this.hideDone,
  });

  final TaskListModel taskList;
  final GroupType type;
  final bool hideDone;

  @override
  State<TaskListFilter> createState() => _TaskListFilterState();
}

class _TaskListFilterState extends State<TaskListFilter> {
  // init state
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TaskListItem(
            false,
            taskList: widget.taskList,
            showCount: false,
            showSuffixIcon: true,
            onTextTap: () {
              context.go('/task-list/single-list/${widget.taskList.lid}');
            },
            suffixIcon: isOpen ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
            onTap: () {
              log('test tap');
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
                    // Filter by hideDone
                    if (widget.hideDone) {
                      docs.removeWhere((task) => task.data()['completed'] == true);
                    }
                    // Filter by type
                    switch (widget.type) {
                      case GroupType.assign:
                        log('here');
                        docs.removeWhere(
                          (task) {
                            final currentUserEmail = context.read<AuthenticationBloc>().state.user!.email!;
                            log('currentUserEmail: $currentUserEmail');
                            final assignedMembers = task.data()['assignedMembers'] as List<dynamic>;
                            log('assignedMembers: $assignedMembers');
                            if (assignedMembers.contains(currentUserEmail)) return false;
                            return true;
                          },
                        );
                        break;
                      case GroupType.all:
                        break;
                      case GroupType.scheduled:
                        docs.removeWhere((task) => task.data()['dueDate'] == null);
                        break;
                      case GroupType.done:
                        docs.removeWhere((task) => task.data()['completed'] == false);
                        break;
                      case GroupType.today:
                        final today = Timestamp.fromDate(getToday());
                        // this removeWhere more efficient than filter where ? remove directly from the list
                        docs.removeWhere(
                          (task) {
                            if (task.data()['dueDate'] == null) return true;
                            final dueDate = task.data()['dueDate'] as Timestamp;
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
    );
  }
}
