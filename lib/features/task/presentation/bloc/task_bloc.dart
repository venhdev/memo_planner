import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';
import '../../../authentication/domain/usecase/get_current_user.dart';
import '../../domain/usecase/get_all_task_stream.dart';

part 'task_event.dart';
part 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(
    this._getAllTaskStreamOfUserUC,
    this._getCurrentUserUC,
  ) : super(const TaskState.initial()) {
    on<TaskEventInitial>(_onInitial);
  }

  final GetAllTaskStreamOfUserUC _getAllTaskStreamOfUserUC;
  final GetCurrentUserUC _getCurrentUserUC;

  Future<void> _onInitial(
    TaskEventInitial event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final user = _getCurrentUserUC();
    if (user != null) {
      final taskStream = _getAllTaskStreamOfUserUC(user);
      emit(TaskState.loaded(taskStream));
    } else {
      emit(const TaskState.error('Please login to continue!'));
    }
  }
}
