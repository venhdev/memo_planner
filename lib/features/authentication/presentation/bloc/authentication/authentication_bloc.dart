import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthState.unknown()) {
    on<AuthInitial>(_onInitial);
    on<SignUpWithEmail>(_onSignUpWithEmail);
    on<SignInWithEmail>(_onSignedInWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<UpdateDisplayName>(_onUpdateDisplayName);
    on<UpdateAvatar>(_onUpdateAvatar);
  }
  final AuthRepository _authRepository;

  FutureOr<void> _onInitial(AuthInitial event, Emitter<AuthState> emit) async {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      _authRepository.signInSilentlyWithGoogle();
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  FutureOr<void> _onSignInWithGoogle(SignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());
    final userEntityEither = await _authRepository.signInWithGoogle();
    userEntityEither.fold(
      (failure) => emit(AuthState.unauthenticated(message: failure.message)),
      (userEntity) => emit(AuthState.authenticated(userEntity, message: 'Hi ${userEntity.displayName ?? userEntity.email}')),
    );
  }

  FutureOr<void> _onSignedInWithEmailAndPassword(SignInWithEmail event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());
    final userEntityEither = await _authRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    userEntityEither.fold(
      (failure) => emit(AuthState.unauthenticated(message: failure.message)),
      (userEntity) => emit(AuthState.authenticated(userEntity, message: 'Hi ${userEntity.displayName ?? userEntity.email}')),
    );
  }

  FutureOr<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());
    try {
      final resultEither = await _authRepository.signOut();
      resultEither.fold(
        (failure) => emit(AuthState.unauthenticated(message: failure.message)),
        (_) => emit(const AuthState.unauthenticated(message: 'Sign out success')),
      );
    } catch (e) {
      log('_onSignOut Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
      emit(const AuthState.unauthenticated(message: 'Sign out failed'));
    }
  }

  FutureOr<void> _onSignUpWithEmail(SignUpWithEmail event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());
    final result = await _authRepository.signUpWithEmail(email: event.email, password: event.password);
    result.fold(
      (failure) => emit(AuthState.unauthenticated(message: failure.message)),
      (userEntity) => emit(AuthState.authenticated(userEntity, message: 'Sign up success')),
    );
  }

  FutureOr<void> _onUpdateDisplayName(UpdateDisplayName event, Emitter<AuthState> emit) async {
    await _authRepository.updateDisplayName(event.name).then(
      (value) {
        emit(AuthState.authenticated(state.user!.copyWith(displayName: event.name)));
      },
    );
  }

  FutureOr<void> _onUpdateAvatar(UpdateAvatar event, Emitter<AuthState> emit) async {
    await _authRepository.updateUserAvatar(event.imageFile).then(
      (value) {
        value.fold(
          (failure) => emit(AuthState.unauthenticated(message: failure.message)),
          (url) => emit(AuthState.authenticated(state.user!.copyWith(photoURL: url))),
        );
      },
    );
  }
}
