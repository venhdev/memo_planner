import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/core/error/failures.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repository/habit_repository.dart';

@Singleton(as: HabitRepository)
class HabitRepositoryImpl implements HabitRepository {
  final HabitDataSource _habitDataSource;

  const HabitRepositoryImpl(this._habitDataSource);

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
  ResultFuture<Stream<List<HabitEntity>>> getHabits(UserEntity creator) async {
    try {
      final habits = await _habitDataSource.getHabits(creator);
      return Right(habits);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
