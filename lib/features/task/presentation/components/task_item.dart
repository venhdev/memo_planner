import 'package:flutter/material.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../screens/task_detail_screen.dart';
import 'assigned_members.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});

  // final String taskName;

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
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
          di<TaskRepository>().deleteTask(task).then(
                (value) => {
                  value.fold(
                    (l) => showMySnackbar(context, message: l.message),
                    (r) => showMySnackbar(
                      context,
                      message: 'Task Deleted',
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          di<TaskRepository>().addTask(task);
                        },
                      ),
                    ),
                  )
                },
              );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
          ),
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
  }

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
    if (task.dueDate == null && task.reminders == null && task.priority == null) return null;
    return Wrap(
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
      ],
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

  void handleToggleTask(TaskEntity task, bool value) async {
    di<TaskRepository>().toggleTask(task.tid!, task.lid!, value);
  }
}
