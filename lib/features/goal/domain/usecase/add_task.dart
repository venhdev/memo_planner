import 'dart:developer';

import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

@singleton
class AddTaskUC extends UseCaseWithParams<ResultVoid, TaskEntity> {
  AddTaskUC(this._taskRepository, this._authenticationRepository);

  final TaskRepository _taskRepository;
  final AuthenticationRepository _authenticationRepository;
  @override
  ResultVoid call(TaskEntity params) async {
    final user = _authenticationRepository.getCurrentUser();
    params = params.copyWith(creator: user);
    log('AddTaskUC');
    log('TaskEntity params: $params');
    return await _taskRepository.addTask(params);
  }
}
