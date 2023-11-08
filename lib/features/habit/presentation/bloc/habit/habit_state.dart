part of 'habit_bloc.dart';

sealed class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

final class HabitInitial extends HabitState {}

final class HabitLoading extends HabitState {}

final class HabitLoaded extends HabitState {
  const HabitLoaded({this.message, required this.habitStream});
  final Stream<QuerySnapshot> habitStream;
  final String? message;

  @override
  List<Object> get props => [habitStream];
}


final class HabitError extends HabitState {
  const HabitError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
