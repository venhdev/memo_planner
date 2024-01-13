// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/task/domain/entities/myday_entity.dart';
import 'package:memo_planner/features/task/domain/entities/task_entity.dart';

import '../../../../core/constants/enum.dart';
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
      log('addTask Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteTask(TaskEntity task) async {
    try {
      return Right(await _dataSource.deleteTask(task));
    } catch (e) {
      log('deleteTask Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid editTask(TaskEntity updatedTask, TaskEntity oldTask) async {
    try {
      return Right(await _dataSource.editTask(updatedTask, oldTask));
    } catch (e) {
      log('editTask Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  SDocumentSnapshot getOneTaskStream(String lid, String tid) {
    try {
      return _dataSource.getOneTaskStream(lid, tid);
    } catch (e) {
      log('getOneTaskStream Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  SQuerySnapshot getAllTaskStream(String lid, {TaskSortOptions sortBy = TaskSortOptions.none}) {
    try {
      return _dataSource.getAllTaskStream(lid, sortBy);
    } catch (e) {
      log('getAllTaskStream Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultVoid toggleTask(String tid, String lid, bool value) async {
    try {
      return Right(_dataSource.toggleTask(tid, lid, value));
    } catch (e) {
      log('toggleTask Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid assignTask(String lid, String tid, String email) async {
    try {
      await _dataSource.assignTask(lid, tid, email);
      return const Right(null);
    } catch (e) {
      log('assignTask Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid unassignTask(String lid, String tid, String email) async {
    try {
      await _dataSource.unassignTask(lid, tid, email);
      return const Right(null);
    } catch (e) {
      log('unassignTask Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid addToMyDay(String email, MyDayEntity myDay) async {
    try {
      await _dataSource.addToMyDay(email, myDay);
      return const Right(null);
    } catch (e) {
      log('addToMyDay Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid removeFromMyDay(String email, MyDayEntity myDay) async {
    try {
      _dataSource.removeFromMyDay(email, myDay);
      return const Right(null);
    } catch (e) {
      log('removeFromMyDay Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  SDocumentSnapshot getOneMyDayStream(String email, String tid) {
    try {
      return _dataSource.getOneMyDayStream(email, tid);
    } catch (e) {
      log('getOneMyDayStream Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultVoid toggleKeepInMyDay(String email, String tid, bool isKeep) async {
    try {
      return Right(await _dataSource.toggleKeepInMyDay(email, tid, isKeep));
    } catch (e) {
      log('toggleKeepInMyDay Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  // @override
  // Future<MyDayEntity?> findOneMyDay(String email, String tid) async {
  //   try {
  //     final result = await _dataSource.findOneMyDay(email, tid);
  //     return result;
  //   } catch (e) {
  //     log('findOneMyDay Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
  //     return null;
  //   }
  // }

  @override
  SQuerySnapshot getAllMyDayStream(String email, DateTime today) {
    try {
      _dataSource.removeMismatchInMyDay(email, today);
      return _dataSource.getAllMyDayStream(email);
    } catch (e) {
      log('getAllMyDayStream Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultEither<List<TaskEntity>> getAllTask(String lid) async {
    try {
      return Right(await _dataSource.getAllTaskInSingleList(lid));
    } catch (e) {
      log('getAllTask Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultEither<List<TaskEntity>> getAllTaskInMultiLists(List<String> lids) async {
    try {
      List<TaskEntity> result = [];
      for (final lid in lids) {
        final taskList = await _dataSource.getAllTaskInSingleList(lid);
        result.addAll(taskList);
      }
      return Right(result);
    } catch (e) {
      log('getAllTaskInMultiLists Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid loadAllRemindersInMultiLists(List<String> lids) async {
    try {
      for (final lid in lids) {
        _dataSource.loadAllRemindersInSingleList(lid);
      }
      return const Right(null);
    } catch (e) {
      log('loadAllRemindersInMultiLists Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid loadAllRemindersInSingleList(String lid) async {
    try {
      return Right(await _dataSource.loadAllRemindersInSingleList(lid));
    } catch (e) {
      log('loadAllRemindersInSingleList Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
