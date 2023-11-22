import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/error/failures.dart';

import '../../../../core/constants/typedef.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../data_sources/task_data_source.dart';

@Singleton(as: TaskRepository)
class TaskRepositoryImpl extends TaskRepository {
  TaskRepositoryImpl(this._taskDataSource);
  final TaskDataSource _taskDataSource;

  @override
  ResultEither<SQuerySnapshot> getTaskStream(String email) async {
    debugPrint('getTaskStream');
    try {
      var rs = await _taskDataSource.getTaskStream(email);
      return Right(rs);
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }

  @override
  ResultVoid addTask(TaskEntity task) async {
    try {
      return task.creator == null
          ? Left(Failure(code: Code.unauthenticated.name, message: 'User is unauthenticated'))
          : Right(await _taskDataSource.addTask(task));
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }

  @override
  ResultVoid deleteTask(TaskEntity task) async {
    try {
      return Right(await _taskDataSource.deleteTask(task));
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }

  @override
  ResultVoid updateTask(TaskEntity task) async {
    try {
      return Right(await _taskDataSource.updateTask(task));
    } on FirebaseException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(code: Code.unknown.name, message: e.toString()));
    }
  }
}
