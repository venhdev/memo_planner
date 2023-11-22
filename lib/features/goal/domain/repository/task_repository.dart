import '../../../../core/constants/typedef.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  ResultVoid addTask(TaskEntity task);
  ResultVoid updateTask(TaskEntity task);
  ResultVoid deleteTask(TaskEntity task);
  ResultEither<SQuerySnapshot> getTaskStream(String email);
}
