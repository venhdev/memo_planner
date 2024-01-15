import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/entities/member.dart';
import '../../../authentication/domain/entities/user_entity.dart';

class TaskListEntity extends Equatable {
  final String? lid;
  final String? gid;
  final String? listName;
  final IconData? iconData;
  final UserEntity? creator;
  final List<Member>? members;

  const TaskListEntity({
    this.lid,
    this.gid,
    this.listName,
    this.iconData,
    this.creator,
    this.members,
  });

  @override
  List<Object?> get props => [
        lid,
        gid,
        listName,
        iconData,
        creator,
        members,
      ];

  TaskListEntity copyWith({
    String? lid,
    String? gid,
    String? listName,
    IconData? iconData,
    UserEntity? creator,
    List<Member>? members,
  }) {
    return TaskListEntity(
      lid: lid ?? this.lid,
      gid: gid ?? this.gid,
      listName: listName ?? this.listName,
      iconData: iconData ?? this.iconData,
      creator: creator ?? this.creator,
      members: members ?? this.members,
    );
  }
}
