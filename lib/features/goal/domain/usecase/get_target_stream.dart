import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/target_repository.dart';

@singleton
class GetTargetStreamUC extends UseCaseWithParams<ResultEither<SQuerySnapshot>, String> {
  GetTargetStreamUC(this._targetRepository);

  final TargetRepository _targetRepository;
  @override
  ResultEither<SQuerySnapshot> call(String params) async {
    return await _targetRepository.getTargetStream(params);
  }
}
