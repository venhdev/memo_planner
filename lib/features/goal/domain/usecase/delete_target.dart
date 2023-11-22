import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/target_entity.dart';
import '../repository/target_repository.dart';

@singleton
class DeleteTargetUC extends UseCaseWithParams<ResultVoid, TargetEntity> {
  DeleteTargetUC(this._targetRepository);

  final TargetRepository _targetRepository;
  @override
  ResultVoid call(TargetEntity params) async {
    return await _targetRepository.deleteTarget(params);
  }
}
