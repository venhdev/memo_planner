import '../entities/user_entity.dart';

import '../../../../core/constants/typedef.dart';

abstract class AuthenticationRepository {
  // Future<void> logInWithCredentials(String email, String password);
  // Future<void> logInWithGoogle();
  // Future<void> logOut();
  // Future<bool> isSignedIn();
  // Future<String> getUser();
  ResultFuture<UserEntity> signedInWithEmailAndPassword(
    String email,
    String password,
  );

  ResultVoid signOut();

  Future<UserEntity?> getCurrentUser();
}
