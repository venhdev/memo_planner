import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/dependency_injection.dart';
import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/domain/repository/authentication_repository.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../features/task/domain/repository/task_list_repository.dart';

class MemberItem extends StatelessWidget {
  /// only pass hid or lid, not both
  const MemberItem({
    this.hid,
    this.lid,
    required this.renderEmail,
    required this.ownerEmail,
    super.key,
  })
  // assert that cannot pass both hid and lid
  : assert(hid == null || lid == null, 'Cannot pass both hid and lid'); // nice

  final String? hid; // Habit ID (for habit detail)
  final String? lid; // List Task ID (for list task detail)
  final String renderEmail;
  final String ownerEmail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: di<AuthRepository>().getUserByEmail(renderEmail),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData) {
          final member = snapshot.data;
          final currentUser = context.read<AuthBloc>().state.user;
          return _build(member!, currentUser!, context);
        } else {
          return Text(renderEmail);
        }
        // } else if (snapshot.hasError) {
        //   return MessageScreen.error(snapshot.error.toString());
        // } else {
        //   return const LoadingScreen();
        // }
      },
    );
  }

  Widget _build(UserEntity member, UserEntity currentUser, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //* Avatar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) {
                if (member.photoURL != null) {
                  return CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage: NetworkImage(member.photoURL!),
                  );
                } else {
                  // random image <assets/images/avatars> in case of no image --> no use for now
                  // use the first letter of email instead
                  return CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      member.email!.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                  // return getRandomAvatar();
                }
              },
            ),
          ),
          //* Name + Email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.displayName ?? member.email!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                member.email!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          //* Remove button
          TextButton.icon(
            label: Text((renderEmail == ownerEmail) ? 'Owner' : 'Remove'),
            onPressed: handleRemoveMember(
              currentUser: currentUser,
              member: member,
              context: context,
            ),
            icon: const Icon(Icons.remove_circle),
          )
        ],
      ),
    );
  }

  VoidCallback? handleRemoveMember({
    required UserEntity currentUser,
    required UserEntity member,
    required BuildContext context,
  }) {
    return ownerEmail == currentUser.email // if owner
        ? renderEmail == currentUser.email //> current render member is owner
            ? null // cannot remove self
            : () {
                di<TaskListRepository>().removeMember(lid!, member.email!); // remove other member
              }
        : renderEmail == currentUser.email //> current render member is member
            ? () {
                di<TaskListRepository>().removeMember(lid!, member.email!); // remove self
                // redirect to home
                context.go('/task-list');
              }
            : null; // cannot remove other member
  }
}

/**if (hid != null) {
      return ownerEmail == currentUser.email // if owner
          ? renderEmail == currentUser.email //> current render member is owner
              ? null // cannot remove self
              : () {
                  di<HabitDataSource>().removeMember(hid!, member.email!); // remove other member
                }
          : renderEmail == currentUser.email //> current render member is member
              ? () {
                  di<HabitDataSource>().removeMember(hid!, member.email!); // remove self
                  // redirect to home
                  context.go('/habit');
                }
              : null; // cannot remove other member
    } else  */