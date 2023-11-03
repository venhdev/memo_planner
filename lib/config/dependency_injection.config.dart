// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:memo_planner/config/dependency_injection.dart' as _i22;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i11;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i13;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i12;
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart'
    as _i15;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i18;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_google.dart'
    as _i19;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i20;
import 'package:memo_planner/features/authentication/presentation/bloc/bloc/authentication_bloc.dart'
    as _i21;
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart'
    as _i6;
import 'package:memo_planner/features/habit/data/repository/habit_repository_impl.dart'
    as _i8;
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart'
    as _i7;
import 'package:memo_planner/features/habit/domain/usecase/add_habit.dart'
    as _i10;
import 'package:memo_planner/features/habit/domain/usecase/delete_habit.dart'
    as _i14;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_stream.dart'
    as _i16;
import 'package:memo_planner/features/habit/domain/usecase/update_habit.dart'
    as _i9;
import 'package:memo_planner/features/habit/presentation/bloc/bloc/habit_bloc.dart'
    as _i17;

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
    gh.singleton<_i4.FirebaseFirestore>(registerModule.firestore);
    gh.singleton<_i5.GoogleSignIn>(registerModule.googleSignIn);
    gh.singleton<_i6.HabitDataSource>(
        _i6.HabitDataSourceImpl(gh<_i4.FirebaseFirestore>()));
    gh.singleton<_i7.HabitRepository>(
        _i8.HabitRepositoryImpl(gh<_i6.HabitDataSource>()));
    gh.singleton<_i9.UpdateHabitUC>(
        _i9.UpdateHabitUC(gh<_i7.HabitRepository>()));
    gh.singleton<_i10.AddHabitUC>(_i10.AddHabitUC(gh<_i7.HabitRepository>()));
    gh.singleton<_i11.AuthenticationDataSource>(
        _i11.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i5.GoogleSignIn>(),
    ));
    gh.singleton<_i12.AuthenticationRepository>(
        _i13.AuthenticationRepositoryImpl(gh<_i11.AuthenticationDataSource>()));
    gh.singleton<_i14.DeleteHabitUC>(
        _i14.DeleteHabitUC(gh<_i7.HabitRepository>()));
    gh.singleton<_i15.GetCurrentUserUC>(
        _i15.GetCurrentUserUC(gh<_i12.AuthenticationRepository>()));
    gh.singleton<_i16.GetHabitStreamUC>(
        _i16.GetHabitStreamUC(gh<_i7.HabitRepository>()));
    gh.factory<_i17.HabitBloc>(() => _i17.HabitBloc(
          gh<_i10.AddHabitUC>(),
          gh<_i9.UpdateHabitUC>(),
          gh<_i14.DeleteHabitUC>(),
          gh<_i15.GetCurrentUserUC>(),
        ));
    gh.singleton<_i18.SignInWithEmailAndPasswordUC>(
        _i18.SignInWithEmailAndPasswordUC(gh<_i12.AuthenticationRepository>()));
    gh.singleton<_i19.SignInWithGoogleUC>(
        _i19.SignInWithGoogleUC(gh<_i12.AuthenticationRepository>()));
    gh.singleton<_i20.SignOutUC>(
        _i20.SignOutUC(gh<_i12.AuthenticationRepository>()));
    gh.factory<_i21.AuthenticationBloc>(() => _i21.AuthenticationBloc(
          gh<_i18.SignInWithEmailAndPasswordUC>(),
          gh<_i20.SignOutUC>(),
          gh<_i3.FirebaseAuth>(),
          gh<_i19.SignInWithGoogleUC>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i22.RegisterModule {}
