// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/task/domain/entities/task_entity.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repository/task_repository.dart';
import '../data_sources/firestore_task_data_source.dart';

@Singleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._dataSource);

  final FireStoreTaskDataSource _dataSource;

  @override
  ResultVoid addTask(TaskEntity task) async {
    try {
      await _dataSource.addTask(task);

      return const Right(null);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid assignTask(String tid, String lid, String email) {
    // TODO: implement assignTask
    throw UnimplementedError();
  }

  @override
  ResultVoid deleteTask(String tid, String lid) async {
    try {
      return Right(await _dataSource.deleteTask(tid, lid));
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid editTask(TaskEntity updatedTask) {
    // TODO: implement editTask
    throw UnimplementedError();
  }

  @override
  SDocumentSnapshot getOneTaskStream(String tid, String lid) {
    // TODO: implement getOneTaskStream
    throw UnimplementedError();
  }

  @override
  ResultVoid unassignTask(String tid, String lid, String email) {
    // TODO: implement unassignTask
    throw UnimplementedError();
  }

  @override
  SQuerySnapshot getAllTaskStream(String lid) {
    try {
      return _dataSource.getAllTaskStream(lid);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }
}
