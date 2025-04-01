import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todolist/utils/constants.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $fCMToken');
    }

    tz.initializeTimeZones();

    await _initializeLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(
        message.notification?.title ?? '',
        message.notification?.body ?? '',
      );
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      kChannelId,
      kChannelName,
      importance: kChannelImportance,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  AndroidNotificationDetails _createAndroidNotificationDetails() =>
      const AndroidNotificationDetails(
        kChannelId,
        kChannelName,
        importance: kChannelImportance,
        priority: Priority.high,
      );

  NotificationDetails _createNotificationDetails() => NotificationDetails(
        android: _createAndroidNotificationDetails(),
      );

  bool _isScheduledDateValid(DateTime scheduledDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime tzScheduledDate =
        tz.TZDateTime.from(scheduledDate, tz.local);
    return tzScheduledDate.isAfter(now);
  }

  Future<void> _showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      _createNotificationDetails(),
    );
  }

  Future<void> scheduleNotification(
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    if (kDebugMode) {
      print("Scheduling notification...");
      print("Title: $title");
      print("Body: $body");
      print("Scheduled Date: $scheduledDate");
    }

    if (!_isScheduledDateValid(scheduledDate)) {
      if (kDebugMode) {
        print("Scheduled time must be in the future.");
      }
      return;
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        _createNotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      if (kDebugMode) {
        print("Notification scheduled successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error scheduling notification: $e");
      }
    }
  }

  Future<void> scheduleTaskReminder(
    String title,
    String date,
    String time,
  ) async {
    final DateFormat dateFormat = DateFormat(notiDateTimeFormat);
    final DateTime scheduledDate = dateFormat.parse('$date $time');

    await scheduleNotification(
      title,
      "It's time to do: $title",
      scheduledDate,
    );
  }
}
