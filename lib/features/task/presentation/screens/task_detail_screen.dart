import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/my_picker.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/notification/reminder.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/myday_model.dart';
import '../../domain/entities/myday_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../components/assigned_members.dart';
import '../components/priority_table.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.currentUID,
  });

  final TaskEntity task;
  final String currentUID;

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 1.0,
        maxChildSize: 1.0,
        minChildSize: 0.9,
        builder: (context, scrollController) => TaskDetailBody(
          scrollController: scrollController,
          oldTask: task,
          currentUserEmail: currentUID,
        ),
        // builder: (context, scrollController) => StreamBuilder(
        //   stream: di<TaskRepository>().getOneTaskStream(task.lid!, task.tid!),
        //   builder: (context, snapshot) {
        //     log('render TaskDetailScreen with ${snapshot.connectionState}');
        //     // if (snapshot.connectionState == ConnectionState.active) {
        //       if (snapshot.hasData) {
        //         final map = snapshot.data?.data();
        //         if (map == null) {
        //           return Container(
        //             color: Colors.white,
        //             child: const MessageScreen(message: 'Not found'),
        //           );
        //         }
        //         if (map.isEmpty) {
        //           return Container(
        //             color: Colors.white,
        //             child: const MessageScreen(message: 'Empty'),
        //           );
        //         }
        //         final TaskEntity task = TaskModel.fromMap(map);
        //         return TaskDetailBody(
        //           scrollController: scrollController,
        //           task: task,
        //           currentUserEmail: currentUserEmail,
        //         );
        //       } else if (snapshot.hasError) {
        //         return MessageScreen(message: snapshot.error.toString());
        //       } else {
        //         return const LoadingScreen();
        //       }
        //     // } else {
        //     //   return const LoadingScreen();
        //     // }
        //   },
        // ),
      );
}

class TaskDetailBody extends StatefulWidget {
  const TaskDetailBody({
    super.key,
    required this.scrollController,
    required this.oldTask,
    required this.currentUserEmail,
  });

  final ScrollController scrollController;

  final TaskEntity oldTask;
  final String currentUserEmail;

  @override
  State<TaskDetailBody> createState() => _TaskDetailBodyState();
}

class _TaskDetailBodyState extends State<TaskDetailBody> {
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  bool isDismiss = false;

  bool isUnSavedChanges() =>
      unSavedCompleted ||
      unSavedTaskName ||
      unSavedPriority ||
      unSavedAddToMyDay ||
      unSavedReminder ||
      unSavedDueDate ||
      unSavedAssignTo ||
      unSavedDescription;

  bool unSavedCompleted = false;
  bool unSavedTaskName = false;
  bool unSavedPriority = false;
  bool unSavedMyDay = false;
  bool unSavedReminder = false;
  bool unSavedDueDate = false;
  bool unSavedDescription = false;
  bool unSavedAddToMyDay = false;
  bool unSavedAssignTo = false;

  late bool _completed;
  late String _taskName;
  int? _priority;
  Reminder? _reminder;
  DateTime? _dueDate;
  late List<String> _assignedMembers;
  String? _description;

  late Stream stream;

  @override
  void initState() {
    super.initState();
    _completed = widget.oldTask.completed!;
    taskNameController.text = widget.oldTask.taskName!;
    taskDescriptionController.text = widget.oldTask.description!;
    _taskName = widget.oldTask.taskName!;
    _priority = widget.oldTask.priority;
    _reminder = widget.oldTask.reminders;
    _dueDate = widget.oldTask.dueDate;
    _assignedMembers = widget.oldTask.assignedMembers!;
    _description = widget.oldTask.description;
    stream = di<TaskRepository>().getOneMyDayStream(widget.currentUserEmail, widget.oldTask.tid!);
  }

  @override
  void dispose() {
    if (!isDismiss) saveChanges();
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('render TaskDetailBody');
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 8.0,
        right: 8.0,
      ),
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
          const SizedBox(height: 16.0),
          _buildPriorityTable(),

          // Add to MyDay button
          const SizedBox(height: 16.0),
          _buildMyDayButton(),

          // Reminder
          const SizedBox(height: 16.0),
          _buildReminderButton(),

          // Due date
          const SizedBox(height: 16.0),
          _buildDueDateButton(),

          // Assign To
          const SizedBox(height: 16.0),
          _buildAssignToButton(),

          // Task description
          const SizedBox(height: 16.0),
          _buildTaskDescription(),

