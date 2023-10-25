part of 'habit_bloc.dart';

sealed class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

final class HabitInitial extends HabitState {}

final class HabitLoading extends HabitState {}

final class HabitSuccess extends HabitState {
  final String message;

  const HabitSuccess({this.message = 'HabitSuccess'});
  
  @override
  List<Object> get props => [message];
}

final class HabitError extends HabitState {
  final String message;

  const HabitError({required this.message});

  @override
  List<Object> get props => [message];
}
