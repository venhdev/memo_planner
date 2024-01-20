import 'package:flutter/material.dart';

import '../../config/dependency_injection.dart';
import '../../features/authentication/domain/repository/authentication_repository.dart';

/// if both memberUID and photoURL are provided, photoURL will be used
class Avatar extends StatelessWidget {
  factory Avatar.photoURL({
    required String? photoURL,
    required String placeHolder,
    double? radius,
    Color? backgroundColor,
  }) =>
      Avatar(
        photoURL: photoURL,
        placeHolder: placeHolder,
        radius: radius,
        backgroundColor: backgroundColor,
      );

  const Avatar({
    super.key,
    this.userUID,
    this.photoURL,
    this.placeHolder,
    this.radius,
    this.onPressed,
    this.backgroundColor,
    this.maxRadius,
  }) : assert((userUID == null || photoURL == null) && (radius == null || maxRadius == null));
  // You can only provide either userUID or photoURL, not both
  // You can only provide either radius or maxRadius, not both

  /// The URL of the photo
  final String? photoURL;

  /// The Character to show if photoURL is null
  final String? placeHolder;

  /// The UID of the user to get the photoURL from
  final String? userUID;

  final double? radius;
  final double? maxRadius;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed, child: _build());
  }

  Widget _build() {
    if (photoURL == null && placeHolder == null && userUID == null) {
      return CircleAvatar(
        radius: radius,
        maxRadius: maxRadius,
        backgroundColor: backgroundColor,
        child: const Icon(Icons.person),
      );
    }

    if (photoURL != null) {
      return CircleAvatar(
        radius: radius,
        maxRadius: maxRadius,
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(photoURL!),
        // backgroundImage: Image.network(
        //   photoURL!,
        //   errorBuilder: (context, error, stackTrace) => const LoadingScreen(),
        // ).image,
      );
    } else if (photoURL == null && placeHolder != null) {
      return CircleAvatar(
        radius: radius,
        maxRadius: maxRadius,
        backgroundColor: backgroundColor,
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
                    backgroundColor: backgroundColor,
                    maxRadius: maxRadius,
                    backgroundImage: NetworkImage(user.photoURL!),
                  );
                } else {
                  return CircleAvatar(
                    backgroundColor: backgroundColor,
                    maxRadius: maxRadius,
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
