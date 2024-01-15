import 'package:flutter/material.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/task_list_model.dart';
import '../../domain/entities/myday_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_list_repository.dart';
import '../../domain/repository/task_repository.dart';
import '../screens/task_detail_screen.dart';
import 'assigned_members.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task, this.showListName = false, required this.currentUID});

  final TaskEntity task;
  final bool showListName;
  final String currentUID;

  ({bool isMyDay, bool isKeep}) getMyDayRecord(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      final map = snapshot.data?.data();
      if (map == null) {
        return (isMyDay: false, isKeep: false);
      } else {
        return (isMyDay: true, isKeep: map['keep']);
      }
    } else {
      return (isMyDay: false, isKeep: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: di<TaskRepository>().getOneMyDayStream(currentUID, task.tid!),
        builder: (context, snapshot) {
          return Dismissible(
            key: Key(task.tid!),
            dismissThresholds: const {DismissDirection.startToEnd: 0.3, DismissDirection.endToStart: 0.3},
            background: dismissBackGround(snapshot),
            secondaryBackground: deleteBackGround(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                getMyDayRecord(snapshot).isMyDay
                    ? await di<TaskRepository>()
                        .removeFromMyDay(currentUID, MyDayEntity(lid: task.lid!, tid: task.tid!, created: getToday()))
                        .then((value) => value.fold(
                              (l) => showMySnackbar(context, message: l.message),
                              (r) => showMySnackbar(context, message: 'Removed from MyDay'),
                            ))
                    : await di<TaskRepository>()
                        .addToMyDay(currentUID, MyDayEntity(lid: task.lid!, tid: task.tid!, created: getToday()))
                        .then(
                          (value) => value.fold(
                            (l) => showMySnackbar(context, message: l.message),
                            (r) => showMySnackbar(context, message: 'Added to MyDay'),
                          ),
                        );

                // ? Just call Add to MyDay Function, if true it will dismiss the item
                return false;
              } else if (direction == DismissDirection.endToStart) {
                return showMyDialogToConfirm(
                  context,
                  title: 'Delete Task?',
                  content: 'Are you sure you want to delete this task?',
                );
              }
              return null;
            },
            onDismissed: (direction) async {
              direction == DismissDirection.endToStart ? await di<TaskRepository>().deleteTask(task) : null;
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              child: ListTile(
                onTap: () => openTaskDetailScreen(context, task),
                leading: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Checkbox(
                      value: task.completed,
                      onChanged: (value) => handleToggleTask(task, value!),
                    ),
                    buildMyDayIcon(snapshot),
                  ],
                ),
                title: Text(
                  task.taskName!,
                  style: TextStyle(
                    decoration: task.completed! ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: moreTaskInfo(task, currentUID),
                trailing: assignedInfo(task),
              ),
            ),
          );
        });
  }

  Widget? assignedInfo(TaskEntity task) => (task.assignedMembers!.isNotEmpty)
      ? SizedBox(
          width: 64.0,
          height: 28.0,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              // How many members are assigned to this task
              if (task.assignedMembers!.isNotEmpty) Text('${task.assignedMembers!.length}'),
              AssignedMembersList(assignedMembers: task.assignedMembers!, height: 28.0),
            ],
          ),
        )
      : null;

  Widget? moreTaskInfo(TaskEntity task, String email) {
    if (task.dueDate == null &&
        task.priority == null &&
        task.description!.trim() == '' &&
        (task.reminders == null
            ? true
            : task.reminders!.scheduledTime!.isBefore(DateTime.now())
                ? true
                : false) &&
        !showListName) return null;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Priority Label
        if (task.priority != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: AppColors.priorityColor(task.priority!),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              AppConstant.priorityLabel(task.priority!),
              style: const TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
          const SizedBox(width: 8.0),
        ],

        // Due Date
        if (task.dueDate != null) ...[
          Text(
            convertDateTimeToString(task.dueDate!, pattern: 'dd-MM'),
            style: TextStyle(
              color: task.dueDate!.isBefore(DateTime.now()) ? Colors.red : Colors.black,
            ),
          ),
          const SizedBox(width: 8.0),
        ],

        // Has Reminder
        if (task.reminders != null)
          if (task.reminders!.scheduledTime!.isAfter(DateTime.now())) ...[
            const Icon(
              Icons.alarm,
              size: 16.0,
            ),
            const SizedBox(width: 8.0),
          ],

        // Has Description
        if (task.description!.trim() != '') ...[
          const Icon(
            Icons.description,
            size: 16.0,
          ),
          const SizedBox(width: 8.0),
        ],

        if (showListName) ...[
          const SizedBox(width: 8.0),
          StreamBuilder(
              stream: di<TaskListRepository>().getOneTaskListStream(task.lid!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final map = snapshot.data?.data();
                  if (map == null) {
                    return const SizedBox.shrink();
                  }
                  final taskList = TaskListModel.fromMap(map);
                  return Row(
                    children: [
                      Icon(taskList.iconData),
                      Text(taskList.listName!),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })
        ]
      ],
    );
  }

  Widget buildMyDayIcon(AsyncSnapshot snapshot) => Builder(
        builder: (context) {
          final record = getMyDayRecord(snapshot);
          return record.isMyDay
              ? Icon(Icons.wb_sunny, color: record.isKeep ? Colors.amber : AppColors.kActiveTextColor)
              : const SizedBox.shrink();
        },
      );

  void openTaskDetailScreen(BuildContext context, TaskEntity task) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailScreen(
        task: task,
        currentUID: currentUID,
      ),
    );
  }

  void handleToggleTask(TaskEntity task, bool value) async {
    di<TaskRepository>().toggleTask(task.tid!, task.lid!, value);
  }

  Widget dismissBackGround(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      final map = snapshot.data?.data();
      if (map == null) {
        return Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          child: const ListTile(
            title: Text(
              'Add To MyDay',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.wb_sunny, color: Colors.amber),
          ),
        );
      } else {
        return Container(
          color: Colors.red.shade400,
          alignment: Alignment.centerLeft,
          child: const ListTile(
            title: Text(
              'Remove From MyDay',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.wb_sunny_outlined, color: Colors.white),
          ),
        );
      }
    } else {
      return const LoadingScreen();
    }
  }

  Container deleteBackGround() {
    return Container(
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
    );
  }
}
