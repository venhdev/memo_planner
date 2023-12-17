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
  final FocusNode focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  String dueDateLabel = 'Set Due Date';
  Color dueDateColor = Colors.black;
  DateTime? _dueDate;

  String reminderLabel = 'Set Reminder';
  DateTime? _reminderDateTime;

  String? errorText;
  int? _priority; //? Priority level
  bool isSetPriority = false;

  // bool? isImportant;
  // bool? isUrgent;

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
    focusNode.dispose();
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
          // QuickAdd & Create Task
          _buildHeaderBar(context),
          // Task Name
          _buildTextField(),

          // Priority level
          const SizedBox(height: 8.0),
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
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: isSetPriority ? _buildPriorityTable() : const SizedBox.shrink(),
          ),

          // Due Date
          const SizedBox(height: 8.0),
          _buildBottomToolBar(context),
        ],
      ),
    );
  }

  Row _buildHeaderBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Switch Quick Add
        TextButton.icon(
          onPressed: () {
            setState(() {
              isQuickAdd = !isQuickAdd;
            });
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
        // Create Task
        TextButton.icon(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              handleAdd(context, _controller.text, _priority);
            } else {
              setState(() {
                errorText = '*Please enter task name';
              });
            }
          },
          label: const Text('Create Task'),
          icon: const Icon(Icons.add_task_sharp),
        ),
      ],
    );
  }

  TextField _buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: focusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Add New Task',
        prefixIcon: const Icon(Icons.title),
        errorText: errorText,
      ),
      onSubmitted: (value) {
        // unfocus text field
        focusNode.unfocus();
      },
    );
  }

  Wrap _buildBottomToolBar(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      children: [
        // Button Set Due Date
        ActionChip(
          avatar: Icon(Icons.calendar_today, color: dueDateColor),
          label: Text(dueDateLabel, style: TextStyle(color: dueDateColor)),
          onPressed: () async {
            final pickedDate = await showMyDatePicker(context, initDate: DateTime.now());
            if (pickedDate != null) {
              // > change color to red if date is in the past
              if (pickedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                dueDateColor = Colors.red;
              } else {
                dueDateColor = Colors.blue;
              }
              setState(() {
                dueDateLabel = convertDateTimeToString(pickedDate, pattern: 'dd/MM');
                _dueDate = pickedDate;
              });
            }
          },
          tooltip: 'Set Due Date',
        ), // Button Set Due Date
        // Button Set Reminder
        ActionChip(
          avatar: const Icon(Icons.lock_clock, color: Colors.black),
          label: Text(reminderLabel, style: const TextStyle(color: Colors.black)),
          onPressed: () async {
            final date = await pickDate();
            if (date == null) return;

            final time = await pickTime();
            if (time == null) return;

            final pickedDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );

            // > the reminder date time must be in the future
            if (pickedDateTime.isBefore(DateTime.now())) {
              showSnackBar(message: 'Reminder must be in the future', backgroundColor: Colors.red);
            } else {
              setState(() {
                reminderLabel = convertDateTimeToString(pickedDateTime, pattern: 'dd/MM - HH:mm');
                _reminderDateTime = pickedDateTime;
                log('object _reminderDateTime: ${_reminderDateTime.toString()}');
              });
            }

            // // > change color to red if date is in the past
            // if (pickedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
            //   dueDateColor = Colors.red;
            // } else {
            //   dueDateColor = Colors.blue;
            // }
            // setState(() {
            //   dueDateLabel = convertDateTimeToString(pickedDate, pattern: 'dd/MM');
            // });
          },
          tooltip: 'Set Reminder',
        ),
        // Button Reset
        IconButton(tooltip: 'Clear All Fields', onPressed: handleReset, icon: const Icon(Icons.delete_forever)),
      ],
    );
  }

  Table _buildPriorityTable() => Table(
        columnWidths: const {
          0: FlexColumnWidth(0.2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        border: TableBorder.all(color: Colors.grey),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          const TableRow(
            children: [
              SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: Text('Urgent')),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: Text('Not Urgent')),
              ),
            ],
          ),
          // Important Line
          TableRow(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Important'),
                ),
              ),
              // Important & Urgent
              ChoiceChip(
                label: const Text('Do It Now'),
                selected: _priority == 3,
                selectedColor: Colors.green,
                onSelected: (bool selected) {
                  log('object: ${selected.toString()}');
                  setState(() {
                    _priority = selected ? 3 : null;
                  });
                },
              ),
              // Important & Not Urgent
              ChoiceChip(
                label: const Text('Schedule It'),
                selected: _priority == 2,
                selectedColor: Colors.blue,
                onSelected: (bool selected) {
                  log('object: ${selected.toString()}');
                  setState(() {
                    _priority = selected ? 2 : null;
                  });
                },
              ),
            ],
          ),
          // Not Important Line
          TableRow(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Not Urgent'),
                ),
              ),
              // Not Important & Urgent
              ChoiceChip(
                label: const Text('Delegate It'),
                selected: _priority == 1,
                selectedColor: Colors.orange,
                onSelected: (bool selected) {
                  log('object: ${selected.toString()}');
                  setState(() {
                    _priority = selected ? 1 : null;
                  });
                },
              ),
              // Not Important & Not Urgent
              ChoiceChip(
                label: const Text('Eliminate It'),
                selected: _priority == 0,
                selectedColor: Colors.grey,
                onSelected: (bool selected) {
                  log('object: ${selected.toString()}');
                  setState(() {
                    _priority = selected ? 0 : null;
                  });
                },
              ),
            ],
          ),
        ],
      );

  // Widget buildPriorityCard() => Column(
  //       key: ValueKey<bool>(isSetPriority),
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Is Important?', style: MyTextStyle.blackBold87),
  //             Wrap(
  //               spacing: 12.0,
  //               children: [
  //                 ChoiceChip(
  //                   label: const Text('Yes'), // (+) Important
  //                   selected: isImportant == true,
  //                   selectedColor: Colors.green,
  //                   onSelected: (bool selected) {
  //                     setState(() {
  //                       // _value = selected ? 0 : null;
  //                       isImportant = selected ? true : null;
  //                     });
  //                   },
  //                 ),
  //                 ChoiceChip(
  //                   label: const Text('No'), // (-) Important
  //                   selected: isImportant == false,
  //                   selectedColor: Colors.red,
  //                   onSelected: (bool selected) {
  //                     setState(() {
  //                       // _value = selected ? 1 : null;
  //                       isImportant = selected ? false : null;
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Is Urgent?', style: MyTextStyle.blackBold87),
  //             Wrap(
  //               spacing: 12.0,
  //               children: [
  //                 ChoiceChip(
  //                   label: const Text('Yes'), // (+) Urgent
  //                   selected: isUrgent == true,
  //                   selectedColor: Colors.green,
  //                   onSelected: (bool selected) {
  //                     setState(() {
  //                       // _value = selected ? 3 : null;
  //                       isUrgent = selected ? true : null;
  //                     });
  //                   },
  //                 ),
  //                 ChoiceChip(
  //                   label: const Text('No'), // (-) Urgent
  //                   selected: isUrgent == false,
  //                   selectedColor: Colors.red,
  //                   onSelected: (bool selected) {
  //                     setState(() {
  //                       // _value = selected ? 4 : null;
  //                       isUrgent = selected ? false : null;
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     );

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

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );

  void showSnackBar({
    required String message,
    bool closeable = true,
    Duration? duration,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: closeable
          ? SnackBarAction(
              label: 'OK',
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            )
          : null,
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void handleAdd(BuildContext context, String value, int? priority) {
    final currentUser = context.read<AuthenticationBloc>().state.user;
    di<TaskRepository>().addTask(TaskEntity(
      tid: null,
      lid: widget.lid,
      taskName: value,
      description: null,
      priority: priority,
      completed: false,
      dueDate: _dueDate,
      reminders: _reminderDateTime != null
          ? Reminder(
              rid: generateNotificationId(_reminderDateTime!),
              scheduledTime: _reminderDateTime,
            )
          : null,
      creator: currentUser,
      assignedMembers: const [],
      created: DateTime.now(),
      updated: DateTime.now(),
    ));
    
    // > reset all fields
    handleReset();

    // > set focus to text field again
    focusNode.requestFocus();

    // > close modal if quick add is false
    if (!isQuickAdd) Navigator.pop(context);
  }

  void handleReset() {
    setState(() {
      _controller.clear();
      errorText = null;

      _priority = null;

      dueDateLabel = 'Set Due Date';
      dueDateColor = Colors.black;
      _dueDate = null;

      reminderLabel = 'Set Reminder';
      _reminderDateTime = null;
    });
  }
}
