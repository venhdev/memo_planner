import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_instance_entity.dart';

abstract class HabitInstanceRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getHabitInstanceStream(
    HabitEntity habit,
    DateTime focusDate,
  );
  ResultEither<HabitInstanceEntity> getHabitInstanceByIid(String iid);

  ResultVoid addHabitInstance(
    HabitEntity habit,
    DateTime date,
  );
  ResultVoid updateHabitInstance(HabitInstanceEntity instance);
  
  ResultVoid changeHabitInstanceStatus(
    HabitInstanceEntity instance,
    bool status,
  );
}
