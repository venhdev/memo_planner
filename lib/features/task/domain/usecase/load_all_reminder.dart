import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/task_list_repository.dart';
import '../repository/task_repository.dart';

@singleton
class LoadAllReminderUC extends UseCaseWithParams<void, String> {
  LoadAllReminderUC(this._taskRepository, this._taskListRepository);

  final TaskListRepository _taskListRepository;
  final TaskRepository _taskRepository;

  // *params: user's uid
  @override
  void call(String params) async {
    final listsEither = await _taskListRepository.getAllTaskListOfUser(params);
    if (listsEither.isRight()) {
      final lists = listsEither.getOrElse(() => []);
      if (lists.isEmpty) return; // there is no task list >> do nothing
      final lids = lists.map((e) => e.lid!).toList();
      await _taskRepository.loadAllRemindersInMultiLists(lids);
    }
  }
}
