import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/core/utils/helpers.dart';
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:memo_planner/features/task/data/models/task_list_model.dart';
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart';
import 'package:memo_planner/features/task/domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../../../core/constants/colors.dart';
import '../../../habit/presentation/components/detail/member_item.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_list_entity.dart';
import '../components/assigned_members.dart';
import '../components/dialog.dart';
import '../components/form_add_task.dart';
import 'task_detail_screen.dart';

enum MenuItem { rename, delete, itemThree }

/// Show only the tasks of a single list
//! Not using for default Group: Today, All Tasks, Scheduled, Done... >> use [MultiTaskListScreen] instead
class SingleTaskListScreen extends StatelessWidget {
  const SingleTaskListScreen(this.lid, {super.key});

  final String lid;

  @override
  Widget build(BuildContext context) {
    log('render SingleTaskListScreen');
    return StreamBuilder(
      stream: di<TaskListRepository>().getOneTaskListStream(lid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          final map = snapshot.data!.data();

          // > To avoid error when the list has been deleted -> ! on null value
          // > Notify user that the list has been deleted if they are still in this screen
          if (map == null) {
            return const MessageScreen(message: 'This list has been permanently deleted');
          }
          // check if user is member of this list
          //? because user may be deleted from this list by the owner while they are still in this screen
          final taskList = TaskListModel.fromMap(map);
          if (!taskList.members!.contains(context.read<AuthenticationBloc>().state.user?.email!)) {
            return const MessageScreen(message: 'You are not a member of this list');
          }
          return Scaffold(
            drawer: const AppNavigationDrawer(),
            appBar: _buildAppBar(context, taskList),
            floatingActionButton: FloatingActionButton(
              // handleAdd
              onPressed: () => openAddForm(context),
              child: const Icon(Icons.add),
            ),
            body: StreamBuilder(
              stream: di<TaskRepository>().getAllTaskStream(lid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    final tasks = docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
                    return _buildTaskListItem(context, tasks);
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
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    TaskListEntity taskList,
  ) =>
      AppBar(
        title: ListTile(
          onTap: () => handleRename(context, taskList),
          title: Text(taskList.listName!),
          leading: Icon(taskList.iconData),
        ),
        // title: GestureDetector(
        //   child: Text(taskList.listName!),
        //   onTap: () {
        //     handleRename(context, taskList);
        //   },
        // ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              openMemberModal(context, taskList.lid!);
            },
            icon: const Icon(Icons.group),
          ),

          // PopupMenu
          PopupMenuButton<MenuItem>(
            // Callback that sets the selected popup menu item.
            onSelected: (MenuItem result) {
              switch (result) {
                case MenuItem.rename:
                  handleRename(context, taskList);
                  break;
                case MenuItem.delete:
                  handleDelete(context, taskList);
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              const PopupMenuItem<MenuItem>(
                value: MenuItem.rename,
                child: Text('Rename List'),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.delete,
                child: Text('Delete List'),
              ),
            ],
          )
        ],
      );

  Widget _buildTaskListItem(BuildContext context, List<TaskEntity> tasks) => ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          // Task List Item
          return Dismissible(
            key: Key(task.tid!),
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              child: const ListTile(
                title: Text(
                  'Add To MyDay',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(Icons.wb_sunny_outlined, color: Colors.white),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const ListTile(
                title: Text(
                  'Delete',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // Add to MyDay
                // di<TaskRepository>().addToMyDay(task.tid!, task.lid!);
              } else if (direction == DismissDirection.endToStart) {
                // Delete Task
                di<TaskRepository>().deleteTask(task).then((value) => {
                      value.fold(
                        (l) => showMySnackbar(context, message: l.message),
                        (r) => showMySnackbar(context, message: 'Task Deleted'),
                      )
                    });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5))),
              ),
              child: ListTile(
                onTap: () => openTaskDetailScreen(context, task),
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (value) => handleToggleTask(task, value!),
                ),
                title: Text(
                  task.taskName!,
                  style: TextStyle(
                    decoration: task.completed! ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: moreTaskInfo(task),
                trailing: assignedInfo(task),
              ),
            ),
          ); // Task List Item End
        },
      );

  Widget? assignedInfo(TaskEntity task) => (task.assignedMembers != null)
      ? SizedBox(
          width: 64.0,
          height: 28.0,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              // How many members are assigned to this task
              if (task.assignedMembers!.isNotEmpty) Text('${task.assignedMembers!.length}'),
              AssignedMembers(task: task, height: 28.0),
            ],
          ),
        )
      : null;

  Widget? moreTaskInfo(TaskEntity task) {
    if (task.dueDate == null && task.reminders == null && task.description == null) return null;
    return Wrap(
      children: [
        // Priority Label
        if (task.priority != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: MyColors.priorityColor(task.priority!),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              MyColors.priorityLabel(task.priority!),
              style: const TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),

        // Due Date
        if (task.dueDate != null) ...[
          const SizedBox(width: 8.0),
          Text(
            'Due: ${convertDateTimeToString(task.dueDate!, pattern: 'dd-MM')}',
            style: TextStyle(
              color: task.dueDate!.isBefore(DateTime.now()) ? Colors.red : Colors.black,
            ),
          ),
        ],
        // Has Reminder
        if (task.reminders != null)
          if (task.reminders!.scheduledTime!.isAfter(DateTime.now())) ...[
            const SizedBox(width: 8.0),
            const Icon(
              Icons.alarm,
              size: 16.0,
            ),
          ],
      ],
    );
  }

  Future<void> openAddForm(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AddTaskModal(lid),
    );
  }

  void openTaskDetailScreen(BuildContext context, TaskEntity task) {
    // open Modal Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailScreen(lid: task.lid!, tid: task.tid!),
    );
  }

  Future<void> openMemberModal(BuildContext context, String lid) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder(
          stream: di<TaskListRepository>().getOneTaskListStream(lid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
              final map = snapshot.data!.data();

              // > To avoid error when the list has been deleted -> ! on null value
              // > Notify user that the list has been deleted if they are still in this screen
              if (map == null) {
                Navigator.of(context).pop(); // [SingleListScreen] is open this modal > close this modal
                return const MessageScreen(message: 'This list has been permanently deleted');
              }
              final taskList = TaskListModel.fromMap(map);

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text('List Members', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            ElevatedButton.icon(
                              label: const Text('Add Member'),
                              icon: const Icon(Icons.add),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade100,
                              ),
                              onPressed: () {
                                showMyDialogToAddMember(
                                  context,
                                  controller: TextEditingController(),
                                  onSubmitted: (value) async {
                                    // NOTE: need refactor
                                    di<TaskListRepository>().addMember(taskList.lid!, value!.trim());
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (taskList.members != null)
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: taskList.members?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MemberItem(
                                lid: taskList.lid!,
                                memberEmail: taskList.members![index],
                                ownerEmail: taskList.creator!.email!,
                              );
                            },
                          ),
                        )
                      else
                        const Text('No Member'),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return MessageScreen.error(snapshot.error.toString());
            } else {
              return MessageScreen.error(snapshot.connectionState.toString());
            }
          },
        );
      },
    );
  }

  Future<void> handleDelete(BuildContext context, TaskListEntity taskList) {
    return showMyDialogToConfirm(
      context,
      title: 'Delete List',
      content: 'This list will be deleted permanently!',
      onConfirm: () {
        Navigator.pop(context); // back to previous screen: TaskHomeScreen
        di<TaskListRepository>().deleteTaskList(taskList.lid!);
      },
    );
  }

  Future<void> handleRename(BuildContext context, TaskListEntity taskList) {
    return showAddOrEditForm(
      context,
      controller: TextEditingController(text: taskList.listName!),
      isAdd: false,
      taskList: taskList,
    );
  }

  void handleToggleTask(TaskEntity task, bool value) async {
    di<TaskRepository>().toggleTask(task.tid!, task.lid!, value);
  }
}

// enum SampleItem { itemOne, itemTwo, itemThree }

// Widget _buildDueDateDropdown(BuildContext context) {
//   SampleItem? selectedMenu;
//   return DropdownButton<SampleItem>(
//     value: selectedMenu,
//     onChanged: (SampleItem? value) {
//       selectedMenu = value;
//       // setState(() {
//       // });
//     },
//     // Callback that sets the selected popup menu item.
//     items: const <DropdownMenuItem<SampleItem>>[
//       DropdownMenuItem<SampleItem>(
//         value: SampleItem.itemOne,
//         child: Text('item one'),
//       ),
//       DropdownMenuItem<SampleItem>(
//         value: SampleItem.itemTwo,
//         child: Text('item two'),
//       ),
//       DropdownMenuItem<SampleItem>(
//         value: SampleItem.itemThree,
//         child: Text('item three'),
//       ),
//     ],
//   );
// }
