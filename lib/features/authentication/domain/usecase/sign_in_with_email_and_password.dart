import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignInWithEmailAndPasswordUC
    implements BaseUseCase<UserCredential, SignInParams> {
  final AuthenticationRepository authenticationRepository;

  SignInWithEmailAndPasswordUC(this.authenticationRepository);

  @override
  ResultFuture<UserCredential> call(SignInParams params) async {
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
