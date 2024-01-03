import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_list_entity.dart';

import '../../../authentication/data/data_sources/authentication_data_source.dart';
import '../../domain/repository/task_list_repository.dart';
import '../data_sources/firestore_task_data_source.dart';

@Singleton(as: TaskListRepository)
class TaskListRepositoryImpl implements TaskListRepository {
  TaskListRepositoryImpl(this._dataSource, this._authDataSource);

  final FireStoreTaskDataSource _dataSource;
  final AuthenticationDataSource _authDataSource;

  @override
  ResultVoid addMember(String tid, String email) async {
    try {
      final user = await _authDataSource.getUserByEmail(email);
      if (user == null) {
        return const Left(FirebaseFailure(message: 'User not found'));
      }
      return Right(_dataSource.addMember(tid, email));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid addTaskList(TaskListEntity taskList) async {
    try {
      return Right(await _dataSource.addTaskList(taskList));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteTaskList(String lid) async {
    try {
      await _dataSource.deleteTaskList(lid);

      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid editTaskList(TaskListEntity updatedTaskList) async {
    try {
      return Right(await _dataSource.editTaskList(updatedTaskList));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  SQuerySnapshot getAllTaskListStreamOfUser(String email) {
    try {
      return _dataSource.getAllTaskListStreamOfUser(email);
    } catch (e) {
      log('getAllTaskListStreamOfUser Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultVoid removeMember(String tid, String email) async {
    try {
      return Right(_dataSource.removeMember(tid, email));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  SDocumentSnapshot getOneTaskListStream(String lid) {
    try {
      return _dataSource.getOneTaskListStream(lid);
    } catch (e) {
      log('getOneTaskListStream Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  Future<int> countTaskList(String lid) async {
    try {
      return await _dataSource.countTaskList(lid);
    } catch (e) {
      log('countTaskList Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return -1;
    }
  }

  @override
  ResultEither<List<String>> getMembers(String lid) async {
    try {
      return Right(await _dataSource.getMembers(lid));
    } catch (e) {
      log('getMembers Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultEither<List<String>> getAllMemberTokens(String lid) async {
    try {
      return Right(await _dataSource.getAllMemberTokens(lid));
    } catch (e) {
      log('getAllMemberTokens Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultEither<List<TaskListEntity>> getAllTaskListOfUser(String email) async {
    try {
      return Right(await _dataSource.getAllTaskListOfUser(email));
    } catch (e) {
      log('getAllTaskListOfUser Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
