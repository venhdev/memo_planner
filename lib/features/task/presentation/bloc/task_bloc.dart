import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../../domain/repository/task_list_repository.dart';
import '../../domain/repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(
    this._taskRepository,
    this._taskListRepository,
    this._authRepository,
  ) : super(const TaskState.initial()) {
    on<TaskInitial>(_onInitial);
  }

  final TaskRepository _taskRepository;
  final TaskListRepository _taskListRepository;
  final AuthRepository _authRepository;

  Future<void> _onInitial(
    TaskInitial event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final currentUser = _authRepository.getCurrentUser();
    //> user is logged in >> load all task reminder
    if (currentUser != null) {
      //> load all reminder
      final resultEither = await _taskListRepository.getAllTaskListOfUser(currentUser.uid!);
      if (resultEither.isRight()) {
        final taskLists = resultEither.getOrElse(() => []);
        if (taskLists.isEmpty) return; // there is no task list >> do nothing
        //> get all lid of task list
        final lids = taskLists.map((e) => e.lid!).toList();
        _taskRepository.loadAllRemindersInMultiLists(lids);
      }
      //> end all reminder

      final taskListStream = _taskListRepository.getAllTaskListStreamOfUser(currentUser.uid!);
      emit(TaskState.loaded(taskListStream));
    } else {
      emit(const TaskState.error('Please login to use this feature'));
    }
  }
}
