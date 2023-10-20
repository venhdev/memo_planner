// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:memo_planner/core/utils/di.dart' as _i10;
import 'package:memo_planner/features/authentication/data/data_sources/firebase_authentication_service.dart'
    as _i4;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i6;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i5;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i7;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i8;
import 'package:memo_planner/features/authentication/presentation/bloc/bloc/authentication_bloc.dart'
    as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.FirebaseAuth>(registerModule.firebaseAuth);
    gh.singleton<_i4.FireBaseAuthenticationService>(
        _i4.FireBaseAuthenticationServiceImpl(gh<_i3.FirebaseAuth>()));
    gh.singleton<_i5.AuthenticationRepository>(_i6.AuthenticationRepositoryImpl(
        gh<_i4.FireBaseAuthenticationService>()));
    gh.singleton<_i7.SignInWithEmailAndPasswordUC>(
        _i7.SignInWithEmailAndPasswordUC(gh<_i5.AuthenticationRepository>()));
    gh.singleton<_i8.SignOutUC>(
        _i8.SignOutUC(gh<_i5.AuthenticationRepository>()));
    gh.factory<_i9.AuthenticationBloc>(() => _i9.AuthenticationBloc(
          gh<_i7.SignInWithEmailAndPasswordUC>(),
          gh<_i8.SignOutUC>(),
          gh<_i3.FirebaseAuth>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i10.RegisterModule {}
