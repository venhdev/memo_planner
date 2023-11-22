import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';
import 'package:memo_planner/features/goal/domain/repository/task_repository.dart';

import '../../../../core/constants/typedef.dart';

@singleton
class GetTaskStreamUC extends UseCaseWithParams<ResultEither<SQuerySnapshot>, String> {
  GetTaskStreamUC(this._taskRepository);

  final TaskRepository _taskRepository;
  @override
  ResultEither<SQuerySnapshot> call(String params) async {
    debugPrint('GetTaskStreamUC');
    return await _taskRepository.getTaskStream(params);
  }
}
