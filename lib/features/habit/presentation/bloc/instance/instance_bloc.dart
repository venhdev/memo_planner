import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_instance_entity.dart';
import 'package:memo_planner/features/habit/domain/usecase/usecases.dart';

import '../../../domain/entities/habit_entity.dart';

part 'instance_event.dart';
part 'instance_state.dart';

@injectable
class HabitInstanceBloc extends Bloc<InstanceEvent, InstanceState> {
  HabitInstanceBloc(
    this._addHabitInstanceUC,
    this._changeHabitInstanceStatusUC,
  ) : super(InstanceInitial()) {
    on<InstanceInitialEvent>(_onInitialEvent);
    on<InstanceStatusChangeEvent>(_onChangeStatusEvent);
  }

  final AddHabitInstanceUC _addHabitInstanceUC;
  final ChangeHabitInstanceStatusUC _changeHabitInstanceStatusUC;

  void _onInitialEvent(
    InstanceInitialEvent event,
    Emitter<InstanceState> emit,
  ) async {
    final resultEither = await _addHabitInstanceUC(
      AddHabitInstanceParams(
        habit: event.habit,
        date: event.date,
      ),
    );
    resultEither.fold(
      (l) => emit(InstanceActionFail(message: l.message)),
      (r) => emit(const InstanceActionSuccess(message: 'Congratulation!')),
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
      (r) => emit(const InstanceActionSuccess(message: 'Congrats!')),
    );
  }
}