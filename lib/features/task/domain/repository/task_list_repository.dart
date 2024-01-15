import '../../../../core/constants/typedef.dart';
import '../../../../core/entities/member.dart';
import '../entities/task_list_entity.dart';

abstract class TaskListRepository {
  SQuerySnapshot getAllTaskListStreamOfUser(String uid);
  ResultEither<List<TaskListEntity>> getAllTaskListOfUser(String uid);
  SDocumentSnapshot getOneTaskListStream(String lid);

  ResultVoid addTaskList(TaskListEntity taskList);
  ResultVoid editTaskList(TaskListEntity updatedTaskList);
  ResultVoid deleteTaskList(String lid);

  ResultEither<List<Member>> getMembers(String lid);
  ResultEither<List<String>> getAllMemberTokens(String lid);
  ResultVoid inviteMemberViaEmail(String lid, String email);
  ResultVoid removeMember(String lid, String uid);

  // other function
  Future<int> countTaskList(String lid);
}
