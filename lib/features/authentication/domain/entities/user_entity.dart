import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
  });

  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final String? phoneNumber;

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