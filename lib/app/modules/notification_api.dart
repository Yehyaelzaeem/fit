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
        importance: Importance.max, ///<< to show in center of screen
        largeIcon: const DrawableResourceAndroidBitmap('@drawable/applogo'),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future init({bool isScheduled = false}) async {
    final android = AndroidInitializationSettings('@drawable/applogo');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    ///to open specific page
/*
    final notificationDetails =
        await _notifications.getNotificationAppLaunchDetails();
    if (notificationDetails != null &&
        notificationDetails.didNotificationLaunchApp) {
      onNotifications.add(notificationDetails.payload);
    }
await _notifications.initialize(settings,
        onSelectNotification: (payLoad) async {
      onNotifications.add(payLoad);
    });*/

    if (isScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int? id ,
    String? title,
    String? body,
  }) async =>
      _notifications.show(
        id!,
        title,
        body,
        await _notificationDetails(),
      );

  static Future showCustomScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
        0,
        'water 💧',
        "Do not forget to drink water 💧",
        _scheduleWeekly(TimeInterval(12,Duration.zero), days: [
          DateTime.saturday,
          DateTime.sunday,
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
        ]),
        //scheduled to 11 am morning
        await _notificationDetails(),
        payload: payLoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

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
              hour,
              Duration.zero
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


  static Future<void> scheduleDailyNotifications() async {
    // final List<int> notificationTimes = [
    //   19,
    //   21,
    //   11, // 11:00 AM
    //   14, // 2:00 PM
    //   17, // 5:00 PM
    //   20, // 8:00 PM
    // ];

    // for (int i = 0; i < notificationTimes.length; i++) {
    //   await showScheduledNotificationAtTime(
    //     id: i, // Ensure each notification has a unique ID
    //     time: notificationTimes[i],
    //   );
    // }
  }

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

        final tz.TZDateTime scheduledTime = now.add(Duration(minutes: i));

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




    // final tz.TZDateTime scheduledDate = await _nextInstanceOfTime(time);
    //
    // print('scheduledDate');
    // print(scheduledDate.toString());
    //
    // await _notifications.zonedSchedule(
    //   id,
    //   ' 💧 Water 💧 ',
    //   "Do not forget to drink water",
    //   scheduledDate,
    //   await _notificationDetails(),
    //   payload: payLoad,
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );
  }

  static tz.TZDateTime _nextInstanceOfTime(int time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time, 30, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static tz.TZDateTime _scheduleDaily(TimeInterval time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.value,
     //  time.minute,
     // time.second,
    );
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  static tz.TZDateTime _scheduleWeekly(TimeInterval time, {required List<int> days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(time);
    while (!days.contains(scheduleDate.weekday)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    print('scheduleDate.toUtc()');
    print(scheduleDate.toUtc());
    return scheduleDate.toLocal();
  }
}
