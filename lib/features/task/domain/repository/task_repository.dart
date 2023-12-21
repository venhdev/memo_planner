import 'package:memo_planner/core/constants/typedef.dart';

import '../entities/myday_entity.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  // get all task in TaskListEntity{lid}
  SQuerySnapshot getAllTaskStream(String lid);
  // Get Stream of [TaskEntity]{tid} from [TaskListEntity]{lid}
  SDocumentSnapshot getOneTaskStream(String lid, String tid);

  ResultVoid addTask(TaskEntity task);
  ResultVoid editTask(TaskEntity updatedTask, TaskEntity oldTask);
  ResultVoid deleteTask(TaskEntity task);
  ResultVoid toggleTask(String tid, String lid, bool value);

  // append {email} to [TaskEntity]{assignedMembers}
  ResultVoid assignTask(String lid, String tid, String email);
  // remove {email} from [TaskEntity]{assignedMembers}
  ResultVoid unassignTask(String lid, String tid, String email);

  //* MyDay
  SDocumentSnapshot getOneMyDayStream(String email, String tid);
  SQuerySnapshot getAllMyDayStream(String email, DateTime today);
  Future<MyDayEntity?> findOneMyDay(String email, String tid);
  ResultVoid addToMyDay(String email, MyDayEntity myDay); // /users/{email}/myday/{tid}
  ResultVoid toggleKeepInMyDay(String email, String tid, bool isKeep); // /users/{email}/myday/{tid}
  ResultVoid removeFromMyDay(String email, MyDayEntity myDay);
}
