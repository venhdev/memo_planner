import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignOutUC implements UseCaseNoParams<void> {
  final AuthenticationRepository authenticationRepository;

  SignOutUC(this.authenticationRepository);

  @override
  ResultVoid call() async {
    return await authenticationRepository.signOut();
  }
}
