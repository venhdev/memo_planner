import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/dependency_injection.dart';
import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/domain/repository/authentication_repository.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../features/task/domain/repository/task_list_repository.dart';
import '../entities/member.dart';
import 'common_screen.dart';

class MemberItem extends StatelessWidget {
  /// only pass hid or lid, not both
  const MemberItem({
    super.key,
    this.hid,
    this.lid,
    required this.renderMember,
    required this.ownerUID,
  }) : assert(hid == null || lid == null, 'Cannot pass both hid and lid'); // assert that cannot pass both hid and lid

  final String? hid; // Habit ID (for habit detail)
  final String? lid; // List Task ID (for list task detail)
  final Member renderMember;
  final String ownerUID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: di<AuthRepository>().getUserByUID(renderMember.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final renderUser = snapshot.data;
          final currentUser = context.read<AuthBloc>().state.user;
          return _build(renderUser!, currentUser!, context);
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  Widget _build(UserEntity renderUser, UserEntity currentUser, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar
          _buildAvatar(renderUser),
          // Name + Email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                renderUser.displayName ?? renderUser.email!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                renderUser.email!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          // Remove button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  renderMember.role == UserRole.admin ? 'Admin' : 'Member',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                renderMember.role == UserRole.admin
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: handleRemoveMember(
                          currentUser: currentUser,
                          renderUser: renderUser,
                          context: context,
                        ),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(UserEntity memberInfo) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Builder(
        builder: (context) {
          if (memberInfo.photoURL != null) {
            return CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.green.shade100,
              backgroundImage: NetworkImage(memberInfo.photoURL!),
            );
          } else {
            // use the first letter of email instead
            return CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.green.shade100,
              child: Text(
                memberInfo.email!.substring(0, 1),
                style: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  VoidCallback? handleRemoveMember({
    required UserEntity currentUser,
    required UserEntity renderUser,
    required BuildContext context,
  }) {
    return ownerUID == currentUser.uid //` current user is owner
        ? renderMember.uid == currentUser.uid //` current render member is owner & current user is owner
            ? null // cannot remove owner itself
            : () => di<TaskListRepository>().removeMember(lid!, renderUser.uid!) // remove other member
        : renderMember.uid == currentUser.uid //` current render member is member & current user isn't owner
            ? () {
                di<TaskListRepository>().removeMember(lid!, renderUser.uid!); // remove self
                // redirect to home
                // context.go('/task-list');
                context.go('/');
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
