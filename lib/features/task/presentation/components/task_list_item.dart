import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/widgets.dart';
import '../../domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/constants/enum.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../domain/entities/task_list_entity.dart';

// Every [TaskGroupItem] item is [TaskListEntity]

String _route = '/multi-list';

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
    this.onSuffixIconTap,
    this.onTextTap,
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
  final VoidCallback? onSuffixIconTap;
  final VoidCallback? onTextTap;

  factory TaskListItem.myday(BuildContext context) => TaskListItem(
        true,
        listName: 'MyDay',
        codePoint: Icons.today.codePoint,
        iconColor: Colors.amber,
        onTap: () {
          final currentUserUID = context.read<AuthBloc>().state.user!.uid!;
          context.go('/myday', extra: currentUserUID);
        },
      );

  factory TaskListItem.today(BuildContext context) => TaskListItem(
        true,
        listName: 'Today',
        codePoint: Icons.today.codePoint,
        iconColor: Colors.red,
        onTap: () {
          context.go(_route, extra: GroupType.today.name);
        },
      );

  factory TaskListItem.scheduled(BuildContext context) => TaskListItem(
        true,
        listName: 'Scheduled',
        codePoint: Icons.pending_actions.codePoint,
        iconColor: Colors.green,
        onTap: () {
          context.go(_route, extra: GroupType.scheduled.name);
        },
      );

  factory TaskListItem.allTasks(BuildContext context) => TaskListItem(
        true,
        listName: 'All',
        codePoint: Icons.list.codePoint,
        iconColor: Colors.blue,
        onTap: () {
          context.go(_route, extra: GroupType.all.name);
        },
      );
  factory TaskListItem.done(BuildContext context) => TaskListItem(
        true,
        listName: 'Done',
        codePoint: Icons.check_circle.codePoint,
        iconColor: Colors.green,
        onTap: () {
          context.go(_route, extra: GroupType.done.name);
        },
      );

  factory TaskListItem.assignToMe(BuildContext context) => TaskListItem(
        true,
        listName: 'Assign To Me',
        codePoint: Icons.person.codePoint,
        iconColor: Colors.blue,
        onTap: () {
          context.go(_route, extra: GroupType.assign.name);
        },
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: margin,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(
              isDefault
                  ? IconData(
                      codePoint!,
                      fontFamily: 'MaterialIcons',
                    )
                  : taskList!.iconData!,
              color: iconColor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: GestureDetector(
                onTap: onTextTap,
                child: Text(
                  isDefault ? listName! : taskList!.listName!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
              ),
            ),
            // const Spacer(),

            // count item
            if (!isDefault && showCount)
              StreamBuilder(
                stream: taskList != null ? di<TaskRepository>().getAllTaskStream(taskList!.lid!) : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    // filter out completed task
                    final docsLength = docs.where((doc) => doc.data()['completed'] == false).length;
                    return Text(
                      docsLength.toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const LoadingScreen();
                  }
                },
              ),

            if (showSuffixIcon) IconButton(onPressed: onSuffixIconTap, icon: suffixIcon),
          ],
        ),
      ),
    );
  }
}
