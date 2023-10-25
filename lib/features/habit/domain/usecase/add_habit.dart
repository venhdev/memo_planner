import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart';

import '../entities/habit_entity.dart';

@singleton
class AddHabitUC extends UseCaseWithParams<void, HabitEntity> {
  final HabitRepository _habitRepository;

  AddHabitUC(this._habitRepository);

  @override
  ResultFuture<void> call(HabitEntity params) async {
    return await _habitRepository.addHabit(params);
  }
}
