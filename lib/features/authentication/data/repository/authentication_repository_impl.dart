import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/constants/typedef.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/authentication_repository.dart';
import '../data_sources/authentication_data_source.dart';
import '../models/user_model.dart';

@Singleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(this._fireBaseAuthenticationService);
  final AuthenticationDataSource _fireBaseAuthenticationService;

  @override
  ResultEither<UserEntity> signInWithGoogle() async {
    try {
      final result = await _fireBaseAuthenticationService.signInWithGoogle();
      return Right(UserModel.fromUser(result.user!));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message!));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultEither<UserEntity> signedInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result =
          await _fireBaseAuthenticationService.signedInWithEmailAndPassword(
        email,
        password,
      );
      return Right(UserModel.fromUser(result.user!));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message!));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await _fireBaseAuthenticationService.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message!));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    try {
      final result = _fireBaseAuthenticationService.currentUser;

      if (result != null) {
        return UserModel.fromUser(result);
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthenticationRepositoryImpl: getCurrentUser: ${e.message}');
      return null;
    }
  }
}
