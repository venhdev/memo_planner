import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
  });

  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  UserEntity copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        photoURL,
      ];
}

//https://firebase.google.com/docs/reference/js/auth.userinfo.md#userinfo_interface