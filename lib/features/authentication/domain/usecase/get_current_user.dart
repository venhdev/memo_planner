import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';

import '../entities/user_entity.dart';
import '../repository/authentication_repository.dart';

@singleton
class GetCurrentUserUC extends UseCaseNoParamNull<UserEntity> {
  final AuthenticationRepository _authenticationRepository;

  GetCurrentUserUC(this._authenticationRepository);

  @override
  Future<UserEntity?> call() async {
    return await _authenticationRepository.getCurrentUser();
  }
}
