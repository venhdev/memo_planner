import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/typedef.dart';
import '../../../../authentication/domain/usecase/get_current_user.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/usecase/usecases.dart';

part 'task_event.dart';
part 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(
    this._getTaskStreamUC,
    this._addTaskUC,
    this._updateTaskUC,
    this._deleteTaskUC,
    this._getCurrentUserUC,
  ) : super(const TaskState.initial()) {
    on<TaskEventInitial>(_onInitial);
    on<TaskEventAdded>(_onAdded);
    on<TaskEventUpdated>(_onUpdated);
    on<TaskEventDeleted>(_onDeleted);
  }

  final GetCurrentUserUC _getCurrentUserUC;
  final GetTaskStreamUC _getTaskStreamUC;
  final AddTaskUC _addTaskUC;
  final UpdateTaskUC _updateTaskUC;
  final DeleteTaskUC _deleteTaskUC;

  void _onInitial(TaskEventInitial event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.loading));
    var user = _getCurrentUserUC();
    if (user != null) {
      var streamEither = await _getTaskStreamUC(user.email!);
      streamEither.fold(
        (l) => emit(state.copyWith(status: TaskStatus.failure, message: l.message)),
        (r) => emit(state.copyWith(status: TaskStatus.loaded, stream: r)),
      );
    } else {
      emit(state.copyWith(status: TaskStatus.failure, message: 'User not found'));
    }
  }

  void _onAdded(TaskEventAdded event, Emitter<TaskState> emit) async {
    final rs = await _addTaskUC(event.task);
    rs.fold(
      (l) => emit(state.copyWith(status: TaskStatus.failure, message: l.message)),
      (r) => emit(state.copyWith(status: TaskStatus.success, message: 'Task added'))
    );
  }

  void _onUpdated(TaskEventUpdated event, Emitter<TaskState> emit) async {
    final rs = await _updateTaskUC(event.task);
    rs.fold(
      (l) => emit(state.copyWith(status: TaskStatus.failure, message: l.message)),
      (r) => emit(state.copyWith(status: TaskStatus.success, message: 'Task updated')),
    );
  }

  void _onDeleted(TaskEventDeleted event, Emitter<TaskState> emit) async {
    final rs = await _deleteTaskUC(event.task);

    rs.fold(
      (l) => emit(state.copyWith(status: TaskStatus.failure, message: l.message)),
      (r) => emit(state.copyWith(status: TaskStatus.success, message: 'Task deleted')),
    );
  }
}
