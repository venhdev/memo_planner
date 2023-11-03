import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_google.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/user_entity.dart';

import '../../../domain/usecase/sign_in_with_email_and_password.dart';
import '../../../domain/usecase/sign_out.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
    this._signInWithEmailAndPasswordUC,
    this._signOutUC,
    this._firebaseAuth,
    this._signInWithGoogleUC,
  ) : super(const AuthenticationState.unknown()) {
    on<AuthenticationStartedEvent>(_onAuthenticationStarted);
    on<AuthenticationStatusChangedEvent>(_onAuthenticationStatusChanged);
    on<SignInWithEmailAndPasswordEvent>(_onSignedInWithEmailAndPassword);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
  }

  final SignInWithEmailAndPasswordUC _signInWithEmailAndPasswordUC;
  final SignInWithGoogleUC _signInWithGoogleUC;
  final SignOutUC _signOutUC;
  final FirebaseAuth _firebaseAuth;

  FutureOr<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final userEntityEither = await _signInWithGoogleUC();

      userEntityEither.fold(
        (failure) =>
            emit(AuthenticationState.unauthenticated(message: failure.message)),
        (userEntity) => emit(AuthenticationState.authenticated(userEntity)),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState.unauthenticated(message: e.message.toString()));
    } catch (e) {
      emit(AuthenticationState.unauthenticated(message: e.toString()));
    }
  }

  void _onSignedInWithEmailAndPassword(
    SignInWithEmailAndPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final userEntityEither = await _signInWithEmailAndPasswordUC(
          SignInParams(email: event.email, password: event.password));

      userEntityEither.fold(
        (failure) =>
            emit(AuthenticationState.unauthenticated(message: failure.message)),
        (userEntity) => emit(AuthenticationState.authenticated(userEntity)),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState.unauthenticated(message: e.message.toString()));
    } catch (e) {
      emit(AuthenticationState.unauthenticated(message: e.toString()));
    }
  }

  void _onAuthenticationStarted(
    AuthenticationStartedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      emit(AuthenticationState.authenticated(UserModel.fromUser(user)));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onSignOut(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _signOutUC();
      emit(const AuthenticationState.unauthenticated());
    } catch (e) {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChangedEvent event,
    Emitter<AuthenticationState> emit,
  ) {
    if (event.status == AuthenticationStatus.authenticated) {
      emit(AuthenticationState.authenticated(event.user!));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }
}
