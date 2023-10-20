import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecase/sign_in_with_email_and_password.dart';
import '../../../domain/usecase/sign_out.dart';

import '../../../../../core/usecase/usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithEmailAndPasswordUC _signInWithEmailAndPasswordUC;
  final SignOutUC _signOutUC;
  final FirebaseAuth _firebaseAuth;

  AuthenticationBloc(
    this._signInWithEmailAndPasswordUC,
    this._signOutUC,
    this._firebaseAuth,
  ) : super(const AuthenticationState.unknown()) {
    on<AuthenticationStartedEvent>(_onAuthenticationStarted);
    on<AuthenticationStatusChangedEvent>(_onAuthenticationStatusChanged);
    on<SignInWithEmailAndPasswordEvent>(_onSignedInWithEmailAndPassword);
    on<SignOutEvent>(_onSignOut);
  }

  void _onSignedInWithEmailAndPassword(
    SignInWithEmailAndPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final userCredential = await _signInWithEmailAndPasswordUC(
          SignInParams(email: event.email, password: event.password));

      userCredential.fold(
        (failure) =>
            emit(AuthenticationState.unauthenticated(message: failure.message)),
        (userCredential) =>
            emit(AuthenticationState.authenticated(userCredential.user!)),
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
    debugPrint('===================> AuthenticationBloc: $user');
    if (user != null) {
      emit(AuthenticationState.authenticated(user));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onSignOut(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _signOutUC(NoParams());
      emit(const AuthenticationState.unauthenticated());
    } catch (e) {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onAuthenticationStatusChanged (
    AuthenticationStatusChangedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (event.status == AuthenticationStatus.authenticated) {
      emit(AuthenticationState.authenticated(event.user!));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }
}
