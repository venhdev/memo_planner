import 'package:flutter/material.dart';

import '../../config/dependency_injection.dart';
import '../../features/authentication/domain/repository/authentication_repository.dart';
import 'common_screen.dart';

/// if both memberUID and photoURL are provided, photoURL will be used
class Avatar extends StatelessWidget {
  factory Avatar.photoURL({
    required String? photoURL,
    required String placeholder,
    double? radius,
  }) =>
      Avatar(
        photoURL: photoURL,
        placeHolder: placeholder,
        radius: radius,
      );

  const Avatar({
    super.key,
    this.userUID,
    this.photoURL,
    this.placeHolder,
    this.radius,
    this.onPressed,
  });
  //: assert(memberUID != null || photoURL != null, 'memberUID or photoURL must be provided');

  final String? photoURL;
  final String? placeHolder;
  final String? userUID;

  final double? radius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: _build());
  }

  Widget _build() {
    if (photoURL == null && placeHolder == null && userUID == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.green.shade100,
        child: const Icon(Icons.person),
      );
    }
    if (photoURL != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.green.shade100,
        backgroundImage: Image.network(
          photoURL!,
          errorBuilder: (context, error, stackTrace) => const LoadingScreen(),
        ).image,
      );
    } else {
      if (photoURL != null) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.green.shade100,
          child: Text(
            placeHolder!.substring(0, 1),
            style: TextStyle(fontSize: radius, color: Colors.white),
          ),
        );
      } else {
        return FutureBuilder(
          future: di<AuthRepository>().getUserByUID(userUID!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final user = snapshot.data!;
              return Builder(
                builder: (context) {
                  if (user.photoURL != null) {
                    return CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      backgroundImage: NetworkImage(user.photoURL!),
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
  }
}
