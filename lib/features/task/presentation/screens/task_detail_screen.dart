import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:memo_planner/core/utils/helpers.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/common_screen.dart';
import '../../../../core/components/my_picker.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/notification/reminder.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../components/assigned_members.dart';
import '../components/dialog_assign_member.dart';
import '../components/priority_table.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.lid, required this.tid});

  final String lid;
  final String tid;

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 1.0,
        maxChildSize: 1.0,
        minChildSize: 0.9,
        builder: (context, scrollController) => StreamBuilder(
          stream: di<TaskRepository>().getOneTaskStream(lid, tid),
          builder: (context, snapshot) {
            log('render TaskDetailScreen with ${snapshot.connectionState}');
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final map = snapshot.data?.data()!;
                if (map == null) return const MessageScreen(message: 'No data');
                final TaskEntity task = TaskModel.fromMap(map);
                return TaskDetailBody(scrollController: scrollController, task: task);
              } else if (snapshot.hasError) {
                return MessageScreen(message: snapshot.error.toString());
              } else {
                return const LoadingScreen();
              }
            } else {
              return const LoadingScreen();
            }
          },
        ),
      );
}

class TaskDetailBody extends StatefulWidget {
  const TaskDetailBody({
    super.key,
    required this.scrollController,
    required this.task,
  });

  final ScrollController scrollController;
  final TaskEntity task;

  @override
  State<TaskDetailBody> createState() => _TaskDetailBodyState();
}

class _TaskDetailBodyState extends State<TaskDetailBody> {
  final taskNameFocusNode = FocusNode();
  final taskNameController = TextEditingController();

  bool unSavedChanges() => unSavedTaskName || unSavedPriority || unSavedReminder || unSavedDueDate;

  bool unSavedTaskName = false;
  bool unSavedPriority = false;
  bool unSavedReminder = false;
  bool unSavedDueDate = false;

