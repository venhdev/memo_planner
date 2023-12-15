import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../repository/habit_repository.dart';

import '../entities/habit_entity.dart';

@singleton
class UpdateHabitUC extends UseCaseWithParams<ResultEither, HabitEntity> {
  UpdateHabitUC(this._habitRepository);
  final HabitRepository _habitRepository;


  @override
  ResultEither<void> call(HabitEntity params) async {
    return await _habitRepository.updateHabit(params);
  }
}
