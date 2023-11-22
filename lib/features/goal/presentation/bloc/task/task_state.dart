part of 'task_bloc.dart';

enum TaskStatus { initial, loading, loaded, success, failure }

class TaskState extends Equatable {
  const TaskState({
    required this.status,
    this.stream,
    this.message,
  });

  const TaskState.initial({
    this.status = TaskStatus.initial,
    this.stream,
    this.message = 'initial state',
  });

  final TaskStatus status;
  final SQuerySnapshot? stream;
  final String? message;

  @override
  List<Object> get props => [
        status,
        stream ?? stream == null,
        message ?? message == null,
      ];

  TaskState copyWith({
    TaskStatus? status,
    SQuerySnapshot? stream,
    String? message,
  }) {
    return TaskState(
      status: status ?? this.status,
      stream: stream ?? this.stream,
      message: message ?? this.message,
    );
  }
}
