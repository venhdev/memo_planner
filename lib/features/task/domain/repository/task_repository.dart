import 'package:memo_planner/core/constants/typedef.dart';

import '../entities/task_entity.dart';

abstract class TaskRepository {
  /// get all task in TaskListEntity{lid}
  SQuerySnapshot getAllTaskStream(String lid);
  /// Get Stream of [TaskEntity]{tid} from [TaskListEntity]{lid}
  SDocumentSnapshot getOneTaskStream(String tid, String lid);


  ResultVoid addTask(TaskEntity task);
  ResultVoid editTask(TaskEntity updatedTask);
  ResultVoid deleteTask(String tid, String lid);

  // assign task to user
  /// append {email} to [TaskEntity]{assignedMembers}
  ResultVoid assignTask(String tid, String lid, String email);
  /// remove {email} from [TaskEntity]{assignedMembers}
  ResultVoid unassignTask(String tid, String lid, String email); 
}