part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  unknown,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.message,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticating()
      : this._(
          status: AuthenticationStatus.authenticating,
        );

  const AuthState.authenticated(UserEntity user, {String? message})
      : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
          message: message,
        );

  const AuthState.unauthenticated({String? message})
      : this._(
          status: AuthenticationStatus.unauthenticated,
          message: message,
          user: null,
        );

  final AuthenticationStatus status;
  final UserEntity? user;
  final String? message;

  @override
  List<Object?> get props => [
        status,
        user,
        message,
      ];
}
