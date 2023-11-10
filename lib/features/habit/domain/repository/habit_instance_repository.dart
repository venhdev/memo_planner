import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_instance_entity.dart';
import '../entities/streak_entity.dart';

abstract class HabitInstanceRepository {
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
  Future<List<StreakEntity>> getTopStreaks(String hid);
}
