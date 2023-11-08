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
//     required this.status,
//   });

//   final DateTime focusDate;
//   final HabitEntity habit;
//   final bool status;

//   @override
//   List<Object> get props => [focusDate, habit, status];
// }

// This event used for the instance not created yet
class InstanceInitialEvent extends InstanceEvent {
  const InstanceInitialEvent({required this.habit, required this.date});
  final HabitEntity habit;
  final DateTime date;

  @override
  List<Object> get props => [habit, date];
}

class InstanceStatusChangeEvent extends InstanceEvent {
  const InstanceStatusChangeEvent({
    required this.instance,
    required this.status,
  });
  final HabitInstanceModel instance;
  final bool status;
}
