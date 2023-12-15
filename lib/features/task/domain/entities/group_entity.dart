import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  const GroupEntity({
    required this.gid,
    required this.groupName,
  });

  final String gid;
  final String groupName;

  @override
  List<Object?> get props => [gid, groupName];
}
