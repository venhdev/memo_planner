import '../../../../core/constants/typedef.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../entities/habit_entity.dart';

abstract class HabitRepository {
  ResultFuture<Stream<List<HabitEntity>>> getHabits(UserEntity creator);
  ResultVoid addHabit(HabitEntity habit);
  ResultVoid updateHabit(HabitEntity habit);
  ResultVoid deleteHabit(HabitEntity habit);
}
