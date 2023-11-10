import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/streak_entity.dart';
import '../repository/habit_instance_repository.dart';

@singleton
class GetTopStreakUC
    extends UseCaseWithParams<Future<List<StreakEntity>>, String> {
  GetTopStreakUC(this._repository);

  final HabitInstanceRepository _repository;

  @override
  Future<List<StreakEntity>> call(String params) async {
    return await _repository.getTopStreaks(params);
  }
}
