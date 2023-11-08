import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_instance_entity.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repository/habit_repository.dart';
import '../data_sources/habit_data_source.dart';

@Singleton(as: HabitRepository)
class HabitRepositoryImpl implements HabitRepository {
  const HabitRepositoryImpl(this._habitDataSource);
  final HabitDataSource _habitDataSource;

  @override
  ResultVoid addHabit(HabitEntity habit) async {
    try {
      await _habitDataSource.addHabit(habit);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }

  @override
  ResultVoid deleteHabit(HabitEntity habit) async {
    try {
      await _habitDataSource.deleteHabit(habit);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }

  @override
  ResultVoid updateHabit(HabitEntity habit) async {
    try {
      _habitDataSource.updateHabit(habit);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }

  @override
  Stream<QuerySnapshot<Object?>> getHabitStream(UserEntity user) {
    try {
      final habits = _habitDataSource.getHabitStream(user);
      return habits;
    } catch (e) {
      debugPrint(
          'HabitRepositoryImpl:getHabitStream:Exception --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      return const Stream.empty();
    }
  }

  @override
  ResultVoid addHabitInstance(HabitEntity habit, DateTime date) async {
    try {
      _habitDataSource.addHabitInstance(habit, date);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getHabitInstanceStream(
      HabitEntity habit, DateTime focusDate) {
    try {
      final habitInstances =
          _habitDataSource.getHabitInstanceStream(habit, focusDate);
      return habitInstances;
    } catch (e) {
      debugPrint(
          'HabitRepositoryImpl:getHabitInstanceStream:Exception --type of e: ${e.runtimeType}');
      debugPrint(e.toString());
      return const Stream.empty();
    }
  }

  @override
  ResultVoid changeHabitInstanceStatus(
      HabitInstanceEntity instance, bool status) async {
    try {
      await _habitDataSource.changeHabitInstanceStatus(instance, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
