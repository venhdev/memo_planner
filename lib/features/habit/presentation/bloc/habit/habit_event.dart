part of 'habit_bloc.dart';

sealed class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

final class HabitEventInitial extends HabitEvent {
  HabitEventInitial();
  final DateTime currentDate = DateTime.now();

  @override
  List<Object> get props => [currentDate];
}

final class HabitEventAdd extends HabitEvent {
  const HabitEventAdd({required this.habit});
  final HabitEntity habit;

  @override
  List<Object> get props => [habit];
}

final class HabitEventAddInstance extends HabitEvent {
  const HabitEventAddInstance({required this.habit, required this.date});
  final HabitEntity habit;
  final DateTime date;

  @override
  List<Object> get props => [habit, date];
}

final class HabitEventUpdate extends HabitEvent {
  const HabitEventUpdate({required this.habit});
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