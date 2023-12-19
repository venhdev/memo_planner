import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/enum.dart';
import '../../domain/entities/task_list_entity.dart';

// Every [TaskGroupItem] item is [TaskListEntity]

class TaskListItem extends StatelessWidget {
  const TaskListItem(
    this.isDefault, {
    super.key,
    required this.onTap,
    this.taskList,
    this.listName,
    this.codePoint,
    this.iconColor,
    this.showSuffixIcon = false,
    this.showCount = true,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.suffixIcon = const Icon(Icons.arrow_forward_ios),
    this.onSuffixIconPressed,
  });
  // if (false) -> use taskList to show
  final bool isDefault;
  final TaskListEntity? taskList;

  // else (true) -> use below info to show
  final String? listName;
  final int? codePoint;
  final Color? iconColor;

  final EdgeInsetsGeometry? margin;
  final bool showSuffixIcon;
  final Icon suffixIcon;
  final bool showCount;

  final VoidCallback onTap;
  final VoidCallback? onSuffixIconPressed;

  factory TaskListItem.today(BuildContext context) => TaskListItem(
        true,
        listName: 'Today',
        codePoint: Icons.today.codePoint,
        iconColor: Colors.red,
        onTap: () {
          context.go('/task-list/multi-list', extra: GroupType.today);
        },
      );

  factory TaskListItem.scheduled(BuildContext context) => TaskListItem(
        true,
        listName: 'Scheduled',
        codePoint: Icons.pending_actions.codePoint,
        iconColor: Colors.green,
        onTap: () {
          context.go('/task-list/multi-list', extra: GroupType.scheduled);
        },
      );

  factory TaskListItem.allTasks(BuildContext context) => TaskListItem(
        true,
        listName: 'All',
        codePoint: Icons.list.codePoint,
        iconColor: Colors.blue,
        onTap: () {
          context.go('/task-list/multi-list', extra: GroupType.all);
        },
      );
  factory TaskListItem.done(BuildContext context) => TaskListItem(
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
        height: MediaQuery.of(context).size.height * 0.06,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: margin,
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
            const Spacer(),

            // count item
            if (!isDefault && showCount)
              FutureBuilder(
                future: di<TaskListRepository>().countTaskList(taskList!.lid!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

            if (showSuffixIcon) IconButton(onPressed: onSuffixIconPressed, icon: suffixIcon),
          ],
        ),
      ),
    );
  }
}
