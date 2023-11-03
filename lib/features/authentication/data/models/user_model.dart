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

  // UserEntity toEntity() {
  //   return UserEntity(
  //     uid: uid,
  //     displayName: displayName,
  //     email: email,
  //     photoURL: photoURL,
  //     phoneNumber: phoneNumber,
  //   );
  // }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  factory UserModel.fromUser(User user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  factory UserModel.fromSnapShot(DocumentSnapshot snapshot) {
    var snapshotMap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshotMap['uid'],
      displayName: snapshotMap['displayName'],
      email: snapshotMap['email'],
      photoURL: snapshotMap['photoURL'],
      phoneNumber: snapshotMap['phoneNumber'],
    );
  }

  factory UserModel.fromDocument(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      displayName: data['displayName'],
      email: data['email'],
      photoURL: data['photoURL'],
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      if (uid!= null) 'uid': uid,
      if (displayName!= null) 'displayName': displayName,
      if (email!= null) 'email': email,
      if (photoURL!= null) 'photoURL': photoURL,
      if (phoneNumber!= null) 'phoneNumber': phoneNumber,
    };
  }
}
