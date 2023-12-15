import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/habit_instance_entity.dart';
import '../../../domain/usecase/usecases.dart';

import '../../../domain/entities/habit_entity.dart';

part 'instance_event.dart';
part 'instance_state.dart';

@injectable
class HabitInstanceBloc extends Bloc<InstanceEvent, InstanceState> {
  HabitInstanceBloc(
    this._addHabitInstanceUC,
    this._changeHabitInstanceStatusUC,
    this._updateHabitInstanceUC,
  ) : super(InstanceInitial()) {
    on<InstanceInitialEvent>(_onInitialEvent);
    on<InstanceStatusChangeEvent>(_onChangeStatusEvent);
    on<InstanceUpdateEvent>(_onUpdateEvent);
  }

  final AddHabitInstanceUC _addHabitInstanceUC;
  final ChangeHabitInstanceStatusUC _changeHabitInstanceStatusUC;
  final UpdateHabitInstanceUC _updateHabitInstanceUC;

  void _onInitialEvent(
    InstanceInitialEvent event,
    Emitter<InstanceState> emit,
  ) async {
    final resultEither = await _addHabitInstanceUC(
      AddHabitInstanceParams(
        habit: event.habit,
        date: event.date,
        completed: event.completed,
      ),
    );
    resultEither.fold(
      (l) => emit(InstanceActionFail(message: l.message)),
      (r) => emit(InstanceActionSuccess(
        message: event.completed ? 'Congratulation' : 'Habit status changed',
      )),
    );
  }

  void _onUpdateEvent(
    InstanceUpdateEvent event,
    Emitter<InstanceState> emit,
  ) async {
    final resultEither = await _updateHabitInstanceUC(event.instance);
    resultEither.fold(
      (l) => emit(InstanceActionFail(message: l.message)),
      (r) => emit(const InstanceActionSuccess(message: 'Habit Updated')),
    );
  }

  void _onChangeStatusEvent(
    InstanceStatusChangeEvent event,
    Emitter<InstanceState> emit,
  ) async {
    final resultEither = await _changeHabitInstanceStatusUC(
      ChangeHabitInstanceStatusParams(
        instance: event.instance,
        completed: event.completed,
      ),
    );
    resultEither.fold(
      (l) => emit(InstanceActionFail(message: l.message)),
      (r) => emit(const InstanceActionSuccess(message: 'Habit Status Changed')),
    );
  }
}
