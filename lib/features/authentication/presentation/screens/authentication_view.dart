import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../bloc/bloc/authentication_bloc.dart';
import 'profile_screen.dart';
import 'sign_in_screen.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          showDialogErrorMessage(
              context: context,
              message: state.message!,
              icon: const Icon(Icons.error));

          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: Text(state.message!),
          //       backgroundColor: Colors.red,
          //     ),
          //   );
        }
      },
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return ProfileScreen(user: state.user!);
        } else if (state.status == AuthenticationStatus.unauthenticated) {
          return const SignInScreen();
        } else if (state.status == AuthenticationStatus.authenticating) {
          return const Scaffold(body: LoadingScreen());
        } else {
          debugPrint('AuthenticationView: build: LoadingScreen [ui01]');
          return const Scaffold(body: LoadingScreen());
        }
      },
    );
  }
}
