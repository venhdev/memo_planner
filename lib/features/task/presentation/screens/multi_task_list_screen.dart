import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/utils/helpers.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../domain/repository/task_list_repository.dart';
import '../../domain/repository/task_repository.dart';
import '../components/task_item.dart';
import '../components/task_list_item.dart';

enum MultiListMenuItem { hide }

class MultiTaskListScreen extends StatefulWidget {
  const MultiTaskListScreen({super.key, required this.type});

  final String type;

  @override
  State<MultiTaskListScreen> createState() => _MultiTaskListScreenState();
}

class _MultiTaskListScreenState extends State<MultiTaskListScreen> {
  bool hideDone = false;
  bool isEmpty = false;
  // a list that store state of each task list: true if empty, false if contains task
  // >> if all task list is empty, show empty screen
  var listStateEmpty = <bool?>[];

  void _checkEmpty(int index) {
    listStateEmpty[index] = true;
    if (listStateEmpty.every((element) => element == true)) {
      // delay to show empty screen, without delay, it goes error
      Future.delayed(Duration.zero, () {
        setState(() {
          isEmpty = true;
        });
      });
    }
  }

  void _checkNotEmpty(int index) => listStateEmpty[index] = false;

  @override
  Widget build(BuildContext context) {
    log('render [MultiTaskListScreen] with type: ${widget.type}');
    if (isEmpty) return _buildEmpty();
    return StreamBuilder(
      stream: di<TaskListRepository>().getAllTaskListStreamOfUser(
        context.read<AuthBloc>().state.user!.uid!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final maps = snapshot.data!.docs.map((e) => e.data()).toList();
            if (maps.isEmpty) return _buildEmpty(); // user has no task list

            final taskLists = maps.map((e) => TaskListModel.fromMap(e)).toList();
            listStateEmpty = List.generate(taskLists.length, (index) => null);

            return Scaffold(
              appBar: _buildAppBar(),
              body: ListView.builder(
                itemCount: taskLists.length,
                itemBuilder: (context, index) => TaskListFilter(
                  index: index,
                  taskList: taskLists[index],
                  type: widget.type,
                  hideDone: hideDone,
                  onEmpty: (index) {
                    _checkEmpty(index);
                  },
                  onNotEmpty: (index) {
                    _checkNotEmpty(index);
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MessageScreen(message: snapshot.error.toString());
          } else {
            return const LoadingScreen();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          log('render ');
          return const LoadingScreen();
        } else {
          return const MessageScreen(message: 'Error [MultiTaskListScreen]');
        }
      },
    );
  }

  Scaffold _buildEmpty() {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(children: [
        EmptyScreen(
          richText: 'You have no task in ',
          spanChildren: [
            TextSpan(
              text: widget.type.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          // refresh page
          onPressed: () => setState(() {
            isEmpty = false;
          }),
          actionText: 'Click here to refresh',
        )
      ]),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: Text(widget.type.toUpperCase()),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          // PopupMenu
          if (widget.type != GroupType.done.name)
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
    required this.index,
    required this.taskList,
    required this.type,
    required this.hideDone,
    required this.onEmpty,
    required this.onNotEmpty,
  });
  final int index;
  final TaskListModel taskList;
  final String type;
  final bool hideDone;

  final ValueChanged<int> onEmpty;
  final ValueChanged<int> onNotEmpty;

  @override
  State<TaskListFilter> createState() => _TaskListFilterState();
}

class _TaskListFilterState extends State<TaskListFilter> {
  // init state
  bool isOpen = true;
  late SQuerySnapshot stream;
  late String currentUserEmail;

  @override
  void initState() {
    super.initState();
    stream = di<TaskRepository>().getAllTaskStream(widget.taskList.lid!);
    currentUserEmail = context.read<AuthBloc>().state.user!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          // Filter by hideDone
          if (widget.hideDone) {
            docs.removeWhere((task) => task.data()['completed'] == true);
          }
          // Filter by type
          filter(docs, context);
          if (docs.isEmpty) {
            widget.onEmpty(widget.index);
            return const SizedBox.shrink();
          } else {
            widget.onNotEmpty(widget.index);
          }
          // return const MessageScreen(
          //   message: 'There is no task',
          //   enableBack: false,
          // );
          final tasks = docs.map((doc) => TaskModel.fromMap(doc.data())).toList();

          return Column(
            children: [
              TaskListItem(
                false,
                taskList: widget.taskList,
                showCount: false,
                showSuffixIcon: true,
                onTextTap: () {
                  // context.go('/task-list/single-list/${widget.taskList.lid}');
                  // pop out of multi-list screen and then go to myday screen
                  context.pop();
                  context.go('/single-list/${widget.taskList.lid}');
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: tasks[index],
                      currentUserUID: currentUserEmail,
                    );
                  },
                )
              ]
            ],
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void filter(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, BuildContext context) {
    switch (widget.type) {
      case 'assign':
        docs.removeWhere(
          (task) {
            final currentUserUID = context.read<AuthBloc>().state.user!.uid!;
            final assignedMembers = task.data()['assignedMembers'] as List<dynamic>;
            if (assignedMembers.contains(currentUserUID)) return false;
            return true;
          },
        );
        break;
      case 'all':
        break;
      case 'scheduled':
        docs.removeWhere((task) => task.data()['dueDate'] == null);
        break;
      case 'done':
        docs.removeWhere((task) => task.data()['completed'] == false);
        break;
      case 'today':
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
  }
}
