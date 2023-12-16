import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

import '../constants/constants.dart';

// <https://pub.dev/packages/flutter_local_notifications>
@singleton
class LocalNotificationManager {
  LocalNotificationManager(this._flutterLocalNotificationsPlugin);

  // get instance of flutter_local_notifications
  FlutterLocalNotificationsPlugin get I => _flutterLocalNotificationsPlugin;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static InitializationSettings initializationSettings = const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/launcher_icon'),
    // iOS: DarwinInitializationSettings(),
  );

  Future<void> init() async {
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      defaultNotificationDetails,
      payload: payload,
    );
  }

  /// Display a notification with a fixed date and time in the future
  Future<void> setScheduleNotification({
    required int id,
    required String? title,
    String? body,
    String? payload,
    required DateTime scheduledTime,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      scheduleNotificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    //! matchDateTimeComponents: DateTimeComponents.time, >> not recurring
  }

  /// Display a notification with a daily schedule
  Future<void> setDailyScheduleNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      dailyNotificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // use to match time to trigger notification daily
    );
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
}
