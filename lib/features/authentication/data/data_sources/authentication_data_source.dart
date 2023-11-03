import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class AuthenticationDataSource {
  /// Tries to sign in a user with the given [email] and [password]
  /// and returns a [UserCredential] if successful.
  ///
  /// Throws a [FirebaseAuthException] if the sign in fails.
  Future<UserCredential> signedInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<UserCredential> signInWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();

  /// Returns the current user.
  User? get currentUser;
}

@Singleton(as: AuthenticationDataSource)
class AuthenticationDataSourceImpl implements AuthenticationDataSource {
  AuthenticationDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserCredential> signedInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw FirebaseAuthException(
          code: 'ERROR_USER_NOT_FOUND',
          message: 'No user found for that email.',
        );
      } else {
        return result;
      }
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message!,
      );
    }
  }

  @override
  Future<void> signOut() {
    try {
      return _firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message!,
      );
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
