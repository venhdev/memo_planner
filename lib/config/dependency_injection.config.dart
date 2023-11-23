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
import 'package:memo_planner/config/dependency_injection.dart' as _i53;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i14;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i16;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i15;
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart'
    as _i19;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i28;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_google.dart'
    as _i29;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i30;
import 'package:memo_planner/features/authentication/domain/usecase/sign_up_with_email.dart'
    as _i31;
import 'package:memo_planner/features/authentication/domain/usecase/usecases.dart'
    as _i39;
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart'
    as _i38;
import 'package:memo_planner/features/goal/data/data_sources/target_data_source.dart'
    as _i6;
import 'package:memo_planner/features/goal/data/data_sources/task_data_source.dart'
    as _i9;
import 'package:memo_planner/features/goal/data/repository/target_repository_impl.dart'
    as _i8;
import 'package:memo_planner/features/goal/data/repository/task_repository_impl.dart'
    as _i11;
import 'package:memo_planner/features/goal/domain/repository/target_repository.dart'
    as _i7;
import 'package:memo_planner/features/goal/domain/repository/task_repository.dart'
    as _i10;
import 'package:memo_planner/features/goal/domain/usecase/add_target.dart'
    as _i36;
import 'package:memo_planner/features/goal/domain/usecase/add_task.dart'
    as _i37;
import 'package:memo_planner/features/goal/domain/usecase/delete_target.dart'
    as _i17;
import 'package:memo_planner/features/goal/domain/usecase/delete_task.dart'
    as _i18;
import 'package:memo_planner/features/goal/domain/usecase/get_target_stream.dart'
    as _i20;
import 'package:memo_planner/features/goal/domain/usecase/get_task_stream.dart'
    as _i21;
import 'package:memo_planner/features/goal/domain/usecase/update_target.dart'
    as _i12;
import 'package:memo_planner/features/goal/domain/usecase/update_task.dart'
    as _i13;
import 'package:memo_planner/features/goal/domain/usecase/usecases.dart'
    as _i51;
import 'package:memo_planner/features/goal/presentation/bloc/target/target_bloc.dart'
    as _i50;
import 'package:memo_planner/features/goal/presentation/bloc/task/task_bloc.dart'
    as _i52;
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart'
    as _i22;
import 'package:memo_planner/features/habit/data/data_sources/habit_instance_data_source.dart'
    as _i23;
import 'package:memo_planner/features/habit/data/repository/habit_instance_repository_impl.dart'
    as _i25;
import 'package:memo_planner/features/habit/data/repository/habit_repository_impl.dart'
    as _i27;
import 'package:memo_planner/features/habit/domain/repository/habit_instance_repository.dart'
    as _i24;
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart'
    as _i26;
import 'package:memo_planner/features/habit/domain/usecase/add_habit.dart'
    as _i35;
import 'package:memo_planner/features/habit/domain/usecase/add_habit_instance.dart'
    as _i34;
import 'package:memo_planner/features/habit/domain/usecase/change_habit_instance_status.dart'
    as _i40;
import 'package:memo_planner/features/habit/domain/usecase/delete_habit.dart'
    as _i41;
import 'package:memo_planner/features/habit/domain/usecase/get_create_habit_instance_by_iid.dart'
    as _i42;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_by_hid.dart'
    as _i43;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_instance_stream.dart'
    as _i44;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_stream.dart'
    as _i45;
import 'package:memo_planner/features/habit/domain/usecase/get_top_streak.dart'
    as _i46;
import 'package:memo_planner/features/habit/domain/usecase/update_habit.dart'
    as _i33;
import 'package:memo_planner/features/habit/domain/usecase/update_habit_instance.dart'
    as _i32;
import 'package:memo_planner/features/habit/domain/usecase/usecases.dart'
    as _i49;
import 'package:memo_planner/features/habit/presentation/bloc/habit/habit_bloc.dart'
    as _i47;
