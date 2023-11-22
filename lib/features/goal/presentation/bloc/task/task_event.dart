part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskEventInitial extends TaskEvent {}

class TaskEventAdded extends TaskEvent {
  const TaskEventAdded({required this.task});

  final TaskEntity task;
  @override
  List<Object> get props => [task];
}

class TaskEventDeleted extends TaskEvent {
  const TaskEventDeleted(this.task);

  final TaskEntity task;
  @override
  List<Object> get props => [task];
}

class TaskEventUpdated extends TaskEvent {
  const TaskEventUpdated(this.task);

  final TaskEntity task;
  @override
  List<Object> get props => [task];
}
