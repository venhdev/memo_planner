import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/notification/firebase_cloud_messaging_manager.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthenticationDataSource {
  /// Tries to sign in a user with the given [email] and [password]
  /// and returns a [UserCredential] if successful.
  ///
  /// Throws a [FirebaseAuthException] if the sign in fails.
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
  );

  Future<UserCredential> signInWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();

  /// Returns the current user.
  User? get currentUser;

  /// Gets the user by the given [email].
  Future<UserEntity?> getUserByEmail(String email);

  /// Update or Create one if the user doesn't exist in 'users' collection
  Future<void> updateOrCreateUserInfo(UserModel user);
  Future<void> addCurrentFCMTokenToUser(String email);
  Future<void> removeCurrentFCMTokenFromUser(String email);

  // Update Profile
  Future<void> updateDisplayName(String name);
}

@Singleton(as: AuthenticationDataSource)
class AuthenticationDataSourceImpl implements AuthenticationDataSource {
  AuthenticationDataSourceImpl(this._firebaseAuth, this._googleSignIn, this._firestore, this._messagingManager);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final FirebaseCloudMessagingManager _messagingManager;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  @override
  Future<void> signOut() async {
    // get the email of current user to remove FCM token
    await removeCurrentFCMTokenFromUser(_firebaseAuth.currentUser!.email!);
    // remove current FCM token
    if (_googleSignIn.currentUser != null) {
      log('Signing out from Google');
      await _googleSignIn.signOut();
    }
    await _firebaseAuth.signOut();
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    log('signInWithGoogle accessToken: ${userCredential.credential?.accessToken}');

    // Once signed in, return the UserCredential
    return userCredential;
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) {
    try {
      return _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log('rethrow --> Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    final result = await _firestore.collection(pathToUsers).doc(email).get();
    if (result.exists) {
      return UserModel.fromDocument(result.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateOrCreateUserInfo(UserModel user) async {
    await _firestore.collection(pathToUsers).doc(user.email).set(
          user.toDocument(),
          SetOptions(merge: true), // update or create
        );
  }

  @override
  Future<void> addCurrentFCMTokenToUser(String email) {
    final token = _messagingManager.currentFCMToken;
    return _firestore.collection(pathToUsers).doc(email).update({
      'tokens': FieldValue.arrayUnion([token])
    }).then((value) => log('Add FCM Token Success'));
  }

  @override
  Future<void> removeCurrentFCMTokenFromUser(String email) {
    final token = _messagingManager.currentFCMToken;
    return _firestore.collection(pathToUsers).doc(email).update({
      'tokens': FieldValue.arrayRemove([token])
    }).then((value) => log('Remove FCM Token Success'));
  }

  @override
  Future<void> updateDisplayName(String name) {
    return _firebaseAuth.currentUser!.updateDisplayName(name);
  }
}
