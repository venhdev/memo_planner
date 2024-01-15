import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Future<void> logInWithCredentials(String email, String password);
  // Future<void> logInWithGoogle();
  // Future<void> logOut();
  // Future<bool> isSignedIn();
  // Future<String> getUser();
  ResultEither<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  ResultEither<UserEntity> signInWithGoogle();
  ResultEither<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  });
  ResultVoid signOut();
  UserEntity? getCurrentUser();
  Future<GoogleSignInAccount?> signInSilentlyWithGoogle();
  Future<UserEntity?> getUserByEmail(String email);
  Future<UserEntity?> getUserByUID(String uid);

  // Update Profile
  Future<void> updateDisplayName(String name);
  ResultEither updateUserAvatar(XFile imageFile);
}
