// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:memo_planner/config/dependency_injection.dart' as _i890;
import 'package:memo_planner/core/service/firebase_cloud_messaging_service.dart'
    as _i1025;
import 'package:memo_planner/core/service/local_notification_service.dart'
    as _i311;
import 'package:memo_planner/core/service/shared_preferences_service.dart'
    as _i751;
import 'package:memo_planner/features/authentication/data/data_sources/authentication_data_source.dart'
    as _i436;
import 'package:memo_planner/features/authentication/data/repository/authentication_repository_impl.dart'
    as _i530;
import 'package:memo_planner/features/authentication/domain/repository/authentication_repository.dart'
    as _i1044;
import 'package:memo_planner/features/authentication/presentation/bloc/authentication/authentication_bloc.dart'
    as _i239;
import 'package:memo_planner/features/task/data/data_sources/firestore_task_data_source.dart'
    as _i902;
import 'package:memo_planner/features/task/data/repository/group_repository_impl.dart'
    as _i481;
import 'package:memo_planner/features/task/data/repository/task_list_repository_impl.dart'
    as _i680;
import 'package:memo_planner/features/task/data/repository/task_repository_impl.dart'
    as _i983;
import 'package:memo_planner/features/task/domain/repository/group_repository.dart'
    as _i100;
import 'package:memo_planner/features/task/domain/repository/task_list_repository.dart'
    as _i364;
import 'package:memo_planner/features/task/domain/repository/task_repository.dart'
    as _i103;
import 'package:memo_planner/features/task/domain/usecase/get_all_task_list_stream.dart'
    as _i402;
import 'package:memo_planner/features/task/domain/usecase/load_all_reminder.dart'
    as _i860;
import 'package:memo_planner/features/task/presentation/bloc/task_bloc.dart'
    as _i594;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.singleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.singleton<_i163.FlutterLocalNotificationsPlugin>(
        () => registerModule.flutterLocalNotificationsPlugin);
    gh.singleton<_i892.FirebaseMessaging>(
        () => registerModule.firebaseMessaging);
    gh.singleton<_i457.FirebaseStorage>(() => registerModule.storage);
    gh.singleton<_i311.LocalNotificationService>(() =>
        _i311.LocalNotificationService(
            gh<_i163.FlutterLocalNotificationsPlugin>()));
    gh.singleton<_i751.SharedPreferencesService>(() =>
        _i751.SharedPreferencesServiceImpl(gh<_i460.SharedPreferences>()));
    gh.singleton<_i1025.FirebaseCloudMessagingService>(() =>
        _i1025.FirebaseCloudMessagingService(gh<_i892.FirebaseMessaging>()));
    gh.singleton<_i436.AuthenticationDataSource>(
        () => _i436.AuthenticationDataSourceImpl(
              gh<_i59.FirebaseAuth>(),
              gh<_i116.GoogleSignIn>(),
              gh<_i974.FirebaseFirestore>(),
              gh<_i1025.FirebaseCloudMessagingService>(),
              gh<_i457.FirebaseStorage>(),
            ));
    gh.singleton<_i902.FireStoreTaskDataSource>(
        () => _i902.FireStoreTaskDataSourceImpl(
              gh<_i974.FirebaseFirestore>(),
              gh<_i311.LocalNotificationService>(),
              gh<_i1025.FirebaseCloudMessagingService>(),
            ));
    gh.singleton<_i364.TaskListRepository>(() => _i680.TaskListRepositoryImpl(
          gh<_i902.FireStoreTaskDataSource>(),
          gh<_i436.AuthenticationDataSource>(),
        ));
    gh.singleton<_i1044.AuthRepository>(() =>
        _i530.AuthenticationRepositoryImpl(
            gh<_i436.AuthenticationDataSource>()));
    gh.factory<_i239.AuthBloc>(
        () => _i239.AuthBloc(gh<_i1044.AuthRepository>()));
    gh.singleton<_i100.GroupRepository>(
        () => _i481.GroupRepositoryImpl(gh<_i902.FireStoreTaskDataSource>()));
    gh.singleton<_i103.TaskRepository>(
        () => _i983.TaskRepositoryImpl(gh<_i902.FireStoreTaskDataSource>()));
    gh.singleton<_i402.GetAllTaskListStreamOfUserUC>(() =>
        _i402.GetAllTaskListStreamOfUserUC(gh<_i364.TaskListRepository>()));
    gh.factory<_i594.TaskBloc>(() => _i594.TaskBloc(
          gh<_i103.TaskRepository>(),
          gh<_i364.TaskListRepository>(),
          gh<_i1044.AuthRepository>(),
        ));
    gh.singleton<_i860.LoadAllReminderUC>(() => _i860.LoadAllReminderUC(
          gh<_i103.TaskRepository>(),
          gh<_i364.TaskListRepository>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i890.RegisterModule {}
