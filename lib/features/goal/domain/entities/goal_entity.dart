import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.taskId,
    required this.summary,
    required this.description,
    required this.dueDate,
    required this.completed,
    this.kind = 'goal#task',
  });

  final String taskId; // goal id
  final String summary;
  final String description;
  final DateTime dueDate;
  final bool completed;
  final String kind;

  @override
  List<Object?> get props => [
        taskId,
        summary,
        description,
        dueDate,
        completed,
        kind,
      ];
}
