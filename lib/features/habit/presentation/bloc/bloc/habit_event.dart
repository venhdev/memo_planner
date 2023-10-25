part of 'habit_bloc.dart';

sealed class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

final class HabitStartedEvent extends HabitEvent {}

final class HabitAddEvent extends HabitEvent {
  final HabitEntity habit;

  const HabitAddEvent({required this.habit});

  @override
  List<Object> get props => [habit];
}

final class HabitUpdateEvent extends HabitEvent {
  final HabitEntity habit;

  const HabitUpdateEvent({required this.habit});

  @override
  List<Object> get props => [habit];
}

final class HabitDeleteEvent extends HabitEvent {
  final HabitEntity habit;

  const HabitDeleteEvent({required this.habit});

  @override
  List<Object> get props => [habit];
}
