// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/authentication_bloc.dart';
import 'profile_screen.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return ProfileScreen();
        // if (state.status == AuthenticationStatus.authenticated) {
        //   return ProfileScreen();
        // } else if (state.status == AuthenticationStatus.unauthenticated) {
        //   return const SignInScreen();
        // } else {
        //   debugPrint('AuthenticationView: build: LoadingScreen [ui01]');
        //   return const Scaffold(
        //     body: LoadingScreen(),
        //   );
        // }
      },
    );
  }
}
