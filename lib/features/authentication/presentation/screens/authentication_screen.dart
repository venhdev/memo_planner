import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication/authentication_bloc.dart';
import 'screens.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        // the state properly is not null <- check when the app is first loaded
        return ProfileScreen(user: state.user!);
        // if (state.status == AuthenticationStatus.authenticated) {
        // } else if (state.status == AuthenticationStatus.unauthenticated) {
        //   return const SignInScreen();
        // } else if (state.status == AuthenticationStatus.authenticating) {
        //   return const LoadingScreen();
        // } else {
        //   return const LoadingScreen();
        //   // return const MessageScreen(
        //   //   message: 'Something went wrong! [e07]',
        //   //   enableBack: false,
        //   // );
        // }
      },
    );
  }
}
