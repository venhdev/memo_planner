part of 'task_bloc.dart';


class TaskState extends Equatable {
  const TaskState({
    required this.status,
    this.stream,
    this.message,
  });

  const TaskState.initial({
    this.status = BlocStatus.initial,
    this.stream,
    this.message = 'task initial state',
  });

  final BlocStatus status;
  final SQuerySnapshot? stream;
  final String? message;

  @override
  List<Object> get props => [
        status,
        stream ?? stream == null,
        message ?? message == null,
      ];

  TaskState copyWith({
    BlocStatus? status,
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
