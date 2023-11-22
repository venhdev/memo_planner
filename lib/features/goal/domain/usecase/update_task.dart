import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

@singleton
class UpdateTaskUC extends UseCaseWithParams<ResultVoid, TaskEntity> {
  UpdateTaskUC(this._taskRepository);
  final TaskRepository _taskRepository;

  @override
  ResultVoid call(TaskEntity params) async {
    return await _taskRepository.updateTask(params);
  }
}
