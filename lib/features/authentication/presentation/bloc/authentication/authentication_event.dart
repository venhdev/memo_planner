part of 'authentication_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthEvent {}

class StatusChanged extends AuthEvent {
  const StatusChanged({
    required this.status,
    required this.user,
  });
  final AuthenticationStatus status;
  final UserEntity? user;

  @override
  List<Object> get props => [status, user ?? ''];
}

class SignInWithEmail extends AuthEvent {
  const SignInWithEmail({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogle extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SignUpWithEmail extends AuthEvent {
  const SignUpWithEmail({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class UpdateDisplayName extends AuthEvent {
  const UpdateDisplayName({
    required this.name,
  });
  final String name;

  @override
  List<Object> get props => [name];
}
