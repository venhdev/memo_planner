// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/task/domain/entities/myday_entity.dart';
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
      log('addTask object: ${task.toString()}');
      log('reminders object: ${task.reminders.toString()}');
      log('priority object: ${task.priority.toString()}');
      await _dataSource.addTask(task);
      return const Right(null);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteTask(TaskEntity task) async {
    try {
      return Right(await _dataSource.deleteTask(task));
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid editTask(TaskEntity updatedTask, TaskEntity oldTask) async {
    try {
      return Right(await _dataSource.editTask(updatedTask, oldTask));
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  SDocumentSnapshot getOneTaskStream(String lid, String tid) {
    try {
      return _dataSource.getOneTaskStream(lid, tid);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
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

  @override
  ResultVoid toggleTask(String tid, String lid, bool value) async {
    try {
      return Right(_dataSource.toggleTask(tid, lid, value));
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid assignTask(String lid, String tid, String email) async {
    try {
      await _dataSource.assignTask(lid, tid, email);
      return const Right(null);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid unassignTask(String lid, String tid, String email) async {
    try {
      await _dataSource.unassignTask(lid, tid, email);
      return const Right(null);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid addToMyDay(String email, MyDayEntity myDay) async {
    try {
      await _dataSource.addToMyDay(email, myDay);
      return const Right(null);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  ResultVoid removeFromMyDay(String email, MyDayEntity myDay) async {
    try {
      _dataSource.removeFromMyDay(email, myDay);
      return const Right(null);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  SDocumentSnapshot getOneMyDayStream(String email, String tid) {
    try {
      return _dataSource.getOneMyDayStream(email, tid);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultVoid toggleKeepInMyDay(String email, String tid, bool isKeep) async {
    try {
      return Right(await _dataSource.toggleKeepInMyDay(email, tid, isKeep));
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<MyDayEntity?> findOneMyDay(String email, String tid) async {
    try {
      final result = await _dataSource.findOneMyDay(email, tid);
      return result;
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return null;
    }
  }

  @override
  SQuerySnapshot getAllMyDayStream(String email, DateTime today) {
    try {
      _dataSource.removeMismatchInMyDay(email, today);
      return _dataSource.getAllMyDayStream(email);
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

}
