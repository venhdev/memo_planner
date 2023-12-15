part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskEventInitial extends TaskEvent {
  const TaskEventInitial();
}

