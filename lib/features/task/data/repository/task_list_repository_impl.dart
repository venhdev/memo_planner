import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/core/error/failures.dart';
import 'package:memo_planner/features/task/domain/entities/task_list_entity.dart';

import '../../domain/repository/task_list_repository.dart';
import '../data_sources/firestore_task_data_source.dart';

@Singleton(as: TaskListRepository)
class TaskListRepositoryImpl implements TaskListRepository {
  TaskListRepositoryImpl(this._dataSource);

  final FireStoreTaskDataSource _dataSource;

  @override
  ResultVoid addMember(String tid, String email) {
    throw UnimplementedError();
  }

  @override
  ResultVoid addTaskList(TaskListEntity taskList) async {
    try {
      return Right(await _dataSource.addTaskList(taskList));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteTaskList(String tid) {
    throw UnimplementedError();
  }

  @override
  ResultVoid editTaskList(TaskListEntity updatedTaskList) {
    throw UnimplementedError();
  }

  @override
  SQuerySnapshot getAllTaskListStreamOfUser(String email) {
    try {
      return _dataSource.getAllTaskListStreamOfUser(email);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultVoid removeMember(String tid, String email) {
    throw UnimplementedError();
  }

  @override
  SDocumentSnapshot getOneTaskListStream(String lid) {
    try {
      return _dataSource.getOneTaskListStream(lid);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }
}
