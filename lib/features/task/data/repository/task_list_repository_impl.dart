import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/entities/member.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_list_entity.dart';

import '../../../authentication/data/data_sources/authentication_data_source.dart';
import '../../domain/repository/task_list_repository.dart';
import '../data_sources/firestore_task_data_source.dart';

@Singleton(as: TaskListRepository)
class TaskListRepositoryImpl implements TaskListRepository {
  TaskListRepositoryImpl(this._taskDataSource, this._authDataSource);

  final FireStoreTaskDataSource _taskDataSource;
  final AuthenticationDataSource _authDataSource;

  @override
  ResultVoid inviteMemberViaEmail(String lid, String email) async {
    try {
      final user = await _authDataSource.getUserByEmail(email);
      if (user == null) {
        return const Left(UserFailure(message: 'This email is not registered yet'));
      }
      Member member = Member(uid: user.uid!, role: UserRole.member);
      return Right(_taskDataSource.addMemberToTaskList(lid, member));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid addTaskList(TaskListEntity taskList) async {
    try {
      return Right(await _taskDataSource.addTaskList(taskList));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteTaskList(String lid) async {
    try {
      await _taskDataSource.deleteTaskList(lid);

      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid editTaskList(TaskListEntity updatedTaskList) async {
    try {
      return Right(await _taskDataSource.editTaskList(updatedTaskList));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  SQuerySnapshot getAllTaskListStreamOfUser(String uid) {
    try {
      return _taskDataSource.getAllTaskListStreamOfUser(uid);
    } catch (e) {
      log('getAllTaskListStreamOfUser Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultVoid removeMember(String tid, String uid) async {
    try {
      return Right(_taskDataSource.removeMember(tid, uid));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  SDocumentSnapshot getOneTaskListStream(String lid) {
    try {
      return _taskDataSource.getOneTaskListStream(lid);
    } catch (e) {
      log('getOneTaskListStream Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  Future<int> countTaskList(String lid) async {
    try {
      return await _taskDataSource.countTaskList(lid);
    } catch (e) {
      log('countTaskList Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return -1;
    }
  }

  @override
  ResultEither<List<Member>> getMembers(String lid) async {
    try {
      return Right(await _taskDataSource.getMembers(lid));
    } catch (e) {
      log('getMembers Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultEither<List<String>> getAllMemberTokens(String lid) async {
    try {
      return Right(await _taskDataSource.getAllMemberTokens(lid));
    } catch (e) {
      log('getAllMemberTokens Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultEither<List<TaskListEntity>> getAllTaskListOfUser(String uid) async {
    try {
      return Right(await _taskDataSource.getAllTaskListOfUser(uid));
    } catch (e) {
      log('getAllTaskListOfUser Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
