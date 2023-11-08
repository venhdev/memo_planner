import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memo_planner/features/habit/domain/entities/habit_instance_entity.dart';

import '../../../../core/constants/typedef.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../entities/habit_entity.dart';

abstract class HabitRepository {
  Stream<QuerySnapshot> getHabitStream(UserEntity user);
  ResultVoid addHabit(HabitEntity habit);
  ResultVoid updateHabit(HabitEntity habit);
  ResultVoid deleteHabit(HabitEntity habit);

  Stream<QuerySnapshot<Map<String, dynamic>>> getHabitInstanceStream(
    HabitEntity habit,
    DateTime focusDate,
  );
  ResultVoid addHabitInstance(
    HabitEntity habit,
    DateTime date,
  );
  ResultVoid changeHabitInstanceStatus(
    HabitInstanceEntity instance,
    bool status,
  );
}
