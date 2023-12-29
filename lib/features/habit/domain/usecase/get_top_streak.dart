import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/streak_entity.dart';
import '../repository/habit_repository.dart';

@singleton
class GetTopStreakUC
    extends UseCaseWithParams<ResultEither<StreakEntity>, GetTopStreakParams> {
  GetTopStreakUC(this._habitRepository);

  final HabitRepository _habitRepository;

  @override
  ResultEither<StreakEntity> call(GetTopStreakParams params) async {
    return await _habitRepository.getTopStreaks(params.hid, params.email);
  }
}

class GetTopStreakParams {
  const GetTopStreakParams(this.hid, this.email);

  final String hid;
  final String email;
}