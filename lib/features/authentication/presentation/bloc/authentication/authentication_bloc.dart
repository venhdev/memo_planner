import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/constants.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecase/update_display_name.dart';
import '../../../domain/usecase/usecases.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
    this._signInWithEmailAndPasswordUC,
    this._signOutUC,
    this._signInWithGoogleUC,
    this._getCurrentUserUC,
    this._signUpWithEmailUC,
    this._updateDisplayNameUC,
  ) : super(const AuthenticationState.unknown()) {
    on<InitialEvent>(_onInitial);
    on<StatusChanged>(_onAuthenticationStatusChanged);
    on<SignUpWithEmail>(_onSignUpWithEmail);
    on<SignInWithEmail>(_onSignedInWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<UpdateDisplayName>(_onUpdateDisplayName);
  }

  final SignUpWithEmailUC _signUpWithEmailUC;
  final SignInWithEmailAndPasswordUC _signInWithEmailAndPasswordUC;
  final SignInWithGoogleUC _signInWithGoogleUC;
  final SignOutUC _signOutUC;
  final GetCurrentUserUC _getCurrentUserUC;
  final UpdateDisplayNameUC _updateDisplayNameUC;

  void _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticating());
    final userEntityEither = await _signInWithGoogleUC();
    userEntityEither.fold(
      (failure) => emit(AuthenticationState.unauthenticated(message: failure.message)),
      (userEntity) =>
          emit(AuthenticationState.authenticated(userEntity, message: 'Welcome back ${userEntity.displayName}')),
    );
  }

  void _onSignedInWithEmailAndPassword(
    SignInWithEmail event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticating());
    final userEntityEither =
        await _signInWithEmailAndPasswordUC(SignInParams(email: event.email, password: event.password));

    userEntityEither.fold(
      (failure) => emit(AuthenticationState.unauthenticated(message: failure.message)),
      (userEntity) =>
          emit(AuthenticationState.authenticated(userEntity, message: 'Welcome back ${userEntity.displayName}')),
    );
  }

  void _onInitial(
    InitialEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final user = _getCurrentUserUC();
    if (user != null) {
      emit(AuthenticationState.authenticated(user));
    } else {
      emit(
        const AuthenticationState.unauthenticated(message: kUserNotLogin),
      );
    }
  }

  void _onSignOut(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticating());
    try {
      await _signOutUC();
      emit(const AuthenticationState.unauthenticated(message: 'Sign out success'));
    } catch (e) {
      emit(const AuthenticationState.unauthenticated(message: 'Sign out failed'));
    }
  }

  void _onAuthenticationStatusChanged(
    StatusChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationState.authenticating());
    if (event.status == AuthenticationStatus.authenticated) {
      emit(AuthenticationState.authenticated(event.user!));
    } else {
      emit(const AuthenticationState.unauthenticated(message: kUserNotLogin));
    }
  }

  void _onSignUpWithEmail(
    SignUpWithEmail event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticating());
    final result = await _signUpWithEmailUC(
      SignUpParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthenticationState.unauthenticated(message: failure.message)),
      (userEntity) => emit(AuthenticationState.authenticated(userEntity)),
    );
  }

  void _onUpdateDisplayName(
    UpdateDisplayName event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _updateDisplayNameUC(event.name).then(
      (value) {
        final user = _getCurrentUserUC();
        emit(AuthenticationState.authenticated(user!));
      },
    );
  }
}
