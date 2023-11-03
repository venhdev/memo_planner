import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignInWithEmailAndPasswordUC
    extends UseCaseWithParams<ResultEither<UserEntity>, SignInParams> {
  SignInWithEmailAndPasswordUC(this._authRepo);
  final AuthenticationRepository _authRepo;

  @override
  ResultEither<UserEntity> call(SignInParams params) async {
    return await _authRepo.signedInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

/// [SignInParams] hold 2 parameters: String[email] and String[password].
class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
