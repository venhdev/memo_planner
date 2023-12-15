import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/core/notification/reminder.dart';
import 'package:memo_planner/core/utils/helpers.dart';
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:memo_planner/features/task/domain/entities/task_entity.dart';
import 'package:memo_planner/features/task/domain/repository/task_repository.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/theme/text_style.dart';
import '../../../../core/components/widgets.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class AddTaskModal extends StatefulWidget {
  const AddTaskModal(this.lid, {super.key});

  final String lid;

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  bool isQuickAdd = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String label = 'Set Due Date';
  Color labelColor = Colors.black;
  DateTime? dueDate;

  String? _errorText;
  // int? _value; //? Priority level
  bool isSetPriority = false;
  bool? isImportant;
  bool? isUrgent;

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('render AddTaskModal');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Switch(
                  thumbIcon: thumbIcon,
                  value: isQuickAdd,
                  onChanged: (bool value) {
                    setState(() {
                      isQuickAdd = value;
                    });
                  },
                ),
                label: const Text('Quick Add'),
              ),
              TextButton.icon(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    if (isSetPriority) {
                      final priority = calculatePriority(isImportant, isUrgent);
                      if (priority == -1) {
                        showMySnackbar(context, message: 'Please set priority');
                        return;
                      }
                      handleAdd(context, _controller.text, priority: priority);
                    } else {
                      handleAdd(context, _controller.text);
                    }
                  } else {
                    setState(() {
                      _errorText = '*Please enter task name';
                    });
                  }
                },
                label: const Text('Create Task'),
                icon: const Icon(Icons.add_task_sharp),
              ),
            ],
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Add New Task',
              prefixIcon: const Icon(Icons.title),
              errorText: _errorText,
            ),
            onSubmitted: (value) {
              // unfocus text field
              _focusNode.unfocus();
            },
          ),
          // Priority level
          const SizedBox(height: 8.0),
          // buildPriorityTable(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Set Priority', style: MyTextStyle.blackBold87),
              Switch(
                thumbIcon: thumbIcon,
                value: isSetPriority,
                onChanged: (bool value) {
                  setState(() {
                    isSetPriority = value;
                  });
                },
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: isSetPriority ? buildPriorityCard() : const SizedBox.shrink(),
          ),

          // Due Date
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionChip(
                avatar: Icon(Icons.calendar_today, color: labelColor),
                label: Text(label, style: TextStyle(color: labelColor)),
                onPressed: () async {
                  final pickedDate = await showMyDatePicker(context, initDate: DateTime.now());
                  if (pickedDate != null) {
                    // > change color to red if date is in the past
                    if (pickedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                      labelColor = Colors.red;
                    } else {
                      labelColor = Colors.blue;
                    }
                    setState(() {
                      label = convertDateTimeToString(pickedDate, pattern: 'dd/MM');
                    });
                  }
                },
                tooltip: 'Set Due Date',
              ),

              // Button Clear
              TextButton(
                onPressed: () {
                  setState(() {
                    label = 'Set Due Date';
                    labelColor = Colors.black;
                    _controller.clear();
                    _errorText = null;
                  });
                  _focusNode.requestFocus();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget buildPriorityTable() => Table(
  //       columnWidths: const {
  //         1: FlexColumnWidth(1),
  //         2: FlexColumnWidth(1),
  //       },
  //       border: TableBorder.all(color: Colors.grey),
  //       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //       children: [
  //         TableRow(
  //           children: [
  //             // const Text('Important'),
  //             ChoiceChip(
  //               label: const Text('(+)Urgent (+)Important'),
  //               selected: _value == 3,
  //               onSelected: (bool selected) {
  //                 log('object: ${selected.toString()}');
  //                 setState(() {
  //                   _value = selected ? 3 : null;
  //                 });
  //               },
  //             ),
  //             ChoiceChip(
  //               label: const Text('(-)Urgent (+)Important'),
  //               selected: _value == 2,
  //               onSelected: (bool selected) {
  //                 log('object: ${selected.toString()}');
  //                 setState(() {
  //                   _value = selected ? 2 : null;
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //         TableRow(
  //           children: [
  //             // const Text('Not Important'),
  //             ChoiceChip(
  //               label: const Text('(+)Urgent (-)Important'),
  //               selected: _value == 1,
  //               onSelected: (bool selected) {
  //                 log('object: ${selected.toString()}');
  //                 setState(() {
  //                   _value = selected ? 1 : null;
  //                 });
  //               },
  //             ),
  //             ChoiceChip(
  //               label: const Text('(-)Urgent (-)Important'),
  //               selected: _value == 0,
  //               onSelected: (bool selected) {
  //                 log('object: ${selected.toString()}');
  //                 setState(() {
  //                   _value = selected ? 0 : null;
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     );

  Widget buildPriorityCard() => Column(
        key: ValueKey<bool>(isSetPriority),
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Is Important?', style: MyTextStyle.blackBold87),
              Wrap(
                spacing: 12.0,
                children: [
                  ChoiceChip(
                    label: const Text('Yes'), // (+) Important
                    selected: isImportant == true,
                    selectedColor: Colors.green,
                    onSelected: (bool selected) {
                      setState(() {
                        // _value = selected ? 0 : null;
                        isImportant = selected ? true : null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('No'), // (-) Important
                    selected: isImportant == false,
                    selectedColor: Colors.red,
                    onSelected: (bool selected) {
                      setState(() {
                        // _value = selected ? 1 : null;
                        isImportant = selected ? false : null;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Is Urgent?', style: MyTextStyle.blackBold87),
              Wrap(
                spacing: 12.0,
                children: [
                  ChoiceChip(
                    label: const Text('Yes'), // (+) Urgent
                    selected: isUrgent == true,
                    selectedColor: Colors.green,
                    onSelected: (bool selected) {
                      setState(() {
                        // _value = selected ? 3 : null;
                        isUrgent = selected ? true : null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('No'), // (-) Urgent
                    selected: isUrgent == false,
                    selectedColor: Colors.red,
                    onSelected: (bool selected) {
                      setState(() {
                        // _value = selected ? 4 : null;
                        isUrgent = selected ? false : null;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  void handleAdd(BuildContext context, String value, {int? priority}) {
    // > add task to list

    final currentUser = context.read<AuthenticationBloc>().state.user;

    di<TaskRepository>().addTask(TaskEntity(
      tid: null,
      lid: widget.lid,
      taskName: value,
      description: null,
      priority: priority,
      completed: false,
      dueDate: dueDate,
      reminders: dueDate != null ? Reminder(rid: generateNotificationId(dueDate!)) : null,
      creator: currentUser,
      assignedMembers: null,
      created: DateTime.now(),
      updated: DateTime.now(),
    ));
    // > clear text field
    _controller.clear();
    // > reset due date
    setState(() {
      label = 'Set Due Date';
      labelColor = Colors.black;
      dueDate = null;
      _errorText = null;
    });
    // > set focus to text field
    _focusNode.requestFocus();

    // > close modal if quick add is false
    if (!isQuickAdd) Navigator.pop(context);
  }

  int calculatePriority(bool? isImportant, bool? isUrgent) {
    if (isImportant == null || isUrgent == null) return -1;

    return isImportant == true && isUrgent == true
        ? 3
        : isImportant == false && isUrgent == true
            ? 2
            : isImportant == true && isUrgent == false
                ? 1
                : 0;
  }
}
