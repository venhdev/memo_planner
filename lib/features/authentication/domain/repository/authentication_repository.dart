import '../../../../core/constants/typedef.dart';
import '../entities/user_entity.dart';

abstract class AuthenticationRepository {
  // Future<void> logInWithCredentials(String email, String password);
  // Future<void> logInWithGoogle();
  // Future<void> logOut();
  // Future<bool> isSignedIn();
  // Future<String> getUser();
  ResultEither<UserEntity> signedInWithEmailAndPassword(
    String email,
    String password,
  );

  ResultEither<UserEntity> signInWithGoogle();

  ResultVoid signOut();

  UserEntity? getCurrentUser();
}