  late String _taskName;
  int? _priority;
  Reminder? _reminder;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.task.taskName!;
    _taskName = widget.task.taskName!;
    _priority = widget.task.priority;
    _reminder = widget.task.reminders;
    log('object: $_reminder');
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    saveChanges();
    taskNameFocusNode.dispose();
    taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        controller: widget.scrollController,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
          // Arrow icon and text 'Drag down to close' with grey color
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward, color: Colors.grey),
              Text('Drag down to close and save', style: TextStyle(color: Colors.grey)),
            ],
          ),
          // Save changes button
          _buildSaveOrCloseButton(),

          // Task name
          _buildTaskName(),

          // Priority table
          const SizedBox(height: 16),
          PriorityTable(
            priority: _priority,
            callBack: (value) {
              if (value != widget.task.priority) {
                setState(() {
                  _priority = value;
                  unSavedPriority = true;
                });
              } else {
                setState(() {
                  _priority = value;
                  unSavedPriority = false;
                });
              }
            },
          ),

          // Add to MyDay button
          const SizedBox(height: 16),
          _buildAddToMyDayButton(),

          // Reminder
          const SizedBox(height: 16),
          Text('$_reminder'),
          _buildReminderButton(),

          // Due date
          const SizedBox(height: 16),
          _buildDueDateButton(),

          // Assign To
          const SizedBox(height: 16),
          _buildAssignToButton(),

          // Task description
          const SizedBox(height: 16),
          _buildTaskDescription(),
        ],
      ),
    );
  }

  Widget _buildAssignToButton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: TextButton(
        onPressed: () {
          // show dialog to select members
          showMemberToAddAssign();
        },
        child: Row(
          children: [
            const Icon(Icons.person_outline, color: MyColors.kActiveTextColor),
            const SizedBox(width: 8),
            const Text('Assign to ', style: TextStyle(color: MyColors.kActiveTextColor)),
            widget.task.assignedMembers != null
                ? AssignedMembers(
                    task: widget.task,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  TextButton _buildDueDateButton() {
    return TextButton(
      onPressed: () async {
        await showMyDatePicker(context, initDate: _dueDate ?? DateTime.now()).then(
          (value) {
            // if the picked date different from the original date
            if (value != widget.task.dueDate) {
              setState(() {
                _dueDate = value;
                unSavedDueDate = true;
              });
            } else {
              // no difference between the picked date and the original date
              setState(() {
                _dueDate = value;
                unSavedDueDate = false;
              });
            }
          },
        );
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: MyColors.kActiveTextColor),
          const SizedBox(width: 8),
          Text(
            convertDateTimeToString(_dueDate, defaultValue: 'Set due date'),
            style: const TextStyle(color: MyColors.kActiveTextColor),
          ),
          const Spacer(), //> to push the icon to the right
          _dueDate != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                      // if before due date is not null >> there is a change
                      if (widget.task.dueDate != null) {
                        unSavedDueDate = true;
                      } else {
                        unSavedDueDate = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.grey),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
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

  TextButton _buildReminderButton() {
    return TextButton(
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
          // > if the picked reminder is different from the current reminder
          if (pickedDateTime != _reminder?.scheduledTime) {
            setState(() {
              // > if the current reminder is null > create new reminder
              if (widget.task.reminders == null) {
                final newReminder = Reminder(
                  rid: generateNotificationId(pickedDateTime),
                  scheduledTime: pickedDateTime,
                );
                setState(() {
                  _reminder = newReminder;
                  unSavedReminder = true;
                });
              } else {
                // the current reminder is different from the picked reminder
                setState(() {
                  _reminder = _reminder?.copyWith(scheduledTime: pickedDateTime);
                  unSavedReminder = true;
                });
              }
            });
          } else {
            setState(() {
              _reminder = _reminder?.copyWith(scheduledTime: pickedDateTime);
              unSavedReminder = false;
            });
          }
        }
      },
      child: Row(
        children: [
          const Icon(Icons.notifications, color: MyColors.kActiveTextColor),
          const SizedBox(width: 8),
          Text(
            '${convertDateTimeToString(
              _reminder?.scheduledTime,
              defaultValue: 'Set reminder',
              pattern: 'dd/MM - HH:mm',
            )} ${getRemainingTime(
              _reminder?.scheduledTime,
              prefixString: '| Remaining time: ',
              defaultText: '',
            )}',
            style: const TextStyle(color: MyColors.kActiveTextColor),
          ),
          const Spacer(), //> to push the icon to the right
          _reminder != null
              ? IconButton(
                  onPressed: () {
                    log('test');
                    setState(() {
                      _reminder = null;
                      // if before reminder is not null >> there is a change
                      if (widget.task.reminders != null) {
                        unSavedReminder = true;
                      } else {
                        unSavedReminder = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.grey),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  TextButton _buildAddToMyDayButton() {
    return TextButton(
      onPressed: () {},
      child: const Row(
        children: [
          Icon(Icons.wb_sunny_outlined, color: MyColors.kActiveTextColor),
          SizedBox(width: 8),
          Text('Add to My Day', style: TextStyle(color: MyColors.kActiveTextColor)),
          Spacer(), //> to push the icon to the right
        ],
      ),
    );
  }

  TextField _buildTaskDescription() {
    return const TextField(
      style: TextStyle(
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        hintText: 'Task description',
        border: OutlineInputBorder(),
      ),
      maxLines: 6,
    );
  }

  AnimatedSwitcher _buildSaveOrCloseButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: unSavedChanges()
          ? TextButton.icon(
              onPressed: () {
                saveChanges();
                setState(
                  () {
                    unSavedTaskName = false;
                    unSavedPriority = false;
                    unSavedReminder = false;
                    unSavedDueDate = false;
                  },
                );
              },
              label: const Text('Save changes', style: TextStyle(color: Colors.green)),
              icon: const Icon(Icons.save_alt, color: Colors.green),
            )
          : ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Close')),
    );
  }

  Widget _buildTaskName() {
    return TextField(
      focusNode: taskNameFocusNode,
      controller: taskNameController,
      textAlignVertical: TextAlignVertical.center,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        border: const UnderlineInputBorder(),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
        // checkbox
        prefixIcon: Checkbox(
          value: widget.task.completed,
          onChanged: (value) => di<TaskRepository>().toggleTask(
            widget.task.tid!,
            widget.task.lid!,
            value!,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) {
        if (value.trim() != widget.task.taskName) {
          setState(() {
            _taskName = value;
            unSavedTaskName = true;
          });
        } else if (value.trim() == widget.task.taskName && _taskName != value) {
          // after trim, the value is the same as the original
          setState(() {
            _taskName = value;
            unSavedTaskName = false;
          });
        }
      },
    );
  }

  Future<dynamic> showMemberToAddAssign() {
    return showDialog(
      context: context,
      builder: (context) => DialogAssignMember(lid: widget.task.lid!, tid: widget.task.tid!),
    );
  }

  void saveChanges() {
    if (unSavedChanges()) {
      log('object _dueDate: $_dueDate');
      final updatedTask = widget.task.copyWith(
        taskName: _taskName,
        priority: _priority,
        reminders: _reminder,
        dueDate: _dueDate,
        allowDueDateNull: true,
        allowRemindersNull: true,
        allowPriorityNull: true,
      );
      di<TaskRepository>().editTask(updatedTask, widget.task);
    }
  }
}
