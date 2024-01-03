import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/typedef.dart';
import '../../../../authentication/domain/usecase/get_current_user.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/usecase/add_habit.dart';
import '../../../domain/usecase/add_habit_instance.dart';
import '../../../domain/usecase/delete_habit.dart';
import '../../../domain/usecase/get_habit_stream.dart';
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
    this._getHabitStreamUC,
    this._addHabitInstanceUC,
  ) : super(HabitInitial()) {
    on<HabitEventInitial>(_onInitial);
    on<HabitEventAdd>(_onAddHabitEvent);
    on<HabitEventAddInstance>(_onAddHabitInstanceEvent);
    on<HabitEventUpdate>(_onUpdateHabitEvent);
    on<HabitDeleteEvent>(_onDeleteHabitEvent);
  }

  final AddHabitUC _addHabitUC;
  final AddHabitInstanceUC _addHabitInstanceUC;
  final UpdateHabitUC _updateHabitUC;
  final DeleteHabitUC _deleteHabitUC;
  final GetCurrentUserUC _getCurrentUserUC;
  final GetHabitStreamUC _getHabitStreamUC;

  SQuerySnapshot? currentSteam;

  void _onInitial(HabitEventInitial event, Emitter<HabitState> emit) {
    emit(HabitLoading());
    var user = _getCurrentUserUC();
    if (user != null) {
      final habitStream = _getHabitStreamUC(user);
      currentSteam = habitStream;
      emit(HabitLoaded(habitStream: habitStream));
    } else {
      emit(const HabitError(message: 'User is not authenticated'));
    }
  }

  void _onAddHabitEvent(HabitEventAdd event, Emitter<HabitState> emit) async {
    try {
      final HabitEntity habit = event.habit;
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

  void _onAddHabitInstanceEvent(HabitEventAddInstance event, Emitter<HabitState> emit) async {
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
    HabitEventUpdate event,
    Emitter<HabitState> emit,
  ) async {
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

  void _onDeleteHabitEvent(HabitDeleteEvent event, Emitter<HabitState> emit) async {
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
