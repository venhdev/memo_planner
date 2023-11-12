import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/habit_entity.dart';

@singleton
class GetHabitByHidUC
    extends UseCaseWithParams<ResultEither<HabitEntity>, String> {
  GetHabitByHidUC(this._habitRepository);

  final HabitRepository _habitRepository;
  @override
  ResultEither<HabitEntity> call(String params) async {
    return await _habitRepository.getHabitByHid(params);
  }
}
