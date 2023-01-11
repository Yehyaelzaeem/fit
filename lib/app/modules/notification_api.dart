import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'channel id', 'channel name', 'channel description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool isScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings,
        onSelectNotification: (payLoad) async {
      onNotifications.add(payLoad);
    });

    if(isScheduled){
   //   tz.initializeTimeZonse();
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payLoad,
      );

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly(Time(8), days: [
          DateTime.monday,
          DateTime.thursday,
        ]),
        //scheduled to 8 am morning
        await _notificationDetails(),
        payload: payLoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(time);
    while (!days.contains(scheduleDate.weekday)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    return scheduleDate;
  }
}
