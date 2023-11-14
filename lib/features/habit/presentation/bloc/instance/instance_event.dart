part of 'instance_bloc.dart';

sealed class InstanceEvent extends Equatable {
  const InstanceEvent();

  @override
  List<Object> get props => [];
}

// class InstanceStatusChangeEvent extends InstanceEvent {
//   const InstanceStatusChangeEvent({
//     required this.focusDate,
//     required this.habit,
//     required this.completed,
//   });

//   final DateTime focusDate;
//   final HabitEntity habit;
//   final bool completed;

//   @override
//   List<Object> get props => [focusDate, habit, completed];
// }

// This event used for the instance not created yet
class InstanceInitialEvent extends InstanceEvent {
  const InstanceInitialEvent({
    required this.habit,
    required this.date,
    this.completed = true,
  });
  final HabitEntity habit;
  final DateTime date;
  final bool completed;

  @override
  List<Object> get props => [habit, date, completed];
}

class InstanceStatusChangeEvent extends InstanceEvent {
  const InstanceStatusChangeEvent({
    required this.instance,
    required this.completed,
  });
  final HabitInstanceEntity instance;
  final bool completed;

  @override
  List<Object> get props => [instance, completed];
}

class InstanceUpdateEvent extends InstanceEvent {
  const InstanceUpdateEvent({
    required this.instance,
  });
  final HabitInstanceEntity instance;

  @override
  List<Object> get props => [instance];
}
