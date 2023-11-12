import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/habit/domain/entities/streak_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/habit_repository.dart';

@singleton
class GetTopStreakUC
    extends UseCaseWithParams<ResultEither<StreakEntity>, String> {
  GetTopStreakUC(this._habitRepository);

  final HabitRepository _habitRepository;

  @override
  ResultEither<StreakEntity> call(String params) async {
    return await _habitRepository.getTopStreaks(params);
  }
}