          // Last updated
          const SizedBox(height: 16.0),
          Text(
            'last updated: ${convertDateTimeToString(
              widget.oldTask.updated,
              pattern: 'dd/MM/yyyy - hh:mm aa',
            )}',
            style: const TextStyle(color: Colors.grey),
          ),

          // Created At and Created By
          const SizedBox(height: 16.0),
          Text(
            'createdAt: ${convertDateTimeToString(
              widget.oldTask.created,
              pattern: 'dd/MM/yyyy - HH:mm',
            )} by ${widget.oldTask.creator?.displayName ?? 'unknown'}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignToButton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: TextButton(
        onPressed: () => showAssignMemberDialog(), // show dialog to select members
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              color: _assignedMembers.isNotEmpty ? AppColors.kActiveTextColor : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              'Assign to ',
              style: TextStyle(
                color: _assignedMembers.isNotEmpty ? AppColors.kActiveTextColor : Colors.black,
              ),
            ),
            _assignedMembers.isNotEmpty
                ? AssignedMembersList(
                    assignedMembers: _assignedMembers,
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
            if (value != widget.oldTask.dueDate) {
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
          Icon(Icons.calendar_today, color: AppColors.dueDateColor(_dueDate)),
          const SizedBox(width: 8),
          Text(
            convertDateTimeToString(_dueDate, defaultValue: 'Set due date'),
            style: TextStyle(color: AppColors.dueDateColor(_dueDate)),
          ),
          const Spacer(), //> to push the icon to the right
          _dueDate != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                      // if before due date is not null >> there is a change
                      if (widget.oldTask.dueDate != null) {
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

  PriorityTable _buildPriorityTable() {
    return PriorityTable(
      priority: _priority,
      callBack: (value) {
        if (value != widget.oldTask.priority) {
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
    );
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
        if (pickedDateTime.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
          Fluttertoast.showToast(msg: 'Reminder must later than 1 minute from now!');
        } else {
          // > if the picked reminder is different from the current reminder
          if (pickedDateTime != _reminder?.scheduledTime) {
            setState(
              () {
                // > if the current reminder is null > create new reminder
                if (widget.oldTask.reminders == null) {
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
              },
            );
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
          Icon(Icons.notifications, color: AppColors.dueDateColor(_reminder?.scheduledTime)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                convertDateTimeToString(
                  _reminder?.scheduledTime,
                  defaultValue: 'Set reminder',
                  pattern: 'dd/MM - HH:mm',
                ),
                style: const TextStyle(color: Colors.black),
              ),
              if (_reminder != null)
                Text(
                  getRemainingTime(_reminder?.scheduledTime, defaultOverdueText: 'Set new reminder'),
                  style: TextStyle(color: AppColors.dueDateColor(_reminder?.scheduledTime)),
                ),
            ],
          ),
          const Spacer(), //> to push the icon to the right
          _reminder != null
              ? IconButton(
                  onPressed: () {
                    log('test');
                    setState(() {
                      _reminder = null;
                      // if before reminder is not null >> there is a change
                      if (widget.oldTask.reminders != null) {
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

  // Widget _buildMyDayButton() {
  //   return TextButton(
  //     onPressed: () {
  //       setState(() {
  //         if (_myDay == null) {
  //           _myDay = MyDayEntity(
  //             lid: widget.task.lid!,
  //             tid: widget.task.tid!,
  //             created: getToday(),
  //           );
  //         } else {
  //           _myDay = null;
  //         }
  //       });
  //     },
  //     child: Row(
  //       children: [
  //         if (_myDay == null) ...[
  //           const Icon(Icons.wb_sunny_outlined, color: AppColors.kDeactivateTextColor),
  //           const SizedBox(width: 8),
  //           const Text('Add to My Day', style: TextStyle(color: AppColors.kDeactivateTextColor)),
  //           const Spacer(),
  //         ] else ...[
  //           const Icon(Icons.wb_sunny, color: AppColors.kActiveTextColor),
  //           const SizedBox(width: 8),
  //           const Text('Remove from My Day', style: TextStyle(color: AppColors.kActiveTextColor)),
  //           const Spacer(), //> to push the icon to the right
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 _myDay = _myDay!.copyWith(keep: !_myDay!.keep);
  //               });
  //             },
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Text(
  //                   'Keep in My Day',
  //                   style: TextStyle(color: AppColors.kDeactivateTextColor),
  //                 ),
  //                 const SizedBox(width: 4.0),
  //                 Icon(_myDay!.keep ? Icons.star : Icons.star_border, color: Colors.amber),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMyDayButton() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final map = snapshot.data?.data();
          if (map == null) {
            return TextButton(
              onPressed: () {
                final myDay = MyDayEntity(
                  lid: widget.oldTask.lid!,
                  tid: widget.oldTask.tid!,
                  created: getToday(),
                );
                di<TaskRepository>().addToMyDay(widget.currentUserEmail, myDay);
              },
              child: const Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: AppColors.kDeactivateTextColor),
                  SizedBox(width: 8),
                  Text('Add to My Day', style: TextStyle(color: AppColors.kDeactivateTextColor)),
                  Spacer(),
                ],
              ),
            );
          } else {
            final myday = MyDayModel.fromMap(map);
            return TextButton(
              onPressed: () {
                di<TaskRepository>().removeFromMyDay(widget.currentUserEmail, myday);
              },
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny, color: AppColors.kActiveTextColor),
                  const SizedBox(width: 8),
                  const Text('Remove from My Day', style: TextStyle(color: AppColors.kActiveTextColor)),
                  const Spacer(), //> to push the icon to the right
                  TextButton(
                    onPressed: () {
                      di<TaskRepository>().toggleKeepInMyDay(widget.currentUserEmail, widget.oldTask.tid!, !myday.keep);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Keep in My Day',
                          style: TextStyle(color: AppColors.kDeactivateTextColor),
                        ),
                        const SizedBox(width: 4.0),
                        Icon(myday.keep ? Icons.star : Icons.star_border, color: Colors.amber),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  TextField _buildTaskDescription() {
    return TextField(
        controller: taskDescriptionController,
        style: const TextStyle(
          fontSize: 14.0,
        ),
        decoration: const InputDecoration(
          hintText: 'Task description',
          border: OutlineInputBorder(),
        ),
        maxLines: null,
        minLines: 5,
        onChanged: (value) {
          if (value.trim() != widget.oldTask.description) {
            setState(() {
              _description = value;
              unSavedDescription = true;
            });
          } else if (value.trim() == widget.oldTask.description && _description != value) {
            // after trim, the value is the same as the original
            setState(() {
              _description = value;
              unSavedDescription = false;
            });
          }
        });
  }

  AnimatedSwitcher _buildSaveOrCloseButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: isUnSavedChanges()
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Save changes button
                TextButton.icon(
                  onPressed: () async {
                    await saveChanges();
                    setState(
                      () {
                        unSavedCompleted = false;
                        unSavedTaskName = false;
                        unSavedPriority = false;
                        unSavedReminder = false;
                        unSavedDueDate = false;
                        unSavedDescription = false;
                        unSavedAssignTo = false;
                      },
                    );
                  },
                  label: const Text('Save changes', style: TextStyle(color: Colors.green)),
                  icon: const Icon(Icons.save_alt, color: Colors.green),
                ),
                // Dismiss button
                TextButton.icon(
                  onPressed: () {
                    isDismiss = true;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text('Dismiss', style: TextStyle(color: Colors.red)),
                ),
              ],
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
          value: _completed,
          onChanged: (value) {
            setState(() {
              _completed = value!;
              if (_completed != widget.oldTask.completed) {
                unSavedCompleted = true;
              } else {
                unSavedCompleted = false;
              }
            });
            // di<TaskRepository>().toggleTask(
            //   widget.oldTask.tid!,
            //   widget.oldTask.lid!,
            //   value!,
            // );
          },
        ),
      ),
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) {
        if (value.trim() != widget.oldTask.taskName) {
          setState(() {
            _taskName = value;
            unSavedTaskName = true;
          });
        } else if (value.trim() == widget.oldTask.taskName && _taskName != value) {
          // after trim, the value is the same as the original
          setState(() {
            _taskName = value;
            unSavedTaskName = false;
          });
        }
      },
    );
  }

  Future<void> showAssignMemberDialog() {
    return showDialog(
      context: context,
      builder: (context) => AssignMemberDialog(
        task: widget.oldTask,
        valueChanged: (value) {
          // the same location between _assignedMembers and widget.oldTask.assignedMembers
          setState(() {
            _assignedMembers = value;
            if (_assignedMembers != widget.oldTask.assignedMembers) unSavedAssignTo = true;
          });
        },
      ),
    );
  }

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

  Future<void> saveChanges() async {
    if (isUnSavedChanges()) {
      final updatedTask = widget.oldTask.copyWith(
        completed: _completed,
        taskName: _taskName,
        priority: _priority,
        reminders: _reminder,
        dueDate: _dueDate,
        assignedMembers: _assignedMembers,
        description: _description,
        allowDueDateNull: true,
        allowRemindersNull: true,
        allowPriorityNull: true,
        updated: DateTime.now(),
      );
      await di<TaskRepository>().editTask(updatedTask, widget.oldTask);
    }
  }

  Future<TimeOfDay?> pickTime() => showMyTimePicker(context, initTime: TimeOfDay.now());

  Future<DateTime?> pickDate() => showMyDatePicker(context, initDate: DateTime.now());
}
