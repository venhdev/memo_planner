part of 'habit_bloc.dart';

sealed class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

final class HabitStartedEvent extends HabitEvent {}

final class HabitAddEvent extends HabitEvent {
  const HabitAddEvent({required this.habit});
  final HabitEntity habit;


  @override
  List<Object> get props => [habit];
}

final class HabitUpdateEvent extends HabitEvent {
  const HabitUpdateEvent({required this.habit});
  final HabitEntity habit;


  @override
  List<Object> get props => [habit];
}

final class HabitDeleteEvent extends HabitEvent {
  const HabitDeleteEvent({required this.habit});
  final HabitEntity habit;


  @override
  List<Object> get props => [habit];
}
