// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/task_list_entity.dart';

class TaskListModel extends TaskListEntity {
  const TaskListModel({
    super.lid,
    super.gid,
    super.listName,
    super.iconData,
    super.creator,
    super.members,
  });

  factory TaskListModel.fromEntity(TaskListEntity entity) {
    return TaskListModel(
      lid: entity.lid,
      gid: entity.gid,
      listName: entity.listName,
      iconData: entity.iconData,
      creator: entity.creator,
      members: entity.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (lid != null) 'lid': lid,
      if (gid != null) 'gid': gid,
      if (listName != null) 'listName': listName,
      if (iconData != null) 'iconData': IconDataModel.fromIconData(iconData!).toMap(),
      if (creator != null) 'creator': UserModel.fromEntity(creator!).toDocument(),
      if (members != null) 'members': members,
    };
  }

  factory TaskListModel.fromMap(Map<String, dynamic> map) {
    return TaskListModel(
      lid: map['lid'] != null ? map['lid'] as String : null,
      gid: map['gid'] != null ? map['gid'] as String : null,
      listName: map['listName'] != null ? map['listName'] as String : null,
      iconData: map['iconData'] != null ? IconDataModel.fromMap(map['iconData']) : null,
      creator: UserModel.fromDocument(map['creator']),
      members: map['members'] != null
          ? (map['members'] as List<dynamic>).map((member) => member.toString()).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskListModel.fromJson(String source) =>
      TaskListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskListModel(lid: $lid, gid: $gid, listName: $listName, iconData: $iconData, creator $creator, members: $members)';
  }
}
