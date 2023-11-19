import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user_entity.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.taskId,
    required this.summary,
    required this.description,
    required this.creator,
    required this.dueDate,
    required this.completed,
    this.kind = 'goal#task',
  });

  final String? taskId; // goal id
  final String? summary;
  final String? description;
  final UserEntity? creator;

  final DateTime? dueDate;
  final bool? completed;

  final String kind;

  @override
  List<Object?> get props => [
        taskId,
        summary,
        description,
        creator,
        dueDate,
        completed,
        kind,
      ];
}
