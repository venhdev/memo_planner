import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/user_entity.dart';
import '../repository/authentication_repository.dart';

@singleton
class GetCurrentUserUC extends UseCaseNoParam<UserEntity?> {
  GetCurrentUserUC(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;

  @override
  UserEntity? call() {
    return _authenticationRepository.getCurrentUser();
  }
}
