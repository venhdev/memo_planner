part of 'routes.dart';

final providers = [EmailAuthProvider()];

final GoRoute authenticationRoute = GoRoute(
    path: '/authentication',
    builder: (context, state) {
      return const UserPage();
    },
    routes: [
      // /sign-in
      GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              providers: providers,
              actions: [
                // to get current user email and pass to the forgot password screen
                ForgotPasswordAction((context, email) {
                  final uri = Uri(
                    path: '/authentication/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                }),
                AuthStateChangeAction((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationStatusChangedEvent(
                    status: AuthenticationStatus.authenticated,
                    user: user,
                  ));
                  context.go('/authentication');
                })
              ],
            );
          },
          routes: [
            GoRoute(
                path: 'forgot-password',
                builder: (context, state) {
                  final email = state.uri.queryParameters['email'] ?? '';
                  return ForgotPasswordScreen(email: email);
                }),
          ]),
      // profile
      GoRoute(
        path: 'profile',
        builder: (context, state) {
          return ProfileScreen(
            actions: [
              SignedOutAction((context) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(const AuthenticationStatusChangedEvent(
                  status: AuthenticationStatus.unauthenticated,
                  user: null,
                ));
                context.go('/authentication');
              })
            ],
          );
        },
      ),
    ]);
