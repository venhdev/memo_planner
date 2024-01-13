part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskEvent {
  const TaskInitial();

  @override
  List<Object> get props => [];
}
