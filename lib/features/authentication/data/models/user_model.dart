import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String? uid,
    String? displayName,
    String? email,
    String? photoURL,
    String? phoneNumber,
  }) : super(
          uid: uid,
          displayName: displayName,
          email: email,
          photoURL: photoURL,
          phoneNumber: phoneNumber,
        );

  factory UserModel.fromDocument(Map<String, dynamic> data) {
    return UserModel.fromMap(data);
  }

  factory UserModel.fromSnapShot(DocumentSnapshot snapshot) {
    var snapshotMap = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(snapshotMap);
  }

  factory UserModel.fromUserCredential(User user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  // fromMap
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      displayName: data['displayName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      photoURL: data['photoURL'],
    );
  }

  Map<String, dynamic> toDocument() {
    return toMap();
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
    };
  }
}
