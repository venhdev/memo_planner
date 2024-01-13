import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignInWithGoogleUC extends UseCaseNoParam<ResultEither<UserEntity>> {
  SignInWithGoogleUC(this._authRepo);
  final AuthRepository _authRepo;

  @override
  ResultEither<UserEntity> call() {
    return _authRepo.signInWithGoogle();
  }
}
