import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart';

import '../../../domain/entities/habit_entity.dart';
import '../../../domain/usecase/add_habit.dart';
import '../../../domain/usecase/delete_habit.dart';
import '../../../domain/usecase/update_habit.dart';

part 'habit_event.dart';
part 'habit_state.dart';

@injectable
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final AddHabitUC _addHabitUC;
  final UpdateHabitUC _updateHabitUC;
  final DeleteHabitUC _deleteHabitUC;
  final GetCurrentUserUC _getCurrentUserUC;

  HabitBloc(
    this._addHabitUC,
    this._updateHabitUC,
    this._deleteHabitUC,
    this._getCurrentUserUC,
  ) : super(HabitInitial()) {
    on<HabitAddEvent>(_onAddHabitEvent);
    on<HabitUpdateEvent>(_onUpdateHabitEvent);
    on<HabitDeleteEvent>(_onDeleteHabitEvent);
  }

  void _onAddHabitEvent(HabitAddEvent event, Emitter<HabitState> emit) async {
    emit(HabitLoading());
    try {
      final HabitEntity habit = event.habit.copyWith(
        creator: await _getCurrentUserUC(),
      );
      final result = await _addHabitUC(habit);

      result.fold(
        (l) => emit(HabitError(message: l.message)),
        (r) => emit(const HabitSuccess(message: 'Habit added')),
      );
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  void _onUpdateHabitEvent(
      HabitUpdateEvent event, Emitter<HabitState> emit) async {
    emit(HabitLoading());
    try {
      await _updateHabitUC(event.habit);
      emit(const HabitSuccess(message: 'Habit updated'));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  void _onDeleteHabitEvent(
      HabitDeleteEvent event, Emitter<HabitState> emit) async {
    emit(HabitLoading());
    try {
      await _deleteHabitUC(event.habit);
      emit(const HabitSuccess(message: 'Habit deleted'));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }
}
