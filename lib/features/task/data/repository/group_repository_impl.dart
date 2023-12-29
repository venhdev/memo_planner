import 'package:injectable/injectable.dart';
import '../../../../core/constants/typedef.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repository/group_repository.dart';

import '../data_sources/firestore_task_data_source.dart';

@Singleton(as: GroupRepository)
class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._dataSource);

  // ignore: unused_field, prefer_final_fields
  FireStoreTaskDataSource _dataSource;
  @override
  ResultVoid addGroup(GroupEntity group) {
    throw UnimplementedError();
  }

  @override
  ResultVoid deleteGroup(GroupEntity group) {
    throw UnimplementedError();
  }

  @override
  ResultVoid updateGroup(GroupEntity group) {
    throw UnimplementedError();
  }

  @override
  ResultVoid addChildren(String gid, String lid) {
    throw UnimplementedError();
  }

  @override
  ResultVoid removeChildren(String gid, String lid) {
    throw UnimplementedError();
  }
}
