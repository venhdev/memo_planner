import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/enum.dart';
import '../../domain/entities/task_list_entity.dart';

// Every [TaskGroupItem] item is [TaskListEntity]

class TaskGroupItem extends StatelessWidget {
  const TaskGroupItem(
    this.isDefault, {
    super.key,
    this.taskList,
    this.listName,
    this.codePoint,
    this.taskCount,
    this.iconColor,
    required this.onTap,
  });
  // if (false) -> use taskList to show
  final bool isDefault;
  final TaskListEntity? taskList;

  // else (true) -> use below info to show
  final String? listName;
  final int? codePoint;
  final int? taskCount;
  final Color? iconColor;

  final VoidCallback onTap;

  static List<TaskGroupItem> defaultItems(BuildContext context) => [
        TaskGroupItem.today(context),
        TaskGroupItem.allTasks(context),
        TaskGroupItem.scheduled(context),
        TaskGroupItem.done(context),
      ];

  factory TaskGroupItem.today(BuildContext context) => TaskGroupItem(
        true,
        listName: 'Today',
        codePoint: Icons.today.codePoint,
        iconColor: Colors.blue,
        onTap: () {
          context.go('/task-list/multi-list', extra: GroupType.today);
        },
      );

  factory TaskGroupItem.scheduled(BuildContext context) => TaskGroupItem(
        true,
        listName: 'Scheduled',
        codePoint: Icons.pending_actions.codePoint,
        iconColor: Colors.orange,
        onTap: () {
          context.go('/task-list/multi-list', extra: GroupType.scheduled);
        },
      );

  factory TaskGroupItem.allTasks(BuildContext context) => TaskGroupItem(
        true,
        listName: 'All',
        codePoint: Icons.list.codePoint,
        iconColor: Colors.red,
        onTap: () {
          context.go('/task-list/multi-list', extra: GroupType.all);
        },
      );
  factory TaskGroupItem.done(BuildContext context) => TaskGroupItem(
        true,
        listName: 'Done',
        codePoint: Icons.check_circle.codePoint,
        iconColor: Colors.green,
        onTap: () {
          context.go('/task-list/multi-list', extra: GroupType.done);
        },
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Icon(
                color: iconColor ?? Colors.black,
                isDefault
                    ? IconData(
                        codePoint!,
                        fontFamily: 'MaterialIcons',
                      )
                    : taskList!.iconData!,
              ),
              const SizedBox(width: 8.0),
              Text(
                isDefault ? listName! : taskList!.listName!,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
    );
  }
}
