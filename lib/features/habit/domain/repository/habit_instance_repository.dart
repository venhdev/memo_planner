import '../../../../core/constants/typedef.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_instance_entity.dart';

abstract class HabitInstanceRepository {
  SQuerySnapshot getHabitInstanceStream(
    HabitEntity habit,
    DateTime focusDate,
  );
  ResultEither<HabitInstanceEntity> getHabitInstanceByIid(String iid);

  ResultEither<HabitInstanceEntity> addHabitInstance(
    HabitEntity habit,
    DateTime date,
    bool completed
  );
  ResultVoid updateHabitInstance(HabitInstanceEntity instance);
  
  ResultVoid changeHabitInstanceStatus(
    HabitInstanceEntity instance,
    bool status,
  );
}
