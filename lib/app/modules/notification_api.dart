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
        'channel id',
        'channel name',
        icon: '@drawable/applogo',
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
  }

  // static Future<void> scheduleDailyNotifications() async {
  //   final times = [11, 14, 17, 20]; // Hours for 11 AM, 2 PM, 5 PM, 8 PM
  //
  //   for (int i = 0; i < times.length; i++) {
  //     await _notifications.zonedSchedule(
  //       i, // Ensure each notification has a unique ID
  //       '💧 Water 💧',
  //       "Do not forget to drink water",
  //       _scheduleDaily(TimeInterval(times[i], 0)), // Schedule at specified hours
  //       await _notificationDetails(),
  //       payload: 'water_notification',
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //     );
  //   }
  // }


  static Future<void> showScheduledNotificationAtTime({
    // required int id,
    // required int time,
    String? payLoad,
  }) async {

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (DateTime.now().hour >= 11 && DateTime.now().hour <= 20) {
      for (int i = 0; i < 24; i += 3) {

        final tz.TZDateTime scheduledTime = now.add(Duration(hours: i));

        await flutterLocalNotificationsPlugin.zonedSchedule(

          DateTime.now().hour + DateTime.now().minute + DateTime.now().second,
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
}

class TimeInterval {
  final int hour;
  final int minute;

  TimeInterval(this.hour, this.minute);
}
