import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignOutUC implements BaseUseCase<void, NoParams> {
  final AuthenticationRepository authenticationRepository;

  SignOutUC(this.authenticationRepository);

  @override
  ResultVoid call(NoParams params) async {
    return await authenticationRepository.signOut();
  }
}
