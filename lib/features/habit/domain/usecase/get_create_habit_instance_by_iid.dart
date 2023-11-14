import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/habit_instance_entity.dart';
import '../repository/habit_instance_repository.dart';
import '../repository/habit_repository.dart';

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
    var instanceEither =
        await _habitInstanceRepository.getHabitInstanceByIid(params);

    // if this true it mean the instance is not created yet
    if (instanceEither.isLeft()) {
      var splitIid = params.split('_'); // hid_yyyyMMdd
      final habit = await _habitRepository.getHabitByHid(splitIid[0]).then(
            (value) => value.fold(
              (failure) => null,
              (habit) => habit,
            ),
          );
      final date = DateTime.parse(splitIid[1]);
      instanceEither =
          await _habitInstanceRepository.addHabitInstance(habit!, date, false);
    }
    return instanceEither;
  }
}
