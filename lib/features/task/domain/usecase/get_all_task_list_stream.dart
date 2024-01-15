import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../repository/task_list_repository.dart';

@singleton
class GetAllTaskListStreamOfUserUC extends UseCaseWithParams<SQuerySnapshot, UserEntity> {
  GetAllTaskListStreamOfUserUC(this._repository);

  final TaskListRepository _repository;

  @override
  SQuerySnapshot call(UserEntity params) {
    return _repository.getAllTaskListStreamOfUser(params.uid!);
  }
}
