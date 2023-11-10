import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/authentication/presentation/bloc/bloc/authentication_bloc.dart';

import '../../../../core/widgets/widgets.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        SignInWithEmailAndPasswordEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const DividerWithText(text: 'Or sign in with'),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () async {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      SignInWithGoogleEvent(),
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
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    context.go('/authentication/sign-up');
                  },
                  child: const Text(
                    'Don\'t have an account? Register now',
                    style: TextStyle(
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
