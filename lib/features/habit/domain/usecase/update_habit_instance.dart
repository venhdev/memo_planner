import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_instance_entity.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../repository/habit_instance_repository.dart';

@singleton
class UpdateHabitInstanceUC
    extends UseCaseWithParams<ResultVoid, HabitInstanceEntity> {
  UpdateHabitInstanceUC(this._habitInstanceRepository);
  final HabitInstanceRepository _habitInstanceRepository;

  @override
  ResultVoid call(HabitInstanceEntity params) async {
    return await _habitInstanceRepository.updateHabitInstance(params);
  }
}
