import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/repository/habit_instance_repository.dart';
import '../data_sources/habit_instance_data_source.dart';

@Singleton(as: HabitInstanceRepository)
class HabitInstanceRepositoryImpl implements HabitInstanceRepository {
  const HabitInstanceRepositoryImpl(this._habitInstanceDataSource);
  final HabitInstanceDataSource _habitInstanceDataSource;

  @override
  ResultEither<HabitInstanceEntity> addHabitInstance(HabitEntity habit, DateTime date, bool completed) async {
    try {
      final instance = await _habitInstanceDataSource.initNewHabitInstance(habit, date, completed);
      return Right(instance);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }

  @override
  SQuerySnapshot getHabitInstanceStream(
      HabitEntity habit, DateTime focusDate) {
    try {
      final habitInstances =
          _habitInstanceDataSource.getHabitInstanceStream(habit, focusDate);
      return habitInstances;
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Stream.empty();
    }
  }

  @override
  ResultVoid changeHabitInstanceStatus(
      HabitInstanceEntity instance, bool status) async {
    try {
      await _habitInstanceDataSource.changeHabitInstanceStatus(
          instance, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
  
  @override
  ResultEither<HabitInstanceEntity> getHabitInstanceByIid(String iid) async {
    try {
      final instance = await _habitInstanceDataSource.findHabitInstanceById(iid);
      if (instance != null) {
        return Right(instance);
      } else {
        return const Left(ServerFailure(message: 'Habit instance not found'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
  
  @override
  ResultVoid updateHabitInstance(HabitInstanceEntity instance) async {
    try {
      _habitInstanceDataSource.updateHabitInstance(instance);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
