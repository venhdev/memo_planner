import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';
import 'package:memo_planner/features/goal/domain/repository/task_repository.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/task_entity.dart';

@singleton
class DeleteTaskUC extends UseCaseWithParams<ResultVoid, TaskEntity> {
  DeleteTaskUC(this._taskRepository);

  final TaskRepository _taskRepository;
  @override
  ResultVoid call(TaskEntity params) async {
    return await _taskRepository.deleteTask(params);
  }
}
