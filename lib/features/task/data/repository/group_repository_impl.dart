import 'package:injectable/injectable.dart';
import 'package:memo_planner/core/constants/typedef.dart';
import 'package:memo_planner/features/task/domain/entities/group_entity.dart';
import 'package:memo_planner/features/task/domain/repository/group_repository.dart';

import '../data_sources/firestore_task_data_source.dart';

@Singleton(as: GroupRepository)
class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._dataSource);

  FireStoreTaskDataSource _dataSource;
  @override
  ResultVoid addGroup(GroupEntity group) {
    // TODO: implement addGroup
    throw UnimplementedError();
  }

  @override
  ResultVoid deleteGroup(GroupEntity group) {
    // TODO: implement deleteGroup
    throw UnimplementedError();
  }

  @override
  ResultVoid updateGroup(GroupEntity group) {
    // TODO: implement updateGroup
    throw UnimplementedError();
  }

  @override
  ResultVoid addChildren(String gid, String lid) {
    // TODO: implement addChildren
    throw UnimplementedError();
  }

  @override
  ResultVoid removeChildren(String gid, String lid) {
    // TODO: implement removeChildren
    throw UnimplementedError();
  }
}
