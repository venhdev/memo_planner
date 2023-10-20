part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStartedEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationStatusChangedEvent extends AuthenticationEvent {
  final AuthenticationStatus status;
  final User? user;

  const AuthenticationStatusChangedEvent({
    required this.status,
    required this.user,
  });

  @override
  List<Object> get props => [
        status,
        user ?? user == null,
      ];
}

class SignInWithEmailAndPasswordEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInWithEmailAndPasswordEvent(
    this.email,
    this.password,
  );

  @override
  List<Object> get props => [email, password];
}

class SignOutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
