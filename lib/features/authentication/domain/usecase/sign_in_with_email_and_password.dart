import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignInWithEmailAndPasswordUC
    implements UseCaseWithParams<UserEntity, SignInParams> {
  final AuthenticationRepository authenticationRepository;

  SignInWithEmailAndPasswordUC(this.authenticationRepository);

  @override
  ResultFuture<UserEntity> call(SignInParams params) async {
    return await authenticationRepository.signedInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

/// [SignInParams] hold 2 parameters: String[email] and String[password].
class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
