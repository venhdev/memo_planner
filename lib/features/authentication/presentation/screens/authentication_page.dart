import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../habit/presentation/bloc/habit/habit_bloc.dart';
import '../bloc/bloc/authentication_bloc.dart';
import 'profile_screen.dart';
import 'sign_in_screen.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          // showDialogErrorMessage(
          //     context: context,
          //     message: state.message!,
          //     icon: const Icon(Icons.error));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Logout success'),
            showCloseIcon: true,
          ));
        }
        if (state.status == AuthenticationStatus.authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login with ${state.user!.email}'),
            showCloseIcon: true,
          ));

          BlocProvider.of<HabitBloc>(context).add(HabitStartedEvent());
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
