// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../authentication/domain/entities/user_entity.dart';

class TaskListEntity extends Equatable {
  final String? lid;
  final String? gid;
  final String? listName;
  final IconData? iconData;
  final UserEntity? creator;
  final List<String>? members;

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
    List<String>? members,
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

// ------------------ IconDataModel ------------------

class IconDataModel extends IconData {
  const IconDataModel(
    super.codePoint, {
    super.fontFamily,
    super.fontPackage,
    super.matchTextDirection,
    super.fontFamilyFallback,
  });

  factory IconDataModel.fromIconData(IconData iconData) {
    return IconDataModel(
      iconData.codePoint,
      fontFamily: iconData.fontFamily,
      fontPackage: iconData.fontPackage,
      matchTextDirection: iconData.matchTextDirection,
      fontFamilyFallback: iconData.fontFamilyFallback,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codePoint': codePoint,
      'fontFamily': fontFamily,
      'fontPackage': fontPackage,
      'matchTextDirection': matchTextDirection,
      'fontFamilyFallback': fontFamilyFallback,
    };
  }

  factory IconDataModel.fromMap(Map<String, dynamic> map) {
    return IconDataModel(
      map['codePoint'] as int,
      fontFamily: map['fontFamily'] != null ? map['fontFamily'] as String : null,
      fontPackage: map['fontPackage'] != null ? map['fontPackage'] as String : null,
      matchTextDirection: map['matchTextDirection'] as bool,
      fontFamilyFallback: map['fontFamilyFallback'] != null
          ? (map['fontFamilyFallback'] as List<dynamic>).map((e) => e as String).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IconDataModel.fromJson(String source) =>
      IconDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
