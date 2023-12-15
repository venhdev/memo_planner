import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

import '../../../../../config/dependency_injection.dart';
import '../../../../../core/components/widgets.dart';
import '../../../../authentication/domain/repository/authentication_repository.dart';
import '../../../data/data_sources/habit_data_source.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({
    required this.hid,
    required this.memberEmail,
    required this.ownerEmail,
    super.key,
  });
  final String hid;
  final String memberEmail;
  final String ownerEmail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: di<AuthenticationRepository>().getUserByEmail(memberEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final member = snapshot.data;
              final currentUser = context.read<AuthenticationBloc>().state.user;
              return _build(member!, currentUser!, context);
            } else {
              return Text(memberEmail);
            }
          } else if (snapshot.hasError) {
            return MessageScreen.error(snapshot.error.toString());
          } else {
            return const LoadingScreen();
          }
        });
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(builder: (context) {
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
            }),
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.displayName!,
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
          const SizedBox(width: 8.0),
          IconButton(
            // ? cannot remove owner member
            // onPressed: member.uid == currentUser.uid
            //     ? null
            //     : () {
            //         log('test');
            //         log('object: ${member.email!}');
            //         log('object: ${hid}');

            //         di<HabitDataSource>().removeMember(hid, member.email!);
            //       },
            onPressed: ownerEmail == currentUser.email // if owner
                ? memberEmail == currentUser.email //> current render member is owner
                    ? null // cannot remove self
                    : () {
                        di<HabitDataSource>().removeMember(hid, member.email!); // remove other member
                      }
                : memberEmail == currentUser.email //> current render member is member
                    ? () {
                        di<HabitDataSource>().removeMember(hid, member.email!); // remove self
                        // redirect to home
                        context.go('/habit');
                      }
                    : null, // cannot remove other member
            icon: const Icon(Icons.remove_circle),
          )
        ],
      ),
    );
  }
}
