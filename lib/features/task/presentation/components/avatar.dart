import 'package:flutter/material.dart';

import '../../../../config/dependency_injection.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.memberEmail,
  });

  final String memberEmail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: di<AuthenticationRepository>().getUserByEmail(memberEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          final member = snapshot.data!;
          return Builder(
            builder: (context) {
              if (member.photoURL != null) {
                return CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  backgroundImage: NetworkImage(member.photoURL!),
                );
              } else {
                return CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.person),
                );
              }
            },
          );
        } else {
          return const Icon(Icons.person);
        }
      },
    );
  }
}
