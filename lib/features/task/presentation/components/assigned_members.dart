import 'package:flutter/material.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/avatar.dart';
import '../../../../core/components/common_screen.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../../data/models/task_list_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_list_repository.dart';

class AssignedMembersList extends StatelessWidget {
  const AssignedMembersList({
    super.key,
    this.height = 48.0,
    required this.assignedMembers,
  });

  final List<String> assignedMembers;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: assignedMembers.length,
        itemBuilder: (context, index) => FutureBuilder(
          future: di<AuthRepository>().getUserByUID(assignedMembers[index]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final member = snapshot.data!;
              return Builder(
                builder: (context) {
                  if (member.photoURL != null) {
                    return CircleAvatar(
                      maxRadius: height / 2,
                      backgroundColor: Colors.green.shade100,
                      backgroundImage: NetworkImage(member.photoURL!),
                    );
                  } else {
                    return CircleAvatar(
                      maxRadius: height / 2,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.person),
                    );
                  }
                },
              );
            } else {
              return CircleAvatar(
                maxRadius: height / 2,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.person),
              );
            }
          },
        ),
      ),
    );
  }
}

class AssignMemberDialog extends StatelessWidget {
  const AssignMemberDialog({
    super.key,
    required this.task,
    required this.valueChanged,
    // required this.onUnassign,
    // required this.assignedMembers,
  });

  final TaskEntity task;
  final ValueChanged<List<String>> valueChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: di<TaskListRepository>().getOneTaskListStream(task.lid!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final map = snapshot.data?.data()!;
          if (map == null) return const MessageScreen(message: 'Task List has been deleted!');
          final members = TaskListModel.fromMap(map).members!;
          return SimpleDialog(
            children: [
              // NOTE: for testing
              const Text(
                'Select Member',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              for (final member in members)
                MemberItem(
                  memberUID: member.uid,
                  avatar: Avatar(userUID: member.uid),
                  assignedMembers: task.assignedMembers!, // when add/remove member, this will be updated
                  valueChanged: valueChanged,
                ),
            ],
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}

class MemberItem extends StatefulWidget {
  const MemberItem({
    super.key,
    required this.memberUID,
    required this.avatar,
    required this.assignedMembers,
    required this.valueChanged,
  });

  final String memberUID;
  final Avatar avatar;
  final List<String> assignedMembers;
  final ValueChanged<List<String>> valueChanged;

  @override
  State<MemberItem> createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> {
  late List<String> _assignedMembers;
  String? _memberInfo;

  @override
  void initState() {
    super.initState();
    _assignedMembers = widget.assignedMembers;
    di<AuthRepository>().getUserByUID(widget.memberUID).then((value) {
      if (value == null) {
        _memberInfo = 'not found...';
      } else {
        _memberInfo = value.email;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Builder(builder: (context) {
        return Text(_memberInfo ?? 'loading...', maxLines: 1, overflow: TextOverflow.ellipsis);
      }),
      leading: CircleAvatar(
        backgroundColor: Colors.green.shade100,
        child: widget.avatar,
      ),
      trailing: Checkbox(
        value: _assignedMembers.contains(widget.memberUID),
        onChanged: (value) {
          setState(() {
            if (value!) {
              // will update assignedMembers in AssignMemberDialog because in dart object is passed by reference
              _assignedMembers.add(widget.memberUID);
            } else {
              _assignedMembers.remove(widget.memberUID);
            }
          });
          widget.valueChanged(List.from(_assignedMembers));
        },
      ),
    );
  }
}
