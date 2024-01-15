// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../core/notification/reminder.dart';
import '../../../authentication/domain/entities/user_entity.dart';

class TaskEntity extends Equatable {
  // Task Info
  final String? tid;
  final String? lid;
  final String? taskName;
  final String? description;
  final int? priority;

  final bool? completed;
  final DateTime? dueDate;
  final Reminder? reminders;

  final UserEntity? creator;
  final List<String>? assignedMembers; // List of uid

  final DateTime? created;
  final DateTime? updated;

  const TaskEntity({
    this.tid,
    this.lid,
    this.taskName,
    this.description,
    this.priority,
    this.completed,
    this.dueDate,
    this.reminders,
    this.creator,
    this.assignedMembers,
    this.created,
    this.updated,
  });

  TaskEntity copyWith({
    String? tid,
    String? lid,
    String? taskName,
    String? description,
    int? priority,
    bool? completed,
    DateTime? dueDate,
    Reminder? reminders,
    UserEntity? creator,
    List<String>? assignedMembers,
    DateTime? created,
    DateTime? updated,
    bool allowDueDateNull = false,
    bool allowRemindersNull = false,
    bool allowPriorityNull = false,
  }) {
    return TaskEntity(
      tid: tid ?? this.tid,
      lid: lid ?? this.lid,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      priority: allowPriorityNull ? priority : priority ?? this.priority,
      completed: completed ?? this.completed,
      dueDate: allowDueDateNull ? dueDate : dueDate ?? this.dueDate,
      reminders: allowRemindersNull ? reminders : reminders ?? this.reminders,
      creator: creator ?? this.creator,
      assignedMembers: assignedMembers ?? this.assignedMembers,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  @override
  List<Object?> get props => [
        tid,
        lid,
        taskName,
        description,
        priority,
        completed,
        dueDate,
        reminders,
        assignedMembers,
        created,
        updated,
      ];
}


/**
 * priority: Important Level:
4: urgent & important
3: !urgent & important
2: urgent & !important
1: urgent & important
 */