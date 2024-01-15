import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';

import '../entities/myday_entity.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  /// Get all task stream in a task list
  SQuerySnapshot getAllTaskStream(String lid, {TaskSortOptions sortBy = TaskSortOptions.none});

  /// Get all [TaskEntity] in a task list
  ResultEither<List<TaskEntity>> getAllTask(String lid);

  /// Get all [TaskEntity] in multi task list. [lids] is a list of taskList id
  ResultEither<List<TaskEntity>> getAllTaskInMultiLists(List<String> lids);
  ResultVoid loadAllRemindersInSingleList(String lid);
  ResultVoid loadAllRemindersInMultiLists(List<String> lids);

  /// Get a Stream of [TaskEntity] in a task list
  SDocumentSnapshot getOneTaskStream(String lid, String tid);

  ResultVoid addTask(TaskEntity task);
  ResultVoid editTask(TaskEntity updatedTask, TaskEntity oldTask);
  ResultVoid deleteTask(TaskEntity task);
  ResultVoid toggleTask(String tid, String lid, bool value);

  /// append {email} to [TaskEntity]{assignedMembers}
  ResultVoid assignTask(String lid, String tid, String email);

  /// remove {email} from [TaskEntity]{assignedMembers}
  ResultVoid unassignTask(String lid, String tid, String email);

  //! MyDay
  SDocumentSnapshot getOneMyDayStream(String uid, String tid);
  SQuerySnapshot getAllMyDayStream(String email, DateTime today);
  // Future<MyDayEntity?> findOneMyDay(String email, String tid);
  ResultVoid addToMyDay(String uid, MyDayEntity myDay); // /users/{uid}/myday/{tid}
  ResultVoid toggleKeepInMyDay(String email, String tid, bool isKeep); // /users/{email}/myday/{tid}
  ResultVoid removeFromMyDay(String email, MyDayEntity myDay);
}
