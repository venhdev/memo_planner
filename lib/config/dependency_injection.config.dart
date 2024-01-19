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
import 'package:memo_planner/config/dependency_injection.dart' as _i27;
import 'package:memo_planner/core/service/firebase_cloud_messaging_service.dart'
    as _i12;
import 'package:memo_planner/core/service/local_notification_service.dart'
    as _i9;
import 'package:memo_planner/core/service/shared_preferences_service.dart'
    as _i11;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i13;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i22;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i21;
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart'
    as _i26;
import 'package:memo_planner/features/task/data/data_sources/firestore_task_data_source.dart'
    as _i14;
import 'package:memo_planner/features/task/data/repository/group_repository_impl.dart'
    as _i16;
import 'package:memo_planner/features/task/data/repository/task_list_repository_impl.dart'
    as _i18;
import 'package:memo_planner/features/task/data/repository/task_repository_impl.dart'
    as _i20;
import 'package:memo_planner/features/task/domain/repository/group_repository.dart'
    as _i15;
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart'
    as _i17;
import 'package:memo_planner/features/task/domain/repository/task_repository.dart'
    as _i19;
import 'package:memo_planner/features/task/domain/usecase/get_all_task_list_stream.dart'
    as _i23;
import 'package:memo_planner/features/task/domain/usecase/load_all_reminder.dart'
    as _i24;
import 'package:memo_planner/features/task/presentation/bloc/task_bloc.dart'
    as _i25;
import 'package:shared_preferences/shared_preferences.dart' as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
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
    gh.singleton<_i9.LocalNotificationService>(_i9.LocalNotificationService(
        gh<_i7.FlutterLocalNotificationsPlugin>()));
    await gh.factoryAsync<_i10.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i11.SharedPreferencesService>(
        _i11.SharedPreferencesServiceImpl(gh<_i10.SharedPreferences>()));
    gh.singleton<_i12.FirebaseCloudMessagingService>(
        _i12.FirebaseCloudMessagingService(gh<_i5.FirebaseMessaging>()));
    gh.singleton<_i13.AuthenticationDataSource>(
        _i13.AuthenticationDataSourceImpl(
      gh<_i3.FirebaseAuth>(),
      gh<_i8.GoogleSignIn>(),
      gh<_i4.FirebaseFirestore>(),
      gh<_i12.FirebaseCloudMessagingService>(),
      gh<_i6.FirebaseStorage>(),
    ));
    gh.singleton<_i14.FireStoreTaskDataSource>(_i14.FireStoreTaskDataSourceImpl(
      gh<_i4.FirebaseFirestore>(),
      gh<_i9.LocalNotificationService>(),
      gh<_i12.FirebaseCloudMessagingService>(),
    ));
    gh.singleton<_i15.GroupRepository>(
        _i16.GroupRepositoryImpl(gh<_i14.FireStoreTaskDataSource>()));
    gh.singleton<_i17.TaskListRepository>(_i18.TaskListRepositoryImpl(
      gh<_i14.FireStoreTaskDataSource>(),
      gh<_i13.AuthenticationDataSource>(),
    ));
    gh.singleton<_i19.TaskRepository>(
        _i20.TaskRepositoryImpl(gh<_i14.FireStoreTaskDataSource>()));
    gh.singleton<_i21.AuthRepository>(
        _i22.AuthenticationRepositoryImpl(gh<_i13.AuthenticationDataSource>()));
    gh.singleton<_i23.GetAllTaskListStreamOfUserUC>(
        _i23.GetAllTaskListStreamOfUserUC(gh<_i17.TaskListRepository>()));
    gh.singleton<_i24.LoadAllReminderUC>(_i24.LoadAllReminderUC(
      gh<_i19.TaskRepository>(),
      gh<_i17.TaskListRepository>(),
    ));
    gh.factory<_i25.TaskBloc>(() => _i25.TaskBloc(
          gh<_i19.TaskRepository>(),
          gh<_i17.TaskListRepository>(),
          gh<_i21.AuthRepository>(),
        ));
    gh.factory<_i26.AuthBloc>(() => _i26.AuthBloc(gh<_i21.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i27.RegisterModule {}
