import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'water id',
        'water name',
        icon: '@drawable/ic_notification', // Custom icon
        priority: Priority.max,
        importance: Importance.max,
        largeIcon: const DrawableResourceAndroidBitmap('@drawable/applogo'),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future init({bool isScheduled = false}) async {
    final android = AndroidInitializationSettings('@drawable/applogo');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(settings, onDidReceiveNotificationResponse: (payLoad) async {
      // onNotifications.add(payLoad);
    });

    if (isScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
    _initializeFirebaseMessaging();
  }

  /// Firebase Messaging Initialization
  static Future _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received');
      _showFirebaseNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked');
      _showFirebaseNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Background message received');
    _showFirebaseNotification(message);
  }

  /// Display Firebase Notification
  static void _showFirebaseNotification(RemoteMessage message) async {
    if (message.notification != null) {
      await _notifications.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        await _notificationDetails(),
        payload: message.data.toString(),
      );
    }
  }

  static Future<void> scheduleDailyNotifications() async {
    await _notifications.cancelAll();
    final times = [ 11, 14, 17, 20 ]; // Hours for 11 AM, 2 PM, 5 PM, 8 PM

    for (int i = 0; i < times.length; i++) {
      await Future.delayed(Duration(seconds: 1)).then((value) async{
        _notifications.zonedSchedule(
          i+6, // Ensure each notification has a unique ID
          '💧 Water 💧',
          "Do not forget to drink water",
          _scheduleDaily(TimeInterval(times[i], 00)), // Schedule at specified hours
          await NotificationDetails(
          android: AndroidNotificationDetails(
          'water',
          'water name',
            icon: '@drawable/ic_notification', // Custom icon
            priority: Priority.max,
          importance: Importance.max,
          largeIcon: const DrawableResourceAndroidBitmap('@drawable/applogo'),
        ),
        iOS: DarwinNotificationDetails(),
        ),
        payload: 'water_notification',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        );
      });
    }
  }


  static Future<void> showScheduledNotificationAtTime({
    // required int id,
    // required int time,
    String? payLoad,
  }) async {

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (DateTime.now().hour >= 11 && DateTime.now().hour <= 23) {
      for (int i = 0; i < 24; i += 1) {

        final tz.TZDateTime scheduledTime = now.add(Duration(hours: i));

        await flutterLocalNotificationsPlugin.zonedSchedule(

          scheduledTime.hour,
          ' 💧 Water 💧 ',
          "Do not forget to drink water",
          scheduledTime,
          await _notificationDetails(),
          payload: payLoad,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
}


    static tz.TZDateTime _scheduleDaily(TimeInterval time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }


  static Future showScheduledNotification({
    String? payLoad, //<< navigate content screen
    required int id,
    required DateTime scheduleDate,
    required int hour,
  }) async =>
      _notifications.zonedSchedule(
        id,
        ' 💧 Water 💧 ',
        "Do not forget to drink water",
        _scheduleWeekly(
            TimeInterval(
              hour,0
            ),
            days: [
              DateTime.saturday,
              DateTime.sunday,
              DateTime.monday,
              DateTime.tuesday,
              DateTime.wednesday,
              DateTime.thursday,
              DateTime.friday,
            ]),
        await _notificationDetails(),
        payload: payLoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  static tz.TZDateTime _scheduleWeekly(TimeInterval time, {required List<int> days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(time);
    while (!days.contains(scheduleDate.weekday)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    return scheduleDate.toLocal();
  }


}

class TimeInterval {
  final int hour;
  final int minute;

  TimeInterval(this.hour, this.minute);
}
