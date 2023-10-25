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
import 'package:injectable/injectable.dart' as _i2;
import 'package:memo_planner/core/utils/di.dart' as _i20;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i10;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i12;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i11;
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart'
    as _i14;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i17;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i18;
import 'package:memo_planner/features/authentication/presentation/bloc/bloc/authentication_bloc.dart'
    as _i19;
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart'
    as _i5;
import 'package:memo_planner/features/habit/data/repository/habit_repository_impl.dart'
    as _i7;
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart'
    as _i6;
import 'package:memo_planner/features/habit/domain/usecase/add_habit.dart'
    as _i9;
import 'package:memo_planner/features/habit/domain/usecase/delete_habit.dart'
    as _i13;
import 'package:memo_planner/features/habit/domain/usecase/get_habits.dart'
    as _i15;
import 'package:memo_planner/features/habit/domain/usecase/update_habit.dart'
    as _i8;
import 'package:memo_planner/features/habit/presentation/bloc/bloc/habit_bloc.dart'
    as _i16;

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
    gh.singleton<_i5.HabitDataSource>(
        _i5.HabitDataSourceImpl(gh<_i4.FirebaseFirestore>()));
    gh.singleton<_i6.HabitRepository>(
        _i7.HabitRepositoryImpl(gh<_i5.HabitDataSource>()));
    gh.singleton<_i8.UpdateHabitUC>(
        _i8.UpdateHabitUC(gh<_i6.HabitRepository>()));
    gh.singleton<_i9.AddHabitUC>(_i9.AddHabitUC(gh<_i6.HabitRepository>()));
    gh.singleton<_i10.AuthenticationDataSource>(
        _i10.AuthenticationDataSourceImpl(gh<_i3.FirebaseAuth>()));
    gh.singleton<_i11.AuthenticationRepository>(
        _i12.AuthenticationRepositoryImpl(gh<_i10.AuthenticationDataSource>()));
    gh.singleton<_i13.DeleteHabitUC>(
        _i13.DeleteHabitUC(gh<_i6.HabitRepository>()));
    gh.singleton<_i14.GetCurrentUserUC>(
        _i14.GetCurrentUserUC(gh<_i11.AuthenticationRepository>()));
    gh.singleton<_i15.GetHabitsUC>(_i15.GetHabitsUC(gh<_i6.HabitRepository>()));
    gh.factory<_i16.HabitBloc>(() => _i16.HabitBloc(
          gh<_i9.AddHabitUC>(),
          gh<_i8.UpdateHabitUC>(),
          gh<_i13.DeleteHabitUC>(),
          gh<_i14.GetCurrentUserUC>(),
        ));
    gh.singleton<_i17.SignInWithEmailAndPasswordUC>(
        _i17.SignInWithEmailAndPasswordUC(gh<_i11.AuthenticationRepository>()));
    gh.singleton<_i18.SignOutUC>(
        _i18.SignOutUC(gh<_i11.AuthenticationRepository>()));
    gh.factory<_i19.AuthenticationBloc>(() => _i19.AuthenticationBloc(
          gh<_i17.SignInWithEmailAndPasswordUC>(),
          gh<_i18.SignOutUC>(),
          gh<_i3.FirebaseAuth>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i20.RegisterModule {}
