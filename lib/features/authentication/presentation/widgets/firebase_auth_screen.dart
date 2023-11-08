// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'widgets.dart';

class AuthScreens extends StatelessWidget {
  const AuthScreens({
    super.key,
    required this.loggedIn,
  });

  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: StyledButton(
              onPressed: () {
                  !loggedIn
                    ? context.go('/authentication/sign-in')
                    : context.read<AuthenticationBloc>().add(SignOutEvent());
                // try {
                // } on FirebaseAuthException catch (e) {
                // }
              },
              child: !loggedIn ? const Text('Login') : const Text('Logout')),
        ),
        Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                  onPressed: () {
                    context.go('/authentication/profile');
                  },
                  child: const Text('Profile')),
            ))
      ],
    );
  }
}
