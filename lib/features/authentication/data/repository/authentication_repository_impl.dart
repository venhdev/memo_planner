import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/authentication_repository.dart';
import '../data_sources/authentication_data_source.dart';
import '../models/user_model.dart';

// https://firebase.google.com/docs/auth/admin/errors

@Singleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(this._firebaseAuthDataSource);
  final AuthenticationDataSource _firebaseAuthDataSource;

  @override
  ResultEither<UserEntity> signInWithGoogle() async {
    try {
      final result = await _firebaseAuthDataSource.signInWithGoogle();
      return Right(UserModel.fromUserCredential(result.user!));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultEither<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuthDataSource.signInWithEmailAndPassword(email, password);
      return Right(UserModel.fromUserCredential(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return Left(ServerFailure(code: e.code, message: kAuthInvalidEmail));
        case 'INVALID_LOGIN_CREDENTIALS':
          return Left(ServerFailure(code: e.code, message: kAuthInvalidLoginCredentials));
        case 'too-many-requests':
          return Left(ServerFailure(code: e.code, message: kAuthTooManyRequests));
        case 'network-request-failed':
          return Left(ServerFailure(code: e.code, message: kAuthNetworkRequestFailed));
      }
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await _firebaseAuthDataSource.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message!));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    try {
      final result = _firebaseAuthDataSource.currentUser;

      if (result != null) {
        return UserModel.fromUserCredential(result);
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return null;
    }
  }

  @override
  ResultEither<UserEntity> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuthDataSource.signUpWithEmail(email, password);
      return Right(UserModel.fromUserCredential(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      // not handle: 'email-already-in-use'
      switch (e.code) {
        case 'invalid-email':
          return Left(ServerFailure(code: e.code, message: kAuthInvalidEmail));
        case 'network-request-failed':
          return Left(ServerFailure(code: e.code, message: kAuthNetworkRequestFailed));
      }

      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } catch (e) {
      log('Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
