import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';
import '../../../authentication/domain/usecase/get_current_user.dart';
import '../../domain/usecase/get_all_task_list_stream.dart';
import '../../domain/usecase/load_all_reminder.dart';

part 'task_event.dart';
part 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(
    this._getAllTaskStreamOfUserUC,
    this._getCurrentUserUC,
    this._loadAllReminderUC,
  ) : super(const TaskState.initial()) {
    on<TaskInitial>(_onInitial);
  }

  final GetAllTaskListStreamOfUserUC _getAllTaskStreamOfUserUC;
  final GetCurrentUserUC _getCurrentUserUC;
  final LoadAllReminderUC _loadAllReminderUC;

  Future<void> _onInitial(
    TaskInitial event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final user = _getCurrentUserUC();
    if (user != null) {
      // test: load all reminder and notification to local notification manager
      _loadAllReminderUC(user.email!);

      final taskListStream = _getAllTaskStreamOfUserUC(user);
      emit(TaskState.loaded(taskListStream));
    } else {
      emit(const TaskState.error('Please login to continue!'));
    }
  }
}
