import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/typedef.dart';

import '../../domain/repository/authentication_repository.dart';
import '../data_sources/firebase_authentication_service.dart';

@Singleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FireBaseAuthenticationService _fireBaseAuthenticationService;

  AuthenticationRepositoryImpl(this._fireBaseAuthenticationService);

  @override
  ResultFuture<UserCredential> signedInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result =
          await _fireBaseAuthenticationService.signedInWithEmailAndPassword(
        email,
        password,
      );
      return Right(result);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message!,
      );
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await _fireBaseAuthenticationService.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message!,
      );
    }
  }
}
