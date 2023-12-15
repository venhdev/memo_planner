import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignOutUC extends UseCaseNoParam<void> {
  SignOutUC(this.authenticationRepository);
  final AuthenticationRepository authenticationRepository;

  @override
  ResultVoid call() async {
    return await authenticationRepository.signOut();
  }
}
