import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../../../core/constants/enum.dart';
import '../../../../core/entities/member.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_list_entity.dart';
import '../../domain/repository/task_list_repository.dart';
import '../../domain/repository/task_repository.dart';
import '../components/add_or_edit_task_list_dialog.dart';
import '../components/add_task_modal.dart';
import '../components/task_item.dart';

// enum TaskFilter { done }

/// Show only the tasks of a single list
//! Not using for default Group: Today, All Tasks, Scheduled, Done... >> use [MultiTaskListScreen] instead
class SingleTaskListScreen extends StatefulWidget {
  const SingleTaskListScreen(this.lid, {super.key});

  final String lid;

  @override
  State<SingleTaskListScreen> createState() => _SingleTaskListScreenState();
}

class _SingleTaskListScreenState extends State<SingleTaskListScreen> {
  bool hideDone = false;
  TaskSortOptions sortBy = TaskSortOptions.none;

  void _sortTasksWithNullsLast(List<TaskModel> tasks) {
    tasks.sort((a, b) => a.dueDate == null
        ? 1
        : b.dueDate == null
            ? -1
            : a.dueDate!.compareTo(b.dueDate!));
    // return tasks;
  }

  bool _isMemberOfList(String currentUID, List<Member> members) {
    return members.any((member) => member.uid == currentUID);
  }

  @override
  Widget build(BuildContext context) {
    log('render SingleTaskListScreen');
    return StreamBuilder(
      stream: di<TaskListRepository>().getOneTaskListStream(widget.lid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final map = snapshot.data!.data();

          // > To avoid error when the list has been deleted -> ! on null value
          // > Notify user that the list has been deleted if they are still in this screen
          if (map == null) {
            return const MessageScreen(message: 'Task Not found');
          }
          // check if user is member of this list
          //? because user may be deleted from this list by the owner while they are still in this screen
          final taskList = TaskListModel.fromMap(map);
          if (!_isMemberOfList(context.read<AuthBloc>().state.user!.uid!, taskList.members!)) {
            return const MessageScreen(message: 'You are not a member of this list');
          }
          return Scaffold(
            appBar: _buildAppBar(context, taskList),
            floatingActionButton: FloatingActionButton(
              // handleAdd
              onPressed: () => openAddTaskModal(context),
              child: const Icon(Icons.add),
            ),
            body: StreamBuilder(
              stream: di<TaskRepository>().getAllTaskStream(widget.lid, sortBy: sortBy),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    // filter out the tasks that are done
                    if (hideDone) {
                      docs.removeWhere((doc) => doc.data()['completed'] == true);
                    }
                    final tasks = docs.map((doc) => TaskModel.fromMap(doc.data())).toList();

                    if (sortBy == TaskSortOptions.dueDate) _sortTasksWithNullsLast(tasks);
                    // Wrap(
                    //       spacing: 5.0,
                    //       children: TaskFilter.values.map((TaskFilter filter) {
                    //         return FilterChip(
                    //           label: Text(filter.name),
                    //           selected: filters.contains(filter),
                    //           onSelected: (bool selected) {
                    //             setState(() {
                    //               if (selected) {
                    //                 filters.add(filter);
                    //               } else {
                    //                 filters.remove(filter);
                    //               }
                    //             });
                    //           },
                    //         );
                    //       }).toList(),
                    //     ),
                    String currentUID = context.read<AuthBloc>().state.user!.uid!;
                    return _buildListTaskItem(context, tasks, currentUID);
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
        actions: [
          // sort icon
          IconButton(
            onPressed: () async {
              await showSortOptionsAndHandleSort(context);
            },
            icon: const Icon(Icons.sort),
          ),
          // member icon
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
                case MenuItem.hide:
                  setState(() {
                    hideDone = !hideDone;
                  });
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              const PopupMenuItem<MenuItem>(
                value: MenuItem.rename,
                child: Text('Rename'),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.delete,
                child: Text('Delete List', style: TextStyle(color: Colors.red)),
              ),
              PopupMenuItem<MenuItem>(
                value: MenuItem.hide,
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

  Widget _buildListTaskItem(
    BuildContext context,
    List<TaskEntity> tasks,
    String currentUID,
  ) =>
      ListView.builder(
        itemCount: tasks.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return TaskItem(task: tasks[index], currentUID: currentUID);
        },
      );

  Future<void> openAddTaskModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskModal(widget.lid),
    );
  }

  Future<void> openMemberModal(BuildContext context, String lid) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      builder: (BuildContext context) {
        return StreamBuilder(
          stream: di<TaskListRepository>().getOneTaskListStream(lid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final map = snapshot.data!.data();

              // > To avoid error when the list has been deleted -> "operator ! on null value"
              // > Notify user that the list has been deleted if they are still in this screen
              if (map == null) {
                Navigator.of(context).pop(); // [SingleListScreen] is open this modal > close this modal
                return const MessageScreen(message: 'This list has been permanently deleted');
              }

              final taskList = TaskListModel.fromMap(map);
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  // REVIEW: need refactor
                                  di<TaskListRepository>().inviteMemberViaEmail(taskList.lid!, value!.trim());
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: taskList.members?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MemberItem(
                            lid: taskList.lid!,
                            renderMember: taskList.members![index],
                            ownerUID: taskList.creator!.uid!,
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const LoadingScreen();
            }
          },
        );
      },
    );
  }

  Future<dynamic> showSortOptionsAndHandleSort(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Sort By'),
        children: [
          RadioListTile<TaskSortOptions>(
            title: const Text('Priority'),
            value: TaskSortOptions.priority,
            groupValue: sortBy,
            onChanged: (TaskSortOptions? value) {
              setState(() {
                sortBy = value!;
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<TaskSortOptions>(
            title: const Text('Due Date'),
            value: TaskSortOptions.dueDate,
            groupValue: sortBy,
            onChanged: (TaskSortOptions? value) {
              setState(() {
                sortBy = value!;
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<TaskSortOptions>(
            title: const Text('Created Date'),
            value: TaskSortOptions.createdDate,
            groupValue: sortBy,
            onChanged: (TaskSortOptions? value) {
              setState(() {
                sortBy = value!;
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<TaskSortOptions>(
            title: const Text('Name'),
            value: TaskSortOptions.name,
            groupValue: sortBy,
            onChanged: (TaskSortOptions? value) {
              setState(() {
                sortBy = value!;
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<TaskSortOptions>(
            title: const Text('None'),
            value: TaskSortOptions.none,
            groupValue: sortBy,
            onChanged: (TaskSortOptions? value) {
              setState(() {
                sortBy = value!;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> handleDelete(BuildContext context, TaskListEntity taskList) async {
    // check if the current user is the owner of this list

    if (taskList.creator!.email != context.read<AuthBloc>().state.user?.email) {
      showMySnackbarWithAwesome(context,
          title: 'Unauthorized', message: 'You must be the owner to delete this list', contentType: ContentType.failure);
      return;
    }
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
    return showDialog(
      context: context,
      builder: (context) => AddOrEditTaskListDialog(
        controller: TextEditingController(text: taskList.listName!),
        isAdd: false,
        taskList: taskList,
      ),
    );
  }
}
