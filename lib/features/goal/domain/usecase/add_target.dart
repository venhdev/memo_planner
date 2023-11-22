import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../entities/target_entity.dart';
import '../repository/target_repository.dart';

@singleton
class AddTargetUC extends UseCaseWithParams<ResultVoid, TargetEntity> {
  AddTargetUC(this._targetRepository, this._authenticationRepository);

  final TargetRepository _targetRepository;
  final AuthenticationRepository _authenticationRepository;
  @override
  ResultVoid call(TargetEntity params) async {
    final user = _authenticationRepository.getCurrentUser();
    params.copyWith(creator: user);
    return await _targetRepository.addTarget(params);
  }
}
