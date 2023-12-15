// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:firebase_messaging/firebase_messaging.dart' as _i5;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i7;
import 'package:injectable/injectable.dart' as _i2;
import 'package:memo_planner/config/dependency_injection.dart' as _i49;
import 'package:memo_planner/core/notification/local_notification_manager.dart'
    as _i8;
import 'package:memo_planner/core/notification/messaging_manager.dart' as _i9;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i10;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i12;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i11;
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart'
    as _i14;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i23;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_google.dart'
    as _i24;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i25;
import 'package:memo_planner/features/authentication/domain/usecase/sign_up_with_email.dart'
    as _i26;
import 'package:memo_planner/features/authentication/domain/usecase/usecases.dart'
    as _i36;
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart'
    as _i35;
import 'package:memo_planner/features/habit/data/data_sources/habit_data_source.dart'
    as _i17;
import 'package:memo_planner/features/habit/data/data_sources/habit_instance_data_source.dart'
    as _i18;
import 'package:memo_planner/features/habit/data/repository/habit_instance_repository_impl.dart'
    as _i20;
import 'package:memo_planner/features/habit/data/repository/habit_repository_impl.dart'
    as _i22;
import 'package:memo_planner/features/habit/domain/repository/habit_instance_repository.dart'
    as _i19;
import 'package:memo_planner/features/habit/domain/repository/habit_repository.dart'
    as _i21;
import 'package:memo_planner/features/habit/domain/usecase/add_habit.dart'
    as _i34;
import 'package:memo_planner/features/habit/domain/usecase/add_habit_instance.dart'
    as _i33;
import 'package:memo_planner/features/habit/domain/usecase/change_habit_instance_status.dart'
    as _i37;
import 'package:memo_planner/features/habit/domain/usecase/delete_habit.dart'
    as _i38;
import 'package:memo_planner/features/habit/domain/usecase/get_create_habit_instance_by_iid.dart'
    as _i40;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_by_hid.dart'
    as _i41;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_instance_stream.dart'
    as _i42;
import 'package:memo_planner/features/habit/domain/usecase/get_habit_stream.dart'
    as _i43;
import 'package:memo_planner/features/habit/domain/usecase/get_top_streak.dart'
    as _i44;
import 'package:memo_planner/features/habit/domain/usecase/update_habit.dart'
    as _i32;
import 'package:memo_planner/features/habit/domain/usecase/update_habit_instance.dart'
    as _i31;
import 'package:memo_planner/features/habit/domain/usecase/usecases.dart'
    as _i47;
import 'package:memo_planner/features/habit/presentation/bloc/habit/habit_bloc.dart'
    as _i45;
import 'package:memo_planner/features/habit/presentation/bloc/instance/instance_bloc.dart'
    as _i46;
import 'package:memo_planner/features/task/data/data_sources/firestore_task_data_source.dart'
    as _i13;
import 'package:memo_planner/features/task/data/repository/group_repository_impl.dart'
    as _i16;
import 'package:memo_planner/features/task/data/repository/task_list_repository_impl.dart'
    as _i28;
import 'package:memo_planner/features/task/data/repository/task_repository_impl.dart'
    as _i30;
import 'package:memo_planner/features/task/domain/repository/group_repository.dart'
    as _i15;
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart'
    as _i27;
import 'package:memo_planner/features/task/domain/repository/task_repository.dart'
    as _i29;
import 'package:memo_planner/features/task/domain/usecase/get_all_task_stream.dart'
    as _i39;
