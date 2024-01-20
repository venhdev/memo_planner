import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/dependency_injection.dart';
import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/domain/repository/authentication_repository.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../features/task/domain/repository/task_list_repository.dart';
import '../entities/member.dart';
import 'avatar.dart';
import 'common_screen.dart';
import 'dialog.dart';

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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar
          _buildAvatar(renderUser.photoURL, renderUser.email!),
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
                style: const TextStyle(fontSize: 12),
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

  Widget _buildAvatar(String? photoURL, String placeholder) {
    return Avatar.photoURL(
      photoURL: photoURL,
      placeHolder: placeholder,
    );
  }

  VoidCallback? handleRemoveMember({
    required UserEntity currentUser,
    required UserEntity renderUser,
    required BuildContext context,
  }) {
    return ownerUID == currentUser.uid //> current user is owner
        ? renderMember.uid == currentUser.uid //> current render member is owner
            ? null // cannot remove owner itself
            : () => showMyDialogToConfirm(
                  context: context,
                  title: 'Remove member',
                  content: 'Are you sure to remove this member? This action will remove unassign the member from all task.',
                  onConfirm: () => di<TaskListRepository>().removeMember(lid!, renderUser.uid!),
                ) // remove other member
        : renderMember.uid == currentUser.uid //> current render member is member
            ? () {
                showMyDialogToConfirm(
                    context: context,
                    title: 'Leave List',
                    content: 'Are you sure to leave this list? This action will remove unassign you from all task.',
                    onConfirm: () {
                      di<TaskListRepository>().removeMember(lid!, renderUser.uid!); // remove self
                      // redirect to home
                      context.go('/');
                    });
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
