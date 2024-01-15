part of 'authentication_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthEvent {}

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

class UpdateAvatar extends AuthEvent {
  const UpdateAvatar({
    required this.imageFile,
  });
  final XFile imageFile;

  @override
  List<Object> get props => [imageFile];
}
