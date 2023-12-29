import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/notification/reminder.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    super.tid,
    super.lid,
    super.taskName,
    super.description,
    super.priority,
    super.completed,
    super.dueDate,
    super.reminders,
    super.creator,
    super.assignedMembers,
    super.created,
    super.updated,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      tid: entity.tid,
      lid: entity.lid,
      taskName: entity.taskName,
      description: entity.description,
      priority: entity.priority,
      completed: entity.completed,
      dueDate: entity.dueDate,
      reminders: entity.reminders,
      creator: entity.creator,
      assignedMembers: entity.assignedMembers,
      created: entity.created,
      updated: entity.updated,
    );
  }

  Map<String, dynamic> toMap([bool toJson = false]) {
    return <String, dynamic>{
      'tid': tid,
      'lid': lid,
      'taskName': taskName,
      'description': description,
      'priority': priority,
      'completed': completed,
      'dueDate': dueDate != null ? (toJson ? dueDate?.toIso8601String() : dueDate) : null,
      'reminders': toJson ? reminders?.toJson() : reminders?.toMap(),
      'creator': creator != null ? UserModel.fromEntity(creator!).toMap() : null,
      'assignedMembers': assignedMembers,
      'created': created != null ? (toJson ? created?.toIso8601String() : created) : null,
      'updated': updated != null ? (toJson ? updated?.toIso8601String() : updated) : null,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, [bool fromJson = false]) {
    return TaskModel(
      tid: map['tid'] != null ? map['tid'] as String : null,
      lid: map['lid'] != null ? map['lid'] as String : null,
      taskName: map['taskName'] != null ? map['taskName'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      priority: map['priority'] != null ? map['priority'] as int : null,
      completed: map['completed'] != null ? map['completed'] as bool : null,
      dueDate: map['dueDate'] != null
          ? fromJson
              ? DateTime.parse(map['dueDate'] as String)
              : (map['dueDate'] as Timestamp).toDate()
          : null,
      reminders: map['reminders'] != null
          ? fromJson
              ? Reminder.fromJson(map['reminders'] as String)
              : Reminder.fromMap(map['reminders'] as Map<String, dynamic>)
          : null,
      creator: map['creator'] != null ? UserModel.fromMap(map['creator'] as Map<String, dynamic>) : null,
      assignedMembers: map['assignedMembers'] != null
          ? (map['assignedMembers'] as List<dynamic>).map((assigner) => assigner.toString()).toList()
          : null,
      created: map['created'] != null
          ? fromJson
              ? DateTime.parse(map['created'] as String)
              : (map['created'] as Timestamp).toDate()
          : null,
      updated: map['updated'] != null
          ? fromJson
              ? DateTime.parse(map['updated'] as String)
              : (map['updated'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap(true));

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source) as Map<String, dynamic>, true);

  @override
  String toString() {
    return 'TaskModel(tid: $tid, lid: $lid, taskName: $taskName, description: $description, priority: $priority, completed: $completed, dueDate: $dueDate, reminders: $reminders, creator: $creator, assignedMembers: $assignedMembers, created: $created, updated: $updated)';
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
