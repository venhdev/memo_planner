import 'dart:convert';

import 'package:equatable/equatable.dart';

enum UserRole { admin, member }

class Member extends Equatable {
  factory Member.member(String uid) => Member(uid: uid, role: UserRole.member);
  factory Member.admin(String uid) => Member(uid: uid, role: UserRole.admin);

  const Member({
    required this.uid,
    required this.role,
  });

  final String uid;
  final UserRole role;

  Member copyWith({
    String? uid,
    UserRole? role,
  }) {
    return Member(
      uid: uid ?? this.uid,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'role': role.name,
    };
  }

  // {
  //   "uid": "uid",
  //   "role": "admin"
  // }
  static List<Map<String, dynamic>> toMapList(List<Member> members) {
    return members.map((e) => e.toMap()).toList();
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      uid: map['uid'] as String,
      role: UserRole.values.firstWhere((e) => e.name == map['role'] as String),
    );
  }

  static List<Member> fromMapList(List<dynamic> members) {
    return members.map((e) => Member.fromMap(e as Map<String, dynamic>)).toList();
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Member(uid: $uid, role: $role)';

  @override
  List<Object> get props => [uid, role];
}
