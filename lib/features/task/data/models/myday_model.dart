import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/myday_entity.dart';

class MyDayModel extends MyDayEntity {
  const MyDayModel({
    required super.lid,
    required super.tid,
    required super.created,
    super.keep,
  });

  factory MyDayModel.fromEntity(MyDayEntity entity) {
    return MyDayModel(
      lid: entity.lid,
      tid: entity.tid,
      created: entity.created,
      keep: entity.keep,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lid': lid,
      'tid': tid,
      'created': created,
      'keep': keep,
    };
  }

  factory MyDayModel.fromMap(Map<String, dynamic> map) {
    return MyDayModel(
      lid: map['lid'] as String,
      tid: map['tid'] as String,
      created: (map['created'] as Timestamp).toDate(),
      keep: map['keep'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyDayModel.fromJson(String source) => MyDayModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
