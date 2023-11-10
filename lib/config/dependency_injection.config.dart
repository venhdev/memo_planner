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
import 'package:memo_planner/config/dependency_injection.dart' as _i33;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i7;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i9;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i8;
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart'
    as _i10;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i16;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_google.dart'
    as _i17;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i18;
import 'package:memo_planner/features/authentication/domain/usecase/sign_up_with_email.dart'
    as _i19;
import 'package:memo_planner/features/authentication/domain/usecase/usecases.dart'
    as _i24;
import 'package:memo_planner/features/authentication/presentation/bloc/bloc/authentication_bloc.dart'
    as _i23;
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart'
    as _i11;
import 'package:memo_planner/features/habit/data/data_sources/habit_instance_data_source.dart'
    as _i6;
import 'package:memo_planner/features/habit/data/repository/habit_instance_repository_impl.dart'
    as _i13;
import 'package:memo_planner/features/habit/data/repository/habit_repository_impl.dart'
    as _i15;
import 'package:memo_planner/features/habit/domain/repository/habit_instance_repository.dart'
    as _i12;
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart'
    as _i14;
import 'package:memo_planner/features/habit/domain/usecase/add_habit.dart'
    as _i22;
import 'package:memo_planner/features/habit/domain/usecase/add_habit_instance.dart'
    as _i21;
import 'package:memo_planner/features/habit/domain/usecase/change_habit_instance_status.dart'
    as _i25;
import 'package:memo_planner/features/habit/domain/usecase/delete_habit.dart'
    as _i26;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_instances.dart'
    as _i27;
import 'package:memo_planner/features/habit/domain/usecase/get_habits.dart'
    as _i28;
import 'package:memo_planner/features/habit/domain/usecase/get_top_streak.dart'
    as _i29;
import 'package:memo_planner/features/habit/domain/usecase/update_habit.dart'
    as _i20;
import 'package:memo_planner/features/habit/domain/usecase/usecases.dart'
    as _i32;
import 'package:memo_planner/features/habit/presentation/bloc/habit/habit_bloc.dart'
    as _i30;
import 'package:memo_planner/features/habit/presentation/bloc/instance/instance_bloc.dart'
    as _i31;

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
    gh.singleton<_i6.HabitInstanceDataSource>(
        _i6.HabitInstanceDataSourceImpl(gh<_i4.FirebaseFirestore>()));
    gh.singleton<_i7.AuthenticationDataSource>(_i7.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i5.GoogleSignIn>(),
    ));
    gh.singleton<_i8.AuthenticationRepository>(
        _i9.AuthenticationRepositoryImpl(gh<_i7.AuthenticationDataSource>()));
    gh.singleton<_i10.GetCurrentUserUC>(
        _i10.GetCurrentUserUC(gh<_i8.AuthenticationRepository>()));
    gh.singleton<_i11.HabitDataSource>(_i11.HabitDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i7.AuthenticationDataSource>(),
    ));
    gh.singleton<_i12.HabitInstanceRepository>(_i13.HabitInstanceRepositoryImpl(
      gh<_i6.HabitInstanceDataSource>(),
      gh<_i11.HabitDataSource>(),
    ));
    gh.singleton<_i14.HabitRepository>(
        _i15.HabitRepositoryImpl(gh<_i11.HabitDataSource>()));
    gh.singleton<_i16.SignInWithEmailAndPasswordUC>(
        _i16.SignInWithEmailAndPasswordUC(gh<_i8.AuthenticationRepository>()));
    gh.singleton<_i17.SignInWithGoogleUC>(
        _i17.SignInWithGoogleUC(gh<_i8.AuthenticationRepository>()));
    gh.singleton<_i18.SignOutUC>(
        _i18.SignOutUC(gh<_i8.AuthenticationRepository>()));
    gh.singleton<_i19.SignUpWithEmailUC>(
        _i19.SignUpWithEmailUC(gh<_i8.AuthenticationRepository>()));
    gh.singleton<_i20.UpdateHabitUC>(
        _i20.UpdateHabitUC(gh<_i14.HabitRepository>()));
    gh.singleton<_i21.AddHabitInstanceUC>(
        _i21.AddHabitInstanceUC(gh<_i12.HabitInstanceRepository>()));
    gh.singleton<_i22.AddHabitUC>(_i22.AddHabitUC(gh<_i14.HabitRepository>()));
    gh.factory<_i23.AuthenticationBloc>(() => _i23.AuthenticationBloc(
          gh<_i24.SignInWithEmailAndPasswordUC>(),
          gh<_i24.SignOutUC>(),
          gh<_i24.SignInWithGoogleUC>(),
          gh<_i24.GetCurrentUserUC>(),
          gh<_i24.SignUpWithEmailUC>(),
        ));
    gh.singleton<_i25.ChangeHabitInstanceStatusUC>(
        _i25.ChangeHabitInstanceStatusUC(gh<_i12.HabitInstanceRepository>()));
    gh.singleton<_i26.DeleteHabitUC>(
        _i26.DeleteHabitUC(gh<_i14.HabitRepository>()));
    gh.singleton<_i27.GetHabitInstanceStreamUC>(
        _i27.GetHabitInstanceStreamUC(gh<_i12.HabitInstanceRepository>()));
    gh.singleton<_i28.GetHabitUC>(_i28.GetHabitUC(gh<_i14.HabitRepository>()));
    gh.singleton<_i29.GetTopStreakUC>(
        _i29.GetTopStreakUC(gh<_i12.HabitInstanceRepository>()));
    gh.factory<_i30.HabitBloc>(() => _i30.HabitBloc(
          gh<_i22.AddHabitUC>(),
          gh<_i20.UpdateHabitUC>(),
          gh<_i26.DeleteHabitUC>(),
          gh<_i10.GetCurrentUserUC>(),
          gh<_i28.GetHabitUC>(),
          gh<_i21.AddHabitInstanceUC>(),
        ));
    gh.factory<_i31.HabitInstanceBloc>(() => _i31.HabitInstanceBloc(
          gh<_i32.AddHabitInstanceUC>(),
          gh<_i32.ChangeHabitInstanceStatusUC>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i33.RegisterModule {}