import 'package:memo_planner/features/habit/presentation/bloc/instance/instance_bloc.dart'
    as _i48;

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
    gh.singleton<_i6.TargetDataSource>(
        _i6.TargetDataSourceImpl(gh<_i4.FirebaseFirestore>()));
    gh.singleton<_i7.TargetRepository>(
        _i8.TargetRepositoryImpl(gh<_i6.TargetDataSource>()));
    gh.singleton<_i9.TaskDataSource>(
        _i9.TaskDataSourceImpl(gh<_i4.FirebaseFirestore>()));
    gh.singleton<_i10.TaskRepository>(
        _i11.TaskRepositoryImpl(gh<_i9.TaskDataSource>()));
    gh.singleton<_i12.UpdateTargetUC>(
        _i12.UpdateTargetUC(gh<_i7.TargetRepository>()));
    gh.singleton<_i13.UpdateTaskUC>(
        _i13.UpdateTaskUC(gh<_i10.TaskRepository>()));
    gh.singleton<_i14.AuthenticationDataSource>(
        _i14.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i5.GoogleSignIn>(),
    ));
    gh.singleton<_i15.AuthenticationRepository>(
        _i16.AuthenticationRepositoryImpl(gh<_i14.AuthenticationDataSource>()));
    gh.singleton<_i17.DeleteTargetUC>(
        _i17.DeleteTargetUC(gh<_i7.TargetRepository>()));
    gh.singleton<_i18.DeleteTaskUC>(
        _i18.DeleteTaskUC(gh<_i10.TaskRepository>()));
    gh.singleton<_i19.GetCurrentUserUC>(
        _i19.GetCurrentUserUC(gh<_i15.AuthenticationRepository>()));
    gh.singleton<_i20.GetTargetStreamUC>(
        _i20.GetTargetStreamUC(gh<_i7.TargetRepository>()));
    gh.singleton<_i21.GetTaskStreamUC>(
        _i21.GetTaskStreamUC(gh<_i10.TaskRepository>()));
    gh.singleton<_i22.HabitDataSource>(_i22.HabitDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i14.AuthenticationDataSource>(),
    ));
    gh.singleton<_i23.HabitInstanceDataSource>(_i23.HabitInstanceDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i14.AuthenticationDataSource>(),
    ));
    gh.singleton<_i24.HabitInstanceRepository>(
        _i25.HabitInstanceRepositoryImpl(gh<_i23.HabitInstanceDataSource>()));
    gh.singleton<_i26.HabitRepository>(
        _i27.HabitRepositoryImpl(gh<_i22.HabitDataSource>()));
    gh.singleton<_i28.SignInWithEmailAndPasswordUC>(
        _i28.SignInWithEmailAndPasswordUC(gh<_i15.AuthenticationRepository>()));
    gh.singleton<_i29.SignInWithGoogleUC>(
        _i29.SignInWithGoogleUC(gh<_i15.AuthenticationRepository>()));
    gh.singleton<_i30.SignOutUC>(
        _i30.SignOutUC(gh<_i15.AuthenticationRepository>()));
    gh.singleton<_i31.SignUpWithEmailUC>(
        _i31.SignUpWithEmailUC(gh<_i15.AuthenticationRepository>()));
    gh.singleton<_i32.UpdateHabitInstanceUC>(
        _i32.UpdateHabitInstanceUC(gh<_i24.HabitInstanceRepository>()));
    gh.singleton<_i33.UpdateHabitUC>(
        _i33.UpdateHabitUC(gh<_i26.HabitRepository>()));
    gh.singleton<_i34.AddHabitInstanceUC>(
        _i34.AddHabitInstanceUC(gh<_i24.HabitInstanceRepository>()));
    gh.singleton<_i35.AddHabitUC>(_i35.AddHabitUC(gh<_i26.HabitRepository>()));
    gh.singleton<_i36.AddTargetUC>(_i36.AddTargetUC(
      gh<_i7.TargetRepository>(),
      gh<_i15.AuthenticationRepository>(),
    ));
    gh.singleton<_i37.AddTaskUC>(_i37.AddTaskUC(
      gh<_i10.TaskRepository>(),
      gh<_i15.AuthenticationRepository>(),
    ));
    gh.factory<_i38.AuthenticationBloc>(() => _i38.AuthenticationBloc(
          gh<_i39.SignInWithEmailAndPasswordUC>(),
          gh<_i39.SignOutUC>(),
          gh<_i39.SignInWithGoogleUC>(),
          gh<_i39.GetCurrentUserUC>(),
          gh<_i39.SignUpWithEmailUC>(),
        ));
    gh.singleton<_i40.ChangeHabitInstanceStatusUC>(
        _i40.ChangeHabitInstanceStatusUC(gh<_i24.HabitInstanceRepository>()));
    gh.singleton<_i41.DeleteHabitUC>(
        _i41.DeleteHabitUC(gh<_i26.HabitRepository>()));
    gh.singleton<_i42.GetCreateHabitInstanceByIid>(
        _i42.GetCreateHabitInstanceByIid(
      gh<_i24.HabitInstanceRepository>(),
      gh<_i26.HabitRepository>(),
    ));
    gh.singleton<_i43.GetHabitByHidUC>(
        _i43.GetHabitByHidUC(gh<_i26.HabitRepository>()));
    gh.singleton<_i44.GetHabitInstanceStreamUC>(
        _i44.GetHabitInstanceStreamUC(gh<_i24.HabitInstanceRepository>()));
    gh.singleton<_i45.GetHabitStreamUC>(
        _i45.GetHabitStreamUC(gh<_i26.HabitRepository>()));
    gh.singleton<_i46.GetTopStreakUC>(
        _i46.GetTopStreakUC(gh<_i26.HabitRepository>()));
    gh.factory<_i47.HabitBloc>(() => _i47.HabitBloc(
          gh<_i35.AddHabitUC>(),
          gh<_i33.UpdateHabitUC>(),
          gh<_i41.DeleteHabitUC>(),
          gh<_i19.GetCurrentUserUC>(),
          gh<_i45.GetHabitStreamUC>(),
          gh<_i34.AddHabitInstanceUC>(),
        ));
    gh.factory<_i48.HabitInstanceBloc>(() => _i48.HabitInstanceBloc(
          gh<_i49.AddHabitInstanceUC>(),
          gh<_i49.ChangeHabitInstanceStatusUC>(),
          gh<_i49.UpdateHabitInstanceUC>(),
        ));
    gh.factory<_i50.TargetBloc>(() => _i50.TargetBloc(
          gh<_i19.GetCurrentUserUC>(),
          gh<_i51.GetTargetStreamUC>(),
          gh<_i51.AddTargetUC>(),
          gh<_i51.UpdateTargetUC>(),
          gh<_i51.DeleteTargetUC>(),
        ));
    gh.factory<_i52.TaskBloc>(() => _i52.TaskBloc(
          gh<_i51.GetTaskStreamUC>(),
          gh<_i51.AddTaskUC>(),
          gh<_i51.UpdateTaskUC>(),
          gh<_i51.DeleteTaskUC>(),
          gh<_i19.GetCurrentUserUC>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i53.RegisterModule {}
