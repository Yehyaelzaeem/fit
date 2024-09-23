// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../config/navigation/navigation_services.dart';
import '../../../config/navigation/routes.dart';

class NotificationsFCM {
  NotificationsFCM() {
    log("notification here");
    configLocalNotification();
    registerNotification();
    _createNotificationChannel("fitfat", "fitfat", "fitfat");
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  configLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
 if (response.payload != null) {
        final Map<String, dynamic> notificationInfo = json.decode(response.payload??'');

        // Access specific fields from the notificationInfo
        final String screen = notificationInfo['screen'];
        final String clickAction = notificationInfo['click_action'];
        final String propertyId = notificationInfo['property_id'];
        // NavigationService.navigationKey.currentState!.push(MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId:int.parse(propertyId))));

        // Use the information as needed
        print('Screen: $screen, Click Action: $clickAction, Property ID: $propertyId');
      }
       
  });
  }

  void registerNotification() async {
    try {
      await firebaseMessaging.requestPermission();

      // Foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final RemoteNotification? notification = message.notification;
        final Map<String, dynamic> data = message.data;
        log("notification here");
        log(data.toString());
        log(data.entries.first.toString());
        
        if (notification == null) showNotification('${data["title"]}', data["body"],message);
        if (notification != null) showNotification('${notification.title}', '${notification.body}',message);
      });

      FirebaseMessaging.onBackgroundMessage((message) =>
          NavigationService.navigationKey.currentState!.pushNamed(Routes.splashScreen));
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async =>
          NavigationService.navigationKey.currentState!.pushNamed(Routes.splashScreen));
  
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> handleNotificationsFromTermination() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleMessage(initialMessage);
  }

  static void _handleMessage(RemoteMessage message) async {
    print("FCM Message Data: ${message.data}");
    print("FCM Message Notification: ${message.notification}");
    }

  Future<void> _createNotificationChannel(
      String id, String name, String description) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = AndroidNotificationChannel(id, name);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void showNotification(title, message,RemoteMessage remoteMessage) async {
final Map<String, dynamic> remoteMessageMap = {
    'screen': remoteMessage.data['screen'],
    'click_action': remoteMessage.data['click_action'],
    'property_id': remoteMessage.data['property_id'],
    // Add other fields as needed
  };
    final String remoteMessageJson = json.encode(remoteMessageMap);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'medsouq',
      'medsouq',
      playSound: true,
      enableVibration: false,
      importance: Importance.max,
      priority: Priority.high,
      
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      '$title',
      '$message',
      platformChannelSpecifics,
      payload: remoteMessageJson,

    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    _handleMessage(message);
  }

  static Future<String?> getToken() async =>
      await FirebaseMessaging.instance.getToken();

  void saveFCM(String fcm) async {}
}
