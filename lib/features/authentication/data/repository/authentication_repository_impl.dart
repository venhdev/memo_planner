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

@Singleton(as: AuthRepository)
class AuthenticationRepositoryImpl implements AuthRepository {
  AuthenticationRepositoryImpl(this._firebaseAuthDataSource);
  final AuthenticationDataSource _firebaseAuthDataSource;

  @override
  ResultEither<UserEntity> signInWithGoogle() async {
    try {
      final UserCredential credential = await _firebaseAuthDataSource.signInWithGoogle();
      final user = UserModel.fromUserCredential(credential.user!);
      await _firebaseAuthDataSource.updateOrCreateUserInfo(user); // update or create user in 'users' collection
      // add current FCM token to user in 'users' collection
      await _firebaseAuthDataSource.addCurrentFCMTokenToUser(user.email!);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    } on AssertionError catch (e) {
      // login canceled
      log('AssertionError: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Left(ServerFailure(message: 'Login failed'));
    }
  }

  @override
  ResultEither<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuthDataSource.signInWithEmailAndPassword(email, password);
      // add current FCM token
      await _firebaseAuthDataSource.addCurrentFCMTokenToUser(credential.user!.email!);
      return Right(UserModel.fromUserCredential(credential.user!));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return Left(ServerFailure(code: e.code, message: kAuthInvalidEmail));
        case 'user-disabled':
          return Left(ServerFailure(code: e.code, message: kAuthUserDisabled));
        case 'user-not-found':
          return Left(ServerFailure(code: e.code, message: kAuthUserDisabled));
        case 'wrong-password':
          return Left(ServerFailure(code: e.code, message: kAuthUserDisabled));
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
      final user = UserModel.fromUserCredential(userCredential.user!);
      await _firebaseAuthDataSource.updateOrCreateUserInfo(user);
      // add current FCM token to user in 'users' collection
      await _firebaseAuthDataSource.addCurrentFCMTokenToUser(user.email!);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      // not yet handle: 'email-already-in-use'
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

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    try {
      return await _firebaseAuthDataSource.getUserByEmail(email);
    } on FirebaseAuthException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return null;
    }
  }

  @override
  Future<void> updateDisplayName(String name) {
    try {
      return _firebaseAuthDataSource.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      log('Specific Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Future.error(e);
    }
  }
}
