import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/typedef.dart';

abstract class AuthenticationRepository {
  // Future<void> logInWithCredentials(String email, String password);
  // Future<void> logInWithGoogle();
  // Future<void> logOut();
  // Future<bool> isSignedIn();
  // Future<String> getUser();
  ResultFuture<UserCredential> signedInWithEmailAndPassword(
    String email,
    String password,
  );

  ResultVoid signOut();
}
