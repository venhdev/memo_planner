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
import 'package:memo_planner/config/dependency_injection.dart' as _i36;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i6;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i8;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i7;
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart'
    as _i9;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i16;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_google.dart'
    as _i17;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i18;
import 'package:memo_planner/features/authentication/domain/usecase/sign_up_with_email.dart'
    as _i19;
import 'package:memo_planner/features/authentication/domain/usecase/usecases.dart'
    as _i25;
import 'package:memo_planner/features/authentication/presentation/bloc/bloc/authentication_bloc.dart'
    as _i24;
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart'
    as _i10;
import 'package:memo_planner/features/habit/data/data_sources/habit_instance_data_source.dart'
    as _i11;
import 'package:memo_planner/features/habit/data/repository/habit_instance_repository_impl.dart'
    as _i13;
import 'package:memo_planner/features/habit/data/repository/habit_repository_impl.dart'
    as _i15;
import 'package:memo_planner/features/habit/domain/repository/habit_instance_repository.dart'
    as _i12;
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart'
    as _i14;
import 'package:memo_planner/features/habit/domain/usecase/add_habit.dart'
    as _i23;
import 'package:memo_planner/features/habit/domain/usecase/add_habit_instance.dart'
    as _i22;
import 'package:memo_planner/features/habit/domain/usecase/change_habit_instance_status.dart'
    as _i26;
import 'package:memo_planner/features/habit/domain/usecase/delete_habit.dart'
    as _i27;
import 'package:memo_planner/features/habit/domain/usecase/get_create_habit_instance_by_iid.dart'
    as _i28;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_by_hid.dart'
    as _i29;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_instances.dart'
    as _i30;
import 'package:memo_planner/features/habit/domain/usecase/get_habits.dart'
    as _i31;
import 'package:memo_planner/features/habit/domain/usecase/get_top_streak.dart'
    as _i32;
import 'package:memo_planner/features/habit/domain/usecase/update_habit.dart'
    as _i21;
import 'package:memo_planner/features/habit/domain/usecase/update_habit_instance.dart'
    as _i20;
import 'package:memo_planner/features/habit/domain/usecase/usecases.dart'
    as _i35;
import 'package:memo_planner/features/habit/presentation/bloc/habit/habit_bloc.dart'
    as _i33;
import 'package:memo_planner/features/habit/presentation/bloc/instance/instance_bloc.dart'
    as _i34;

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
    gh.singleton<_i6.AuthenticationDataSource>(_i6.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i5.GoogleSignIn>(),
    ));
    gh.singleton<_i7.AuthenticationRepository>(
        _i8.AuthenticationRepositoryImpl(gh<_i6.AuthenticationDataSource>()));
    gh.singleton<_i9.GetCurrentUserUC>(
        _i9.GetCurrentUserUC(gh<_i7.AuthenticationRepository>()));
    gh.singleton<_i10.HabitDataSource>(_i10.HabitDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i6.AuthenticationDataSource>(),
    ));
    gh.singleton<_i11.HabitInstanceDataSource>(_i11.HabitInstanceDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i6.AuthenticationDataSource>(),
    ));
    gh.singleton<_i12.HabitInstanceRepository>(
        _i13.HabitInstanceRepositoryImpl(gh<_i11.HabitInstanceDataSource>()));
    gh.singleton<_i14.HabitRepository>(
        _i15.HabitRepositoryImpl(gh<_i10.HabitDataSource>()));
    gh.singleton<_i16.SignInWithEmailAndPasswordUC>(
        _i16.SignInWithEmailAndPasswordUC(gh<_i7.AuthenticationRepository>()));
    gh.singleton<_i17.SignInWithGoogleUC>(
        _i17.SignInWithGoogleUC(gh<_i7.AuthenticationRepository>()));
    gh.singleton<_i18.SignOutUC>(
        _i18.SignOutUC(gh<_i7.AuthenticationRepository>()));
    gh.singleton<_i19.SignUpWithEmailUC>(
        _i19.SignUpWithEmailUC(gh<_i7.AuthenticationRepository>()));
    gh.singleton<_i20.UpdateHabitInstanceUC>(
        _i20.UpdateHabitInstanceUC(gh<_i12.HabitInstanceRepository>()));
    gh.singleton<_i21.UpdateHabitUC>(
        _i21.UpdateHabitUC(gh<_i14.HabitRepository>()));
    gh.singleton<_i22.AddHabitInstanceUC>(
        _i22.AddHabitInstanceUC(gh<_i12.HabitInstanceRepository>()));
    gh.singleton<_i23.AddHabitUC>(_i23.AddHabitUC(gh<_i14.HabitRepository>()));
    gh.factory<_i24.AuthenticationBloc>(() => _i24.AuthenticationBloc(
          gh<_i25.SignInWithEmailAndPasswordUC>(),
          gh<_i25.SignOutUC>(),
          gh<_i25.SignInWithGoogleUC>(),
          gh<_i25.GetCurrentUserUC>(),
          gh<_i25.SignUpWithEmailUC>(),
        ));
    gh.singleton<_i26.ChangeHabitInstanceStatusUC>(
        _i26.ChangeHabitInstanceStatusUC(gh<_i12.HabitInstanceRepository>()));
    gh.singleton<_i27.DeleteHabitUC>(
        _i27.DeleteHabitUC(gh<_i14.HabitRepository>()));
    gh.singleton<_i28.GetCreateHabitInstanceByIid>(
        _i28.GetCreateHabitInstanceByIid(
      gh<_i12.HabitInstanceRepository>(),
      gh<_i14.HabitRepository>(),
    ));
    gh.singleton<_i29.GetHabitByHidUC>(
        _i29.GetHabitByHidUC(gh<_i14.HabitRepository>()));
    gh.singleton<_i30.GetHabitInstanceStreamUC>(
        _i30.GetHabitInstanceStreamUC(gh<_i12.HabitInstanceRepository>()));
    gh.singleton<_i31.GetHabitStreamUC>(
        _i31.GetHabitStreamUC(gh<_i14.HabitRepository>()));
    gh.singleton<_i32.GetTopStreakUC>(
        _i32.GetTopStreakUC(gh<_i14.HabitRepository>()));
    gh.factory<_i33.HabitBloc>(() => _i33.HabitBloc(
          gh<_i23.AddHabitUC>(),
          gh<_i21.UpdateHabitUC>(),
          gh<_i27.DeleteHabitUC>(),
          gh<_i9.GetCurrentUserUC>(),
          gh<_i31.GetHabitStreamUC>(),
          gh<_i22.AddHabitInstanceUC>(),
        ));
    gh.factory<_i34.HabitInstanceBloc>(() => _i34.HabitInstanceBloc(
          gh<_i35.AddHabitInstanceUC>(),
          gh<_i35.ChangeHabitInstanceStatusUC>(),
          gh<_i35.UpdateHabitInstanceUC>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i36.RegisterModule {}
