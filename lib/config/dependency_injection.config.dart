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
import 'package:memo_planner/config/dependency_injection.dart' as _i31;
import 'package:memo_planner/core/notification/firebase_cloud_messaging_manager.dart'
    as _i9;
import 'package:memo_planner/core/notification/local_notification_manager.dart'
    as _i8;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i10;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i19;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i18;
import 'package:memo_planner/features/authentication/domain/usecase/get_current_user.dart'
    as _i21;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_email_and_password.dart'
    as _i23;
import 'package:memo_planner/features/authentication/domain/usecase/sign_in_with_google.dart'
    as _i24;
import 'package:memo_planner/features/authentication/domain/usecase/sign_out.dart'
    as _i25;
import 'package:memo_planner/features/authentication/domain/usecase/sign_up_with_email.dart'
    as _i26;
import 'package:memo_planner/features/authentication/domain/usecase/update_display_name.dart'
    as _i28;
import 'package:memo_planner/features/authentication/domain/usecase/usecases.dart'
    as _i30;
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart'
    as _i29;
import 'package:memo_planner/features/task/data/data_sources/firestore_task_data_source.dart'
    as _i11;
import 'package:memo_planner/features/task/data/repository/group_repository_impl.dart'
    as _i13;
import 'package:memo_planner/features/task/data/repository/task_list_repository_impl.dart'
    as _i15;
import 'package:memo_planner/features/task/data/repository/task_repository_impl.dart'
    as _i17;
import 'package:memo_planner/features/task/domain/repository/group_repository.dart'
    as _i12;
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart'
    as _i14;
import 'package:memo_planner/features/task/domain/repository/task_repository.dart'
    as _i16;
import 'package:memo_planner/features/task/domain/usecase/get_all_task_list_stream.dart'
    as _i20;
import 'package:memo_planner/features/task/domain/usecase/load_all_reminder.dart'
    as _i22;
import 'package:memo_planner/features/task/presentation/bloc/task_bloc.dart'
    as _i27;

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
    gh.singleton<_i9.FirebaseCloudMessagingManager>(
        _i9.FirebaseCloudMessagingManager(gh<_i5.FirebaseMessaging>()));
    gh.singleton<_i10.AuthenticationDataSource>(
        _i10.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i7.GoogleSignIn>(),
      gh<_i4.FirebaseFirestore>(),
      gh<_i9.FirebaseCloudMessagingManager>(),
    ));
    gh.singleton<_i11.FireStoreTaskDataSource>(_i11.FireStoreTaskDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i8.LocalNotificationManager>(),
      gh<_i9.FirebaseCloudMessagingManager>(),
    ));
    gh.singleton<_i12.GroupRepository>(
        _i13.GroupRepositoryImpl(gh<_i11.FireStoreTaskDataSource>()));
    gh.singleton<_i14.TaskListRepository>(_i15.TaskListRepositoryImpl(
      gh<_i11.FireStoreTaskDataSource>(),
      gh<_i10.AuthenticationDataSource>(),
    ));
    gh.singleton<_i16.TaskRepository>(
        _i17.TaskRepositoryImpl(gh<_i11.FireStoreTaskDataSource>()));
    gh.singleton<_i18.AuthRepository>(
        _i19.AuthenticationRepositoryImpl(gh<_i10.AuthenticationDataSource>()));
    gh.singleton<_i20.GetAllTaskListStreamOfUserUC>(
        _i20.GetAllTaskListStreamOfUserUC(gh<_i14.TaskListRepository>()));
    gh.singleton<_i21.GetCurrentUserUC>(
        _i21.GetCurrentUserUC(gh<_i18.AuthRepository>()));
    gh.singleton<_i22.LoadAllReminderUC>(_i22.LoadAllReminderUC(
      gh<_i16.TaskRepository>(),
      gh<_i14.TaskListRepository>(),
    ));
    gh.singleton<_i23.SignInWithEmailAndPasswordUC>(
        _i23.SignInWithEmailAndPasswordUC(gh<_i18.AuthRepository>()));
    gh.singleton<_i24.SignInWithGoogleUC>(
        _i24.SignInWithGoogleUC(gh<_i18.AuthRepository>()));
    gh.singleton<_i25.SignOutUC>(_i25.SignOutUC(
      gh<_i18.AuthRepository>(),
      gh<_i8.LocalNotificationManager>(),
    ));
    gh.singleton<_i26.SignUpWithEmailUC>(
        _i26.SignUpWithEmailUC(gh<_i18.AuthRepository>()));
    gh.factory<_i27.TaskBloc>(() => _i27.TaskBloc(
          gh<_i20.GetAllTaskListStreamOfUserUC>(),
          gh<_i21.GetCurrentUserUC>(),
          gh<_i22.LoadAllReminderUC>(),
        ));
    gh.singleton<_i28.UpdateDisplayNameUC>(
        _i28.UpdateDisplayNameUC(gh<_i18.AuthRepository>()));
    gh.factory<_i29.AuthBloc>(() => _i29.AuthBloc(
          gh<_i30.SignInWithEmailAndPasswordUC>(),
          gh<_i30.SignOutUC>(),
          gh<_i30.SignInWithGoogleUC>(),
          gh<_i30.GetCurrentUserUC>(),
          gh<_i30.SignUpWithEmailUC>(),
          gh<_i28.UpdateDisplayNameUC>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i31.RegisterModule {}
