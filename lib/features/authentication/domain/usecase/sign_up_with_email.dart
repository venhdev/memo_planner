import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignUpWithEmailUC
    extends UseCaseWithParams<ResultEither<UserEntity>, SignUpParams> {
  SignUpWithEmailUC(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;
  @override
  ResultEither<UserEntity> call(SignUpParams params) async {
    return await _authenticationRepository.signUpWithEmail(
      params.email,
      params.password,
    );
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
