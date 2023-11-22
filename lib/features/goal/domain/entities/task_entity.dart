import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user_entity.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    this.taskId,
    required this.summary,
    this.description,
    this.creator,
    this.dueDate,
    this.completed = false,
    this.kind = 'goal#task',
    this.dueDateNull = false,
  });

  final String? taskId; // goal id
  final String? summary;
  final String? description;
  final UserEntity? creator;

  final DateTime? dueDate;
  final bool? completed;

  final String kind; // goal#task -- default value
  final bool dueDateNull; // allow null

  @override
  List<Object?> get props => [
        taskId,
        summary,
        description,
        creator,
        dueDate,
        completed,
        kind,
        dueDateNull,
      ];

  // copyWith
  TaskEntity copyWith({
    String? taskId,
    String? summary,
    String? description,
    UserEntity? creator,
    DateTime? dueDate,
    bool? completed,
    bool dueDateNull = false, // allow null
  }) {
    return TaskEntity(
      taskId: taskId ?? this.taskId,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      creator: creator ?? this.creator,
      dueDate: dueDateNull ? dueDate : (dueDate ?? this.dueDate),
      completed: completed ?? this.completed,
      // allow null
      dueDateNull: dueDateNull,
    );
  }
}