import 'package:memo_planner/features/task/presentation/bloc/task_bloc.dart'
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
    gh.singleton<_i5.FirebaseMessaging>(registerModule.firebaseMessaging);
    gh.singleton<_i6.FlutterLocalNotificationsPlugin>(
        registerModule.flutterLocalNotificationsPlugin);
    gh.singleton<_i7.GoogleSignIn>(registerModule.googleSignIn);
    gh.singleton<_i8.LocalNotificationManager>(_i8.LocalNotificationManager(
        gh<_i6.FlutterLocalNotificationsPlugin>()));
    gh.singleton<_i9.MessagingManager>(
        _i9.MessagingManager(gh<_i5.FirebaseMessaging>()));
    gh.singleton<_i10.AuthenticationDataSource>(
        _i10.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i7.GoogleSignIn>(),
      gh<_i4.FirebaseFirestore>(),
      gh<_i9.MessagingManager>(),
    ));
    gh.singleton<_i11.AuthenticationRepository>(
        _i12.AuthenticationRepositoryImpl(gh<_i10.AuthenticationDataSource>()));
    gh.singleton<_i13.FireStoreTaskDataSource>(
        _i13.FireStoreTaskDataSourceImpl(gh<_i4.FirebaseFirestore>()));
    gh.singleton<_i14.GetCurrentUserUC>(
        _i14.GetCurrentUserUC(gh<_i11.AuthenticationRepository>()));
    gh.singleton<_i15.GroupRepository>(
        _i16.GroupRepositoryImpl(gh<_i13.FireStoreTaskDataSource>()));
    gh.singleton<_i17.HabitDataSource>(_i17.HabitDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i8.LocalNotificationManager>(),
    ));
    gh.singleton<_i18.HabitInstanceDataSource>(_i18.HabitInstanceDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i10.AuthenticationDataSource>(),
    ));
    gh.singleton<_i19.HabitInstanceRepository>(
        _i20.HabitInstanceRepositoryImpl(gh<_i18.HabitInstanceDataSource>()));
    gh.singleton<_i21.HabitRepository>(
        _i22.HabitRepositoryImpl(gh<_i17.HabitDataSource>()));
    gh.singleton<_i23.SignInWithEmailAndPasswordUC>(
        _i23.SignInWithEmailAndPasswordUC(gh<_i11.AuthenticationRepository>()));
    gh.singleton<_i24.SignInWithGoogleUC>(
        _i24.SignInWithGoogleUC(gh<_i11.AuthenticationRepository>()));
    gh.singleton<_i25.SignOutUC>(
        _i25.SignOutUC(gh<_i11.AuthenticationRepository>()));
    gh.singleton<_i26.SignUpWithEmailUC>(
        _i26.SignUpWithEmailUC(gh<_i11.AuthenticationRepository>()));
    gh.singleton<_i27.TaskListRepository>(
        _i28.TaskListRepositoryImpl(gh<_i13.FireStoreTaskDataSource>()));
    gh.singleton<_i29.TaskRepository>(
        _i30.TaskRepositoryImpl(gh<_i13.FireStoreTaskDataSource>()));
    gh.singleton<_i31.UpdateHabitInstanceUC>(
        _i31.UpdateHabitInstanceUC(gh<_i19.HabitInstanceRepository>()));
    gh.singleton<_i32.UpdateHabitUC>(
        _i32.UpdateHabitUC(gh<_i21.HabitRepository>()));
    gh.singleton<_i33.AddHabitInstanceUC>(
        _i33.AddHabitInstanceUC(gh<_i19.HabitInstanceRepository>()));
    gh.singleton<_i34.AddHabitUC>(_i34.AddHabitUC(gh<_i21.HabitRepository>()));
    gh.factory<_i35.AuthenticationBloc>(() => _i35.AuthenticationBloc(
          gh<_i36.SignInWithEmailAndPasswordUC>(),
          gh<_i36.SignOutUC>(),
          gh<_i36.SignInWithGoogleUC>(),
          gh<_i36.GetCurrentUserUC>(),
          gh<_i36.SignUpWithEmailUC>(),
        ));
    gh.singleton<_i37.ChangeHabitInstanceStatusUC>(
        _i37.ChangeHabitInstanceStatusUC(gh<_i19.HabitInstanceRepository>()));
    gh.singleton<_i38.DeleteHabitUC>(
        _i38.DeleteHabitUC(gh<_i21.HabitRepository>()));
    gh.singleton<_i39.GetAllTaskStreamOfUserUC>(
        _i39.GetAllTaskStreamOfUserUC(gh<_i27.TaskListRepository>()));
    gh.singleton<_i40.GetCreateHabitInstanceByIid>(
        _i40.GetCreateHabitInstanceByIid(
      gh<_i19.HabitInstanceRepository>(),
      gh<_i21.HabitRepository>(),
    ));
    gh.singleton<_i41.GetHabitByHidUC>(
        _i41.GetHabitByHidUC(gh<_i21.HabitRepository>()));
    gh.singleton<_i42.GetHabitInstanceStreamUC>(
        _i42.GetHabitInstanceStreamUC(gh<_i19.HabitInstanceRepository>()));
    gh.singleton<_i43.GetHabitStreamUC>(
        _i43.GetHabitStreamUC(gh<_i21.HabitRepository>()));
    gh.singleton<_i44.GetTopStreakUC>(
        _i44.GetTopStreakUC(gh<_i21.HabitRepository>()));
    gh.factory<_i45.HabitBloc>(() => _i45.HabitBloc(
          gh<_i34.AddHabitUC>(),
          gh<_i32.UpdateHabitUC>(),
          gh<_i38.DeleteHabitUC>(),
          gh<_i14.GetCurrentUserUC>(),
          gh<_i43.GetHabitStreamUC>(),
          gh<_i33.AddHabitInstanceUC>(),
        ));
    gh.factory<_i46.HabitInstanceBloc>(() => _i46.HabitInstanceBloc(
          gh<_i47.AddHabitInstanceUC>(),
          gh<_i47.ChangeHabitInstanceStatusUC>(),
          gh<_i47.UpdateHabitInstanceUC>(),
        ));
    gh.factory<_i48.TaskBloc>(() => _i48.TaskBloc(
          gh<_i39.GetAllTaskStreamOfUserUC>(),
          gh<_i14.GetCurrentUserUC>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i49.RegisterModule {}
