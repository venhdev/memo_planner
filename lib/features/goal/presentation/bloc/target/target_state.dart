part of 'target_bloc.dart';

class TargetState extends Equatable {
  const TargetState.initial({
    this.status = BlocStatus.initial,
    this.stream,
    this.message = 'target initial state',
  });

  const TargetState({
    required this.status,
    this.stream,
    this.message,
  });

  final BlocStatus status;
  final SQuerySnapshot? stream;
  final String? message;

  TargetState copyWith({
    BlocStatus? status,
    SQuerySnapshot? stream,
    String? message,
  }) {
    return TargetState(
      status: status ?? this.status,
      stream: stream ?? this.stream,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        status,
        stream ?? stream == null,
        message ?? message == null,
      ];
}
