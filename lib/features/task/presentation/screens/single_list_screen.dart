import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:memo_planner/features/task/data/models/task_list_model.dart';
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart';
import 'package:memo_planner/features/task/domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../../habit/presentation/components/detail/member_item.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_list_entity.dart';
import '../components/dialog.dart';
import '../components/form_add_task.dart';

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
          final taskList = TaskListModel.fromMap(map);
          return Scaffold(
            drawer: const AppNavigationDrawer(),
            appBar: _buildAppBar(context, taskList),
            floatingActionButton: FloatingActionButton(
              // handleAdd
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => AddTaskModal(lid),
              ),
              child: const Icon(Icons.add),
            ),
            body: StreamBuilder(
              stream: di<TaskRepository>().getAllTaskStream(lid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    final tasks = docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
                    return _build(context, tasks);
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
              openMemberModal(context, taskList.lid!, TextEditingController());
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

  Widget _build(BuildContext context, List<TaskEntity> tasks) => ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.taskName!),
            subtitle: task.description != null ? Text(task.description!) : null,
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          );
        },
      );

  Future<void> openMemberModal(BuildContext context, String lid, TextEditingController controller) {
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
                Navigator.of(context).pop(); // pop to task-lists screen
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
                            ElevatedButton(
                              onPressed: () {
                                showMyDialogToAddMember(
                                  context,
                                  controller: controller,
                                  onConfirm: () async {
                                    // NOTE: need refactor
                                    di<TaskListRepository>().addMember(taskList.lid!, controller.text.trim());
                                  },
                                );
                              },
                              child: const Text('Add Member'),
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
}



// Future<void> showSheetForAddTask(BuildContext context) async => showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
//       ),
//       builder: (context) => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text('Add'),
//                 ),
//               ],
//             ),
//             TextField(
//               autofocus: true,
//               onTap: () {},
//               decoration: const InputDecoration(
//                 hintText: 'Add New Task',
//                 suffixIcon: Icon(Icons.task),
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Row(
//               children: [
//                 _buildDueDateDropdown(context),
//                 TextButton.icon(
//                   onPressed: () {
//                     // show a drop down menu
//                     // _buildDueDateDropdown();
//                     _buildDueDateDropdown(context);
//                   },
//                   icon: const Icon(Icons.calendar_today),
//                   label: const Text('Set Due Date'),
//                 ),
//                 const SizedBox(width: 8.0),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text('Tomorrow'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );

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
