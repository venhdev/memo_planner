// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/components/avatar.dart';
import '../../../../core/components/common_screen.dart';
import '../../../../core/entities/member.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../data/models/task_list_model.dart';
import '../../domain/repository/task_list_repository.dart';

class AssignMemberDialog extends StatelessWidget {
  const AssignMemberDialog({
    super.key,
    required this.lid,
    required this.assignedMembers,
    required this.valueChanged,
  });

  final String lid;
  final List<String> assignedMembers;
  final ValueChanged<List<String>> valueChanged;

  @override
  Widget build(BuildContext context) {
    // this StreamBuilder to get the members of the task list automatically
    return StreamBuilder(
      stream: di<TaskListRepository>().getOneTaskListStream(lid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final map = snapshot.data?.data()!;
          if (map == null) {
            Navigator.pop(context); // REVIEW: should we pop here?
            return const MessageScreen(message: 'Task List has been deleted!');
          }
          final members = TaskListModel.fromMap(map).members!;
          final List<Avatar> memberAvatars = members.map((member) => Avatar(userUID: member.uid)).toList();
          return SimpleDialog(
            title: const Text('Assign to'),
            children: [
              const SizedBox(height: 8.0),
              ListMemberToAssign(
                members: members,
                memberAvatars: memberAvatars,
                assignedMembers: assignedMembers,
                onConfirm: (assignedMembers) {
                  valueChanged(assignedMembers);
                },
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

class ListMemberToAssign extends StatefulWidget {
  const ListMemberToAssign({
    super.key,
    required this.members,
    required this.assignedMembers,
    required this.memberAvatars,
    required this.onConfirm,
  });

  final List<Member> members;
  final List<String> assignedMembers;
  final List<Avatar> memberAvatars;
  final ValueChanged<List<String>> onConfirm;

  @override
  State<ListMemberToAssign> createState() => _ListMemberToAssignState();
}

class _ListMemberToAssignState extends State<ListMemberToAssign> {
  late List<String> _assignedMembers;

  @override
  void initState() {
    super.initState();
    _assignedMembers = widget.assignedMembers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: ListView.builder(
            itemCount: widget.members.length,
            itemBuilder: (context, index) {
              return AssignMemberItem(
                memberUID: widget.members[index].uid,
                avatar: widget.memberAvatars[index],
                isAssigned: _assignedMembers.contains(widget.members[index].uid),
                onChanged: (value) {
                  if (value == true) {
                    _assignedMembers.add(widget.members[index].uid);
                  } else {
                    _assignedMembers.remove(widget.members[index].uid);
                  }
                  setState(() {});
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12.0),
            ElevatedButton(
              onPressed: () {
                widget.onConfirm(_assignedMembers);
                Navigator.pop(context);
              },
              child: const Text('Assign'),
            ),
            SizedBox(width: 12.0),
          ],
        ),
      ],
    );
  }
}

class AssignMemberItem extends StatelessWidget {
  const AssignMemberItem({
    super.key,
    required this.memberUID,
    required this.avatar,
    required this.isAssigned,
    required this.onChanged,
  });

  final String memberUID;
  final Avatar avatar;
  final bool isAssigned; // true if the memberUID is in assignedMembers
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FutureBuilder(
        future: di<AuthRepository>().getUserByUID(memberUID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final member = snapshot.data!;
            final currentUserUID = context.read<AuthBloc>().state.user!.uid!;
            return Text('${member.displayName ?? member.email!} ${member.uid == currentUserUID ? '(You)' : ''}',
                maxLines: 1, overflow: TextOverflow.ellipsis);
          } else {
            return const Text('loading...');
          }
        },
      ),
      leading: CircleAvatar(
        child: avatar,
      ),
      trailing: Checkbox(
        value: isAssigned,
        onChanged: onChanged,
      ),
    );
  }
}

class AssignedMemberIconsList extends StatelessWidget {
  const AssignedMemberIconsList({
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
              return Avatar(
                photoURL: member.photoURL,
                placeHolder: member.displayName ?? member.email!,
                maxRadius: height / 2,
              );
            } else {
              return CircleAvatar(
                maxRadius: height / 2,
                child: const Icon(Icons.person),
              );
            }
          },
        ),
      ),
    );
  }
}
