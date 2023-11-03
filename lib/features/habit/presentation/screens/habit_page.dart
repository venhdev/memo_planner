import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

import '../../../authentication/presentation/bloc/bloc/authentication_bloc.dart';
import '../widgets/widgets.dart';

class HabitPage extends StatelessWidget {
  HabitPage({super.key});
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/codelab.png',
            height: 100,
            width: 100,
          ),
          Image.network(
            'https://picsum.photos/250?image=9',
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
          const Text('Habit Page'),
          Text('Screen Width: ${MediaQuery.of(context).size.width}'),
          Text('Screen Height: ${MediaQuery.of(context).size.height}'),
          AddHabitForm(
            titleController: _titleController,
            descriptionController: _descriptionController,
          ),
          const SizedBox(height: 20.0),
          const SignInGoogleDemo(),
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return HabitListViews();
              } else {
                return const Text('You are not authenticated');
              }
            },
          ),
        ],
      ),
    );
  }
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '[YOUR_OAUTH_2_CLIENT_ID]',
  scopes: <String>[CalendarApi.calendarScope],
);

class SignInGoogleDemo extends StatefulWidget {
  const SignInGoogleDemo({
    super.key,
  });

  @override
  State<SignInGoogleDemo> createState() => _SignInGoogleDemoState();
}

class _SignInGoogleDemoState extends State<SignInGoogleDemo> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        debugPrint('User is NOT null');
      } else {
        debugPrint('User is null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Column(
          children: [
            Builder(
              builder: (context) {
                if (_currentUser != null) {
                  return ElevatedButton(
                    onPressed: () async {
                      debugPrint('Sign Out Clicked');
                      await _googleSignIn.disconnect();
                    },
                    child: const Text('Sign Out'),
                  );
                } else {
                  return const Text('User is not signed in');
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                debugPrint('ElevatedButton Clicked');
                try {
                  final GoogleSignInAccount? googleSignInAccount =
                      await _googleSignIn.signIn();
                  debugPrint('authClient: $googleSignInAccount');

                  _googleSignIn.authenticatedClient().then((value) {
                    debugPrint('authClient OK: $value');
                  });
                } catch (error) {
                  debugPrint('Error: $error');
                }
              },
              child: const Text('Sign In With Google'),
            ),
          ],
        ));
  }
}
