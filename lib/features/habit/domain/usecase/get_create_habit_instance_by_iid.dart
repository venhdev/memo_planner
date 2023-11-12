import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/core/usecase/usecase.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_instance_entity.dart';
import 'package:memo_planner/features/habit/domain/repository/habit_instance_repository.dart';
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart';

import '../../../../core/utils/convertors.dart';

@singleton
class GetCreateHabitInstanceByIid
    extends UseCaseWithParams<ResultEither<HabitInstanceEntity>, String> {
  GetCreateHabitInstanceByIid(
    this._habitInstanceRepository,
    this._habitRepository,
  );

  final HabitInstanceRepository _habitInstanceRepository;
  final HabitRepository _habitRepository;

  @override
  ResultEither<HabitInstanceEntity> call(String params) async {
    final result = await _habitInstanceRepository.getHabitInstanceByIid(params);

    if (result.isLeft()) {
      var splitIid = params.split('_');
      final habit = await _habitRepository.getHabitByHid(splitIid[0]).then(
            (value) => value.fold(
              (failure) => null,
              (habit) => habit,
            ),
          );
      final date = yyyyMMddDateTime(splitIid[1]);
      await _habitInstanceRepository.addHabitInstance(habit!, date);
    }
    return result;
  }
}
