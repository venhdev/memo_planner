// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.gid,
    required super.groupName,
  });

  GroupModel copyWith({
    String? gid,
    String? groupName,
  }) {
    return GroupModel(
      gid: gid ?? this.gid,
      groupName: groupName ?? this.groupName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gid': gid,
      'groupName': groupName,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      gid: map['gid'] as String,
      groupName: map['groupName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) => GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupModel(gid: $gid, groupName: $groupName)';

  @override
  List<Object?> get props => [gid, groupName];
}
