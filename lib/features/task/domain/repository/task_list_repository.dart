import '../../../../core/constants/typedef.dart';
import '../entities/task_list_entity.dart';

abstract class TaskListRepository {
  SQuerySnapshot getAllTaskListStreamOfUser(String email);
  ResultEither<List<TaskListEntity>> getAllTaskListOfUser(String email);
  SDocumentSnapshot getOneTaskListStream(String lid);

  ResultVoid addTaskList(TaskListEntity taskList);
  ResultVoid editTaskList(TaskListEntity updatedTaskList);
  ResultVoid deleteTaskList(String lid);

  ResultEither<List<String>> getMembers(String lid);
  ResultEither<List<String>> getAllMemberTokens(String lid);
  ResultVoid addMember(String lid, String email);
  ResultVoid removeMember(String lid, String email);

  // other function
  Future<int> countTaskList(String lid);
}
