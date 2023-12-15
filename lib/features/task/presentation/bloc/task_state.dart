// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'task_bloc.dart';

class TaskState extends Equatable {
  const TaskState.initial()
      : this(
          status: BlocStatus.initial,
          stream: const Stream.empty(),
        );
  const TaskState.loading()
      : this(
          status: BlocStatus.loading,
          stream: const Stream.empty(),
        );

  const TaskState.loaded(SQuerySnapshot stream)
      : this(
          status: BlocStatus.loaded,
          stream: stream,
        );

  const TaskState.error(String message)
      : this(
          status: BlocStatus.error,
          message: message,
          stream: const Stream.empty(),
        );

  const TaskState({
    required this.status,
    required this.stream,
    this.message,
  });

  final BlocStatus status;
  final SQuerySnapshot stream;
  final String? message;

  @override
  List<Object> get props => [status, stream, message ?? ''];

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
