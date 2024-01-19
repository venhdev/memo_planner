import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../features/task/domain/entities/task_entity.dart';
import '../constants/constants.dart';

// <https://pub.dev/packages/flutter_local_notifications>
@singleton
class LocalNotificationService {
  LocalNotificationService(this._flutterLocalNotificationsPlugin);

  // get instance of flutter_local_notifications
  FlutterLocalNotificationsPlugin get I => _flutterLocalNotificationsPlugin;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> init() async {
    InitializationSettings initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      // iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  /// Default Notification Details >> single notification
  static const NotificationDetails defaultNotificationDetails = NotificationDetails(
    // androidPlatformChannelSpecifics
    android: AndroidNotificationDetails(
      kDefaultNotificationChannelId,
      'Notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    ),
  );

  /// Schedule Notification Details >> schedule notification
  static const NotificationDetails scheduleNotificationDetails = NotificationDetails(
    // androidPlatformChannelSpecifics
    android: AndroidNotificationDetails(
      kScheduleNotificationChannelId,
      'Schedule Notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    ),
  );

  /// Daily Notification Details >> daily notification
  static const NotificationDetails dailyNotificationDetails = NotificationDetails(
    // androidPlatformChannelSpecifics
    android: AndroidNotificationDetails(
      kDailyNotificationChannelId,
      'Daily Notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    ),
  );

  // Display a default notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin
        .show(
          id,
          title,
          body,
          defaultNotificationDetails,
          payload: payload,
        )
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  /// Display a notification with a fixed date and time in the future
  Future<void> setScheduleNotificationFromTask(
    TaskEntity task,
  ) async {
    if (task.reminders!.useDefault == false) return;

    await _flutterLocalNotificationsPlugin
        .zonedSchedule(
          task.reminders!.rid!,
          task.taskName!,
          kDefaultReminderBody,
          tz.TZDateTime.from(task.reminders!.scheduledTime!, tz.local),
          scheduleNotificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        )
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
    // matchDateTimeComponents: DateTimeComponents.__, >> will recurring if set
  }

  /// Display a notification with a fixed date and time in the future
  Future<void> setScheduleNotification({
    required int id,
    required String? title,
    String? body,
    String? payload,
    required DateTime scheduledTime,
  }) async {
    await _flutterLocalNotificationsPlugin
        .zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledTime, tz.local),
          scheduleNotificationDetails,
          payload: payload,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        )
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
    // matchDateTimeComponents: DateTimeComponents.__, >> will recurring if set
  }

  /// Display a notification with a daily schedule
  Future<void> setDailyScheduleNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    await _flutterLocalNotificationsPlugin
        .zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          dailyNotificationDetails,
          payload: payload,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // use to match time to trigger notification daily
        )
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}

// > Retrieving pending notification requests
// <https://pub.dev/packages/flutter_local_notifications#retrieving-pending-notification-requests>
// Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
//   return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
// }
// > Retrieving active notifications #
// <https://pub.dev/packages/flutter_local_notifications#retrieving-active-notifications>
// Future<List<ActiveNotification>> activeNotifications() async {
//   return await _flutterLocalNotificationsPlugin.getActiveNotifications();
// }