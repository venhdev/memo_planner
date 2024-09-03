import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/widgets.dart';
import '../../data/models/task_list_model.dart';
import '../../domain/repository/task_list_repository.dart';

class MemberModal extends StatelessWidget {
  const MemberModal({
    super.key,
    required this.lid,
  });

  final String lid;

  @override
  Widget build(BuildContext context) {
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
                _buildHeaderBar(context, taskList),
                _buildListMember(context, taskList),
              ],
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  Expanded _buildListMember(BuildContext context, TaskListModel taskList) {
    final currentUser = context.read<AuthBloc>().state.user;

    ActionPane? getAction(String currentUID, String creatorUID, String renderUID) {
      if (currentUID == creatorUID && creatorUID != renderUID) {
        // current user is creator >> can remove member
        return ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                showMyDialogToConfirm(
                  context: context,
                  title: 'Remove member',
                  content:
                      'Are you sure to remove this member? This action will remove unassign the member from all task.',
                  onConfirm: () => di<TaskListRepository>().removeMember(lid, renderUID),
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.remove_circle_outline_outlined,
              label: 'Remove',
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            )
          ],
        );
      } else if (currentUID != creatorUID && currentUID == renderUID) {
        // current user is member >> can leave list
        return ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                showMyDialogToConfirm(
                    context: context,
                    title: 'Leave List',
                    content: 'Are you sure to leave this list? This action will remove unassign you from all task.',
                    onConfirm: () {
                      di<TaskListRepository>().removeMember(lid, renderUID); // remove self
                      context.go('/');
                    });
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.output,
              label: 'Leave',
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            )
          ],
        );
      }
      return null;
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: taskList.members?.length,
        itemBuilder: (BuildContext context, int index) {
          final renderMember = taskList.members![index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Slidable(
              key: Key(renderMember.uid),
              endActionPane: getAction(currentUser!.uid!, taskList.creator!.uid!, renderMember.uid),
              child: MemberItem(
                lid: taskList.lid!,
                renderMember: taskList.members![index],
                ownerUID: taskList.creator!.uid!,
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildHeaderBar(BuildContext context, TaskListModel taskList) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('List Members', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            label: const Text('Add Member'),
            icon: const Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
    );
  }
}
