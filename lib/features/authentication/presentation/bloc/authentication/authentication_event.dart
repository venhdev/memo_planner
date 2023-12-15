part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationEventStarted extends AuthenticationEvent {
  const AuthenticationEventStarted();

  @override
  List<Object> get props => [];
}

class AuthenticationEventStatusChanged extends AuthenticationEvent {
  const AuthenticationEventStatusChanged({
    required this.status,
    required this.user,
  });
  final AuthenticationStatus status;
  final UserEntity? user;

  @override
  List<Object> get props => [
        status,
        user ?? user == null,
      ];
}

class AuthenticationEventSignIn extends AuthenticationEvent {
  const AuthenticationEventSignIn({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class AuthenticationEventSignInWithGoogle extends AuthenticationEvent {}

class SignOutEvent extends AuthenticationEvent {}

class SignUpWithEmailEvent extends AuthenticationEvent {
  const SignUpWithEmailEvent({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
