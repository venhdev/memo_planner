part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStartedEvent extends AuthenticationEvent {}

class AuthenticationStatusChangedEvent extends AuthenticationEvent {
  const AuthenticationStatusChangedEvent({
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

class SignInWithEmailAndPasswordEvent extends AuthenticationEvent {
  const SignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthenticationEvent {
  const SignInWithGoogleEvent();

  @override
  List<Object> get props => [];
}

class SignOutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
