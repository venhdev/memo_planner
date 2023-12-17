import 'package:memo_planner/core/constants/typedef.dart';

import '../entities/task_entity.dart';

abstract class TaskRepository {
  /// get all task in TaskListEntity{lid}
  SQuerySnapshot getAllTaskStream(String lid);

  /// Get Stream of [TaskEntity]{tid} from [TaskListEntity]{lid}
  SDocumentSnapshot getOneTaskStream(String lid, String tid);

  ResultVoid addTask(TaskEntity task);
  ResultVoid editTask(TaskEntity updatedTask, TaskEntity oldTask);
  ResultVoid deleteTask(TaskEntity task);
  ResultVoid toggleTask(String tid, String lid, bool value);

  // assign task to user
  /// append {email} to [TaskEntity]{assignedMembers}
  ResultVoid assignTask(String lid, String tid, String email);

  /// remove {email} from [TaskEntity]{assignedMembers}
  ResultVoid unassignTask(String lid, String tid, String email);
}
