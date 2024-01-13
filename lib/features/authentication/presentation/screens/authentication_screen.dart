import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/common_screen.dart';
import '../bloc/authentication/authentication_bloc.dart';
import 'profile_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return ProfileScreen(user: state.user!);
        } else if (state.status == AuthenticationStatus.authenticating) {
          return const LoadingScreen();
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
