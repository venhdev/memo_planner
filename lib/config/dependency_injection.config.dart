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
import 'package:firebase_storage/firebase_storage.dart' as _i6;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i8;
import 'package:injectable/injectable.dart' as _i2;
import 'package:memo_planner/config/dependency_injection.dart' as _i25;
import 'package:memo_planner/core/notification/firebase_cloud_messaging_manager.dart'
    as _i10;
import 'package:memo_planner/core/notification/local_notification_manager.dart'
    as _i9;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i11;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i20;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i19;
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart'
    as _i24;
import 'package:memo_planner/features/task/data/data_sources/firestore_task_data_source.dart'
    as _i12;
import 'package:memo_planner/features/task/data/repository/group_repository_impl.dart'
    as _i14;
import 'package:memo_planner/features/task/data/repository/task_list_repository_impl.dart'
    as _i16;
import 'package:memo_planner/features/task/data/repository/task_repository_impl.dart'
    as _i18;
import 'package:memo_planner/features/task/domain/repository/group_repository.dart'
    as _i13;
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart'
    as _i15;
import 'package:memo_planner/features/task/domain/repository/task_repository.dart'
    as _i17;
import 'package:memo_planner/features/task/domain/usecase/get_all_task_list_stream.dart'
    as _i21;
import 'package:memo_planner/features/task/domain/usecase/load_all_reminder.dart'
    as _i22;
import 'package:memo_planner/features/task/presentation/bloc/task_bloc.dart'
    as _i23;

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
    gh.singleton<_i6.FirebaseStorage>(registerModule.storage);
    gh.singleton<_i7.FlutterLocalNotificationsPlugin>(
        registerModule.flutterLocalNotificationsPlugin);
    gh.singleton<_i8.GoogleSignIn>(registerModule.googleSignIn);
    gh.singleton<_i9.LocalNotificationManager>(_i9.LocalNotificationManager(
        gh<_i7.FlutterLocalNotificationsPlugin>()));
    gh.singleton<_i10.FirebaseCloudMessagingManager>(
        _i10.FirebaseCloudMessagingManager(gh<_i5.FirebaseMessaging>()));
    gh.singleton<_i11.AuthenticationDataSource>(
        _i11.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i8.GoogleSignIn>(),
      gh<_i4.FirebaseFirestore>(),
      gh<_i10.FirebaseCloudMessagingManager>(),
      gh<_i6.FirebaseStorage>(),
    ));
    gh.singleton<_i12.FireStoreTaskDataSource>(_i12.FireStoreTaskDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i9.LocalNotificationManager>(),
      gh<_i10.FirebaseCloudMessagingManager>(),
    ));
    gh.singleton<_i13.GroupRepository>(
        _i14.GroupRepositoryImpl(gh<_i12.FireStoreTaskDataSource>()));
    gh.singleton<_i15.TaskListRepository>(_i16.TaskListRepositoryImpl(
      gh<_i12.FireStoreTaskDataSource>(),
      gh<_i11.AuthenticationDataSource>(),
    ));
    gh.singleton<_i17.TaskRepository>(
        _i18.TaskRepositoryImpl(gh<_i12.FireStoreTaskDataSource>()));
    gh.singleton<_i19.AuthRepository>(
        _i20.AuthenticationRepositoryImpl(gh<_i11.AuthenticationDataSource>()));
    gh.singleton<_i21.GetAllTaskListStreamOfUserUC>(
        _i21.GetAllTaskListStreamOfUserUC(gh<_i15.TaskListRepository>()));
    gh.singleton<_i22.LoadAllReminderUC>(_i22.LoadAllReminderUC(
      gh<_i17.TaskRepository>(),
      gh<_i15.TaskListRepository>(),
    ));
    gh.factory<_i23.TaskBloc>(() => _i23.TaskBloc(
          gh<_i17.TaskRepository>(),
          gh<_i15.TaskListRepository>(),
          gh<_i19.AuthRepository>(),
        ));
    gh.factory<_i24.AuthBloc>(() => _i24.AuthBloc(gh<_i19.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i25.RegisterModule {}
