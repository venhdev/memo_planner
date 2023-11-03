import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/habit_entity.dart';
import '../repository/habit_repository.dart';

@singleton
class AddHabitUC extends UseCaseWithParams<ResultVoid, HabitEntity> {
  AddHabitUC(this._habitRepository);
  final HabitRepository _habitRepository;

  @override
  ResultVoid call(HabitEntity params) async {
    return await _habitRepository.addHabit(params);
  }
}
