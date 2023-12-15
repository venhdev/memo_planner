import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/config/theme/text_style.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/my_snackbar.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../domain/entities/task_list_entity.dart';
import '../../domain/repository/task_list_repository.dart';

Future<void> showDialogForAddOrEditTaskList(
  BuildContext context, {
  required TextEditingController controller,
  bool isAdd = true, // check if use this dialog for add or edit
  TaskListEntity? taskList,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          isAdd ? 'New List' : 'Rename List',
          style: const TextStyle(fontSize: 16.0),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: // text field
            TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter your list name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clear();
              Navigator.of(context).pop();
            },
            child: Text(
              'CANCEL',
              style: MyTextStyle.redTextDialog,
            ),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final currentUser = context.read<AuthenticationBloc>().state.user;
                isAdd
                    ? await di<TaskListRepository>()
                        .addTaskList(
                        TaskListEntity(
                          lid: null,
                          gid: null,
                          listName: controller.text,
                          iconData: Icons.list,
                          creator: currentUser,
                          members: [currentUser!.email!],
                        ),
                      )
                        .then((value) {
                        showMySnackbarWithAwesome(
                          context,
                          title: 'List created',
                          message: 'You have created a new list',
                          contentType: ContentType.success,
                        );
                        Navigator.of(context).pop();
                      })
                    : await di<TaskListRepository>()
                        .editTaskList(
                        taskList!.copyWith(listName: controller.text),
                      )
                        .then(
                        (value) {
                          showMySnackbarWithAwesome(
                            context,
                            title: 'List renamed',
                            message: 'You have renamed the list',
                            contentType: ContentType.success,
                          );
                          Navigator.of(context).pop();
                        },
                      );

                controller.clear();
              }
            },
            child: Text(
              isAdd ? 'CREATE' : 'SAVE',
              style: MyTextStyle.blueTextDialog,
            ),
          ),
        ],
      );
    },
  );
}
