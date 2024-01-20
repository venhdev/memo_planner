import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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
  AuthenticationRepositoryImpl(this._authDataSource);
  final AuthenticationDataSource _authDataSource;

  @override
  ResultEither<UserEntity> signInWithGoogle() async {
    try {
      final UserCredential credential = await _authDataSource.signInWithGoogle();
      final user = UserModel.fromUserCredential(credential.user!);
      await _authDataSource.updateOrCreateUserInfo(user); // update or create user in 'users' collection
      // add current FCM token to user in 'users' collection
      await _authDataSource.addCurrentFCMTokenToUser(user.uid!);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      log('signInWithGoogle FirebaseAuthException: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('signInWithGoogle Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    } on AssertionError catch (e) {
      // login canceled
      log('signInWithGoogle AssertionError: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return const Left(ServerFailure(message: 'Login failed'));
    }
  }

  @override
  ResultEither<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authDataSource.signInWithEmailAndPassword(email, password);
      // add current FCM token
      _authDataSource.addCurrentFCMTokenToUser(credential.user!.uid);
      final user = UserModel.fromUserCredential(credential.user!);
      _authDataSource.updateOrCreateUserInfo(user);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return Left(ServerFailure(code: e.code, message: kAuthInvalidCredential));
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
      log('signInWithEmailAndPassword FirebaseAuthException: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } on Exception catch (e) {
      log('signInWithEmailAndPassword Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await _authDataSource.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      log('signOut FirebaseAuthException: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(message: e.message!));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    try {
      final result = _authDataSource.currentUser;
      return result != null ? UserModel.fromUserCredential(result) : null;
    } on FirebaseAuthException catch (e) {
      log('getCurrentUser FirebaseAuthException: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return null;
    } catch (e) {
      log('getCurrentUser Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return null;
    }
  }

  @override
  ResultEither<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authDataSource.signUpWithEmail(email, password);
      final user = UserModel.fromUserCredential(userCredential.user!);
      await _authDataSource.updateOrCreateUserInfo(user);
      // add current FCM token to user in 'users' collection
      await _authDataSource.addCurrentFCMTokenToUser(user.uid!);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      // not yet handle: 'email-already-in-use'
      switch (e.code) {
        case 'invalid-email':
          return Left(ServerFailure(code: e.code, message: kAuthInvalidEmail));
        case 'network-request-failed':
          return Left(ServerFailure(code: e.code, message: kAuthNetworkRequestFailed));
      }

      log('signUpWithEmail FirebaseAuthException: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(ServerFailure(code: e.code, message: e.message!));
    } catch (e) {
      log('signUpWithEmail Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    try {
      return await _authDataSource.getUserByEmail(email);
    } on FirebaseAuthException catch (e) {
      log('getUserByEmail Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return null;
    }
  }

  @override
  Future<void> updateDisplayName(String name) {
    try {
      return _authDataSource.updateDisplayName(name).then((value) => null);
    } on FirebaseAuthException catch (e) {
      log('updateDisplayName Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Future.error(e);
    }
  }

  @override
  Future<UserEntity?> getUserByUID(String uid) async {
    try {
      return await _authDataSource.getUserByUID(uid);
    } on FirebaseAuthException catch (e) {
      log('getUserByUID Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Future.error(e);
    }
  }

  @override
  Future<GoogleSignInAccount?> signInSilentlyWithGoogle() async {
    try {
      return await _authDataSource.signInSilentlyWithGoogle();
    } on FirebaseAuthException catch (e) {
      log('signInSilentlyWithGoogle Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Future.error(e);
    }
  }

  @override
  ResultEither updateUserAvatar(XFile imageFile) async {
    try {
      return Right(await _authDataSource.updateUserAvatar(imageFile));
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException Exception: type: ${e.runtimeType} code: "${e.code}", message: ${e.message}');
      return Left(FirebaseFailure(message: e.toString()));
    } catch (e) {
      log('updateUserAvatar Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
