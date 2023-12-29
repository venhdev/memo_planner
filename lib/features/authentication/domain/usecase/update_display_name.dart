import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/usecase/usecase.dart';

import '../repository/authentication_repository.dart';

@singleton
class UpdateDisplayNameUC extends UseCaseWithParams<void, String> {
  UpdateDisplayNameUC(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  @override
  Future<void> call(String params) async {
    return await _authenticationRepository.updateDisplayName(params);
  }
}
