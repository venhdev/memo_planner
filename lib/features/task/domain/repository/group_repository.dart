import '../../../../core/constants/typedef.dart';
import '../entities/group_entity.dart';

abstract class GroupRepository {
  ResultVoid addGroup(GroupEntity group);
  ResultVoid updateGroup(GroupEntity group);
  ResultVoid deleteGroup(GroupEntity group);

  ResultVoid addChildren(String gid, String lid);
  ResultVoid removeChildren(String gid, String lid);
}
