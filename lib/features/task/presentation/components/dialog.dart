import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import '../../../../config/theme/text_style.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/my_snackbar.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../domain/entities/task_list_entity.dart';
import '../../domain/repository/task_list_repository.dart';

Future<void> showAddOrEditForm(
  BuildContext context, {
  required TextEditingController controller,
  bool isAdd = true, // check if use this dialog for add or edit
  TaskListEntity? taskList,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      return AddTaskListDialog(controller: controller, isAdd: isAdd, taskList: taskList);
    },
  );
}

class AddTaskListDialog extends StatefulWidget {
  const AddTaskListDialog({super.key, required this.controller, required this.isAdd, this.taskList});

  final TextEditingController controller;
  final bool isAdd;
  final TaskListEntity? taskList;

  @override
  State<AddTaskListDialog> createState() => _AddTaskListDialogState();
}

class _AddTaskListDialogState extends State<AddTaskListDialog> {
  late Icon icon;
  @override
  void initState() {
    super.initState();
    if (!widget.isAdd) {
      icon = Icon(widget.taskList!.iconData);
    } else {
      icon = const Icon(Icons.list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isAdd ? 'New List' : 'Rename List',
        style: const TextStyle(fontSize: 16.0),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: TextField(
        controller: widget.controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Enter your list name',
          border: const OutlineInputBorder(),
          prefixIcon: IconButton(
            onPressed: () async {
              final iconData = await FlutterIconPicker.showIconPicker(context, iconPackModes: [IconPack.cupertino]);
              if (iconData != null) {
                setState(() {
                  icon = Icon(iconData);
                });
              }
            },
            icon: icon,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'CANCEL',
            style: MyTextStyle.redTextDialog,
          ),
        ),
        TextButton(
          onPressed: () async {
            if (widget.controller.text.isNotEmpty) {
              final currentUser = context.read<AuthBloc>().state.user;
              //! handle Add
              widget.isAdd
                  ? await di<TaskListRepository>()
                      .addTaskList(
                      TaskListEntity(
                        lid: null,
                        gid: null,
                        listName: widget.controller.text,
                        iconData: icon.icon,
                        creator: currentUser,
                        members: [currentUser!.email!],
                      ),
                    )
                      .then((value) {
                      value.fold(
                        (l) => showMySnackbar(
                          context,
                          message: l.message,
                          backgroundColor: Colors.red,
                        ),
                        (r) {
                          Navigator.of(context).pop();
                          showMySnackbar(
                            context,
                            message: 'You have created a new list',
                            backgroundColor: Colors.green,
                          );
                        },
                      );
                    })
                  //! handle Edit
                  : await di<TaskListRepository>()
                      .editTaskList(
                      widget.taskList!.copyWith(
                        listName: widget.controller.text,
                        iconData: icon.icon,
                      ),
                    )
                      .then(
                      (value) {
                        value.fold(
                          (l) => showMySnackbar(
                            context,
                            message: l.message,
                            backgroundColor: Colors.red,
                          ),
                          (r) {
                            Navigator.of(context).pop();
                            showMySnackbar(
                              context,
                              message: 'You have renamed the list',
                              backgroundColor: Colors.green,
                            );
                          },
                        );
                      },
                    );

              widget.controller.clear();
            }
          },
          child: Text(
            widget.isAdd ? 'CREATE' : 'SAVE',
            style: MyTextStyle.blueTextDialog,
          ),
        ),
      ],
    );
  }
}
