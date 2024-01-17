import 'package:flutter/material.dart';

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
  }
}
