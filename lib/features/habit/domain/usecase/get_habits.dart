import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart';

import '../../../authentication/domain/entities/user_entity.dart';
import '../entities/habit_entity.dart';

@singleton
class GetHabitsUC
    extends UseCaseWithParams<Stream<List<HabitEntity>>, UserEntity> {
  final HabitRepository _habitRepository;

  GetHabitsUC(this._habitRepository);

  @override
  ResultFuture<Stream<List<HabitEntity>>> call(UserEntity params) {
    return _habitRepository.getHabits(params);
  }
}
