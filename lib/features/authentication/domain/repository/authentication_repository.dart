import '../../../../core/constants/typedef.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Future<void> logInWithCredentials(String email, String password);
  // Future<void> logInWithGoogle();
  // Future<void> logOut();
  // Future<bool> isSignedIn();
  // Future<String> getUser();
  ResultEither<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  );
  ResultEither<UserEntity> signInWithGoogle();
  ResultEither<UserEntity> signUpWithEmail(
    String email,
    String password,
  );
  ResultVoid signOut();
  UserEntity? getCurrentUser();
  Future<UserEntity?> getUserByEmail(String email);

  // Update Profile
  Future<void> updateDisplayName(String name);
}
