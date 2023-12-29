part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends AuthenticationEvent {}

class StatusChanged extends AuthenticationEvent {
  const StatusChanged({
    required this.status,
    required this.user,
  });
  final AuthenticationStatus status;
  final UserEntity? user;

  @override
  List<Object> get props => [status, user ?? ''];
}

class SignInWithEmail extends AuthenticationEvent {
  const SignInWithEmail({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogle extends AuthenticationEvent {}

class SignOutEvent extends AuthenticationEvent {}

class SignUpWithEmail extends AuthenticationEvent {
  const SignUpWithEmail({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class UpdateDisplayName extends AuthenticationEvent {
  const UpdateDisplayName({
    required this.name,
  });
  final String name;

  @override
  List<Object> get props => [name];
}
