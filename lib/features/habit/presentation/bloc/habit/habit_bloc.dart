import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/habit/domain/usecase/add_habit_instance.dart';
import 'package:memo_planner/features/habit/domain/usecase/get_habits.dart';
import '../../../../authentication/domain/usecase/get_current_user.dart';

import '../../../domain/entities/habit_entity.dart';
import '../../../domain/usecase/add_habit.dart';
import '../../../domain/usecase/delete_habit.dart';
import '../../../domain/usecase/update_habit.dart';

part 'habit_event.dart';
part 'habit_state.dart';

@injectable
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc(
    this._addHabitUC,
    this._updateHabitUC,
    this._deleteHabitUC,
    this._getCurrentUserUC,
    this._getHabitsUC,
    this._addHabitInstanceUC,
  ) : super(HabitInitial()) {
    on<HabitStartedEvent>(_onStarted);
    on<HabitAddEvent>(_onAddHabitEvent);
    on<HabitAddInstanceEvent>(_onAddHabitInstanceEvent);
    on<HabitUpdateEvent>(_onUpdateHabitEvent);
    on<HabitDeleteEvent>(_onDeleteHabitEvent);
  }

  final AddHabitUC _addHabitUC;
  final AddHabitInstanceUC _addHabitInstanceUC;
  final UpdateHabitUC _updateHabitUC;
  final DeleteHabitUC _deleteHabitUC;
  final GetCurrentUserUC _getCurrentUserUC;
  final GetHabitUC _getHabitsUC;

  Stream<QuerySnapshot>? currentSteam;

  void _onStarted(HabitStartedEvent event, Emitter<HabitState> emit) {
    try {
      var user = _getCurrentUserUC();
      if (user != null) {
        final habitStream = _getHabitsUC(user);
        currentSteam = habitStream;
        emit(HabitLoaded(habitStream: habitStream));
      }
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  void _onAddHabitEvent(HabitAddEvent event, Emitter<HabitState> emit) async {
    try {
      final HabitEntity habit = event.habit.copyWith(
        creator: _getCurrentUserUC(),
      );
      final result = await _addHabitUC(habit);

      result.fold(
          (l) => emit(HabitError(message: l.message)),
          (r) => emit(HabitLoaded(
                message: 'Habit added successfully',
                habitStream: currentSteam!,
              )));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  void _onAddHabitInstanceEvent(
      HabitAddInstanceEvent event, Emitter<HabitState> emit) async {
    try {
      await _addHabitInstanceUC(
        AddHabitInstanceParams(
          habit: event.habit,
          date: event.date,
        ),
      );
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  void _onUpdateHabitEvent(
      HabitUpdateEvent event, Emitter<HabitState> emit) async {
    try {
      await _updateHabitUC(event.habit);
      emit(HabitLoaded(
        message: 'Habit updated successfully',
        habitStream: currentSteam!,
      ));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  void _onDeleteHabitEvent(
      HabitDeleteEvent event, Emitter<HabitState> emit) async {
    try {
      await _deleteHabitUC(event.habit);
      emit(HabitLoaded(
        message: 'Habit deleted successfully',
        habitStream: currentSteam!,
      ));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }
}