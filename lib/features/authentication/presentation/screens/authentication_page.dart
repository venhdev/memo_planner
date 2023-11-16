import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../habit/presentation/bloc/habit/habit_bloc.dart';
import '../bloc/bloc/authentication_bloc.dart';
import 'profile_screen.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.buildAppBar(
        context: context,
      ),
      drawer: const AppNavigationDrawer(),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.status == AuthenticationStatus.unauthenticated) {
            showAlertDialogMessage(
              context: context,
              message: state.message!,
              icon: const Icon(Icons.error),
            );
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //   content: Text('Logout success'),
            //   showCloseIcon: true,
            // ));
          }
          if (state.status == AuthenticationStatus.authenticated) {
            showAlertDialogMessage(context: context, message: 'Login Success!', icon: const Icon(Icons.check));
            BlocProvider.of<HabitBloc>(context).add(HabitStartedEvent());
            context.go('/authentication');

            // duration for 1s and then go to /habit
            Future.delayed(const Duration(seconds: 1), () {
              context.go('/habit');
            });
          }
        },
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return ProfileScreen(user: state.user!);
          } else if (state.status == AuthenticationStatus.unauthenticated) {
            return MessageScreenWithAction(
              message: 'Please sign in to continue',
              buttonText: 'Sign in',
              onPressed: () {
                context.go('/authentication/sign-in');
              },
            );
          } else if (state.status == AuthenticationStatus.authenticating) {
            return const LoadingScreen();
          } else {
            return const MessageScreen(message: 'Something went wrong! [e07]');
          }
        },
      ),
    );
  }
}
