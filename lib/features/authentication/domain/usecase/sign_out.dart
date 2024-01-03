import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/notification/local_notification_manager.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/authentication_repository.dart';

@singleton
class SignOutUC extends UseCaseNoParam<void> {
  SignOutUC(this.authenticationRepository, this.localNotificationManager);
  final AuthenticationRepository authenticationRepository;
  final LocalNotificationManager localNotificationManager;

  @override
  ResultVoid call() async {
    final resultEither = await authenticationRepository.signOut();
    return resultEither.fold(
      (failure) => Left(failure),
      (_) => Right(localNotificationManager.I.cancelAll()),
    );
  }
}
