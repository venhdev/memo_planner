import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final String? phoneNumber;

  const UserEntity({
    required this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
  });

  factory UserEntity.empty() {
    return const UserEntity(
      uid: '',
      displayName: '',
      email: '',
      phoneNumber: '',
      photoURL: '',
    );
  }

  @override
  String toString() {
    return 'UserEntity(uid: $uid, displayName: $displayName, email: $email, photoURL: $photoURL, phoneNumber: $phoneNumber)';
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        photoURL,
        phoneNumber,
      ];
}

//https://firebase.google.com/docs/reference/js/auth.userinfo.md#userinfo_interface