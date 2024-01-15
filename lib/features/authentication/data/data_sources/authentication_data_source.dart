import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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
  Future<GoogleSignInAccount?> signInSilentlyWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();

  /// Returns the current user.
  User? get currentUser;

  /// Gets the user by the given [email].
  Future<UserEntity?> getUserByEmail(String email);
  Future<UserEntity?> getUserByUID(String uid);

  /// Update or Create one if the user doesn't exist in 'users' collection
  Future<void> updateOrCreateUserInfo(UserModel user);
  Future<void> addCurrentFCMTokenToUser(String uid);
  Future<void> removeCurrentFCMTokenFromUser(String email);

  // Update Profile
  Future<void> updateDisplayName(String name);
  Future<String> updateUserAvatar(XFile imageFile);
}

@Singleton(as: AuthenticationDataSource)
class AuthenticationDataSourceImpl implements AuthenticationDataSource {
  AuthenticationDataSourceImpl(
    this._auth,
    this._googleSignIn,
    this._firestore,
    this._messagingManager,
    this._storage,
  );

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseCloudMessagingManager _messagingManager;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  @override
  Future<void> signOut() async {
    // get the email of current user to remove FCM token
    await removeCurrentFCMTokenFromUser(_auth.currentUser!.uid);
    // remove current FCM token
    if (_googleSignIn.currentUser != null) {
      log('Signing out from Google');
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<GoogleSignInAccount?> signInSilentlyWithGoogle() async => await _googleSignIn.signInSilently();

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
      return _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log('rethrow --> Summary Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateOrCreateUserInfo(UserModel user) async {
    await _firestore.collection(pathToUsers).doc(user.uid).set(
          user.toDocument(),
          SetOptions(merge: true), // update or create
        );
  }

  @override
  Future<void> addCurrentFCMTokenToUser(String uid) {
    final token = _messagingManager.currentFCMToken;
    return _firestore.collection(pathToUsers).doc(uid).update({
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
    return _auth.currentUser!.updateDisplayName(name).then((_) {
      final user = _auth.currentUser!;
      _firestore.collection(pathToUsers).doc(user.uid).update({
        'displayName': user.displayName,
      });
    });
  }

  // NOTE: going to deprecated
  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    final result = await _firestore.collection(pathToUsers).where('email', isEqualTo: email).get();

    if (result.docs.isNotEmpty) {
      return UserModel.fromDocument(result.docs.first.data());
    } else {
      return null;
    }
    // final result = await _firestore.collection(pathToUsers).doc(email).get();
    // if (result.exists) {
    //   return UserModel.fromDocument(result.data()!);
    // } else {
    //   return null;
    // }
  }

  @override
  Future<UserEntity?> getUserByUID(String uid) async {
    final result = await _firestore.collection(pathToUsers).doc(uid).get();

    if (result.exists) {
      return UserModel.fromDocument(result.data()!);
    } else {
      return null;
    }
  }

  Future<String> uploadPhoto(XFile imageFile) async {
    // get the reference to the storage: /profile_images/{uid}
    final ref = _storage.ref().child(kStorageProfileImage).child(_auth.currentUser!.uid);
    // get type of the image
    final contentType = 'image/${imageFile.path.split('.').last}';
    // upload the file to the storage
    final uploadTask = ref.putFile(
      File(imageFile.path),
      SettableMetadata(
        contentType: contentType,
      ),
    );
    final downloadURL = await (await uploadTask).ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> updatePhotoURL(String url) async {
    return await _auth.currentUser!.updatePhotoURL(url).then((_) {
      final user = _auth.currentUser!;
      _firestore.collection(pathToUsers).doc(user.uid).update({
        'photoURL': user.photoURL,
      });
    });
  }

  @override
  Future<String> updateUserAvatar(XFile imageFile) async {
    return await uploadPhoto(imageFile).then((url) async {
      await updatePhotoURL(url);
      return url;
    });
  }
}
