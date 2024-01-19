import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/components/widgets.dart';
import '../bloc/authentication/authentication_bloc.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'), centerTitle: true),
      // drawer: const AppNavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildEmailBox(),
                const SizedBox(height: 16.0),
                _buildPasswordBox(),
                const SizedBox(height: 16.0),
                _buildSignInButton(context),
                const SizedBox(height: 16.0),
                const DividerWithText(text: 'Or sign in with'),
                const SizedBox(height: 16.0),
                _buildGoogleIconButton(),
                const SizedBox(height: 16.0),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _buildRegisterButton() {
    return TextButton(
      // NOTE: for testing
      // onLongPress: () async {
      //   final pending = await di<LocalNotificationService>().I.pendingNotificationRequests();
      //   final activate = await di<LocalNotificationService>().I.getActiveNotifications();

      //   // ignore: use_build_context_synchronously
      //   await showDialog(
      //     context: context,
      //     builder: (_) {
      //       return SimpleDialog(
      //         children: [
      //           Text('pending: ${pending.length}'),
      //           for (int i = 0; i < pending.length; i++)
      //             Text(
      //               '${pending[i].id} - ${pending[i].title} - ${pending[i].body}',
      //               maxLines: 2,
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           Text('activate: ${activate.length}'),
      //           for (int i = 0; i < activate.length; i++)
      //             Text(
      //               '${activate[i].id} - ${activate[i].title} - ${activate[i].body}',
      //               maxLines: 2,
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //         ],
      //       );
      //     },
      //   );
      // },
      onPressed: () {
        // context.go('/authentication/sign-up');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            ));
      },
      child: const Text(
        'Don\'t have an account? Register now',
        style: TextStyle(
          fontSize: 14.0,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  GestureDetector _buildGoogleIconButton() {
    return GestureDetector(
      onTap: () async {
        BlocProvider.of<AuthBloc>(context).add(
          SignInWithGoogle(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[400]!,
          ),
        ),
        child: SvgPicture.asset(
          'assets/images/icon/google.svg',
          height: 32.0,
          width: 32.0,
        ),
      ),
    );
  }

  ElevatedButton _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          BlocProvider.of<AuthBloc>(context).add(
            SignInWithEmail(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticating) {
            return const SizedBox(
              height: 16.0,
              width: 16.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          }
          return const Text(
            'Sign In',
            style: TextStyle(
              fontSize: 16.0,
            ),
          );
        },
      ),
    );
  }

  TextFormField _buildPasswordBox() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  TextFormField _buildEmailBox() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }
}
