import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart';
import 'package:memo_planner/features/habit/domain/entities/streak_entity.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_instance_entity.dart';
import '../../domain/repository/habit_instance_repository.dart';
import '../data_sources/habit_instance_data_source.dart';

@Singleton(as: HabitInstanceRepository)
class HabitInstanceRepositoryImpl implements HabitInstanceRepository {
  const HabitInstanceRepositoryImpl(this._habitInstanceDataSource, this._dataSource,);
  final HabitInstanceDataSource _habitInstanceDataSource;
  final HabitDataSource _dataSource;

  @override
  ResultVoid addHabitInstance(HabitEntity habit, DateTime date) async {
    try {
      _habitInstanceDataSource.addHabitInstance(habit, date);
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
          _habitInstanceDataSource.getHabitInstanceStream(habit, focusDate);
      return habitInstances;
    } catch (e) {
      debugPrint(e.toString());
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
  Future<List<StreakEntity>> getTopStreaks(String hid) async {
    try {
      final habit = await _dataSource.getHabitByHid(hid);
      final streaks = await _habitInstanceDataSource.getTopStreakOfHabit(habit!);
      return streaks;
    } catch (e) {
      debugPrint(e.toString());
      return const [];
    }
  }
}
