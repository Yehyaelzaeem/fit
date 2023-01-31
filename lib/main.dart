import 'dart:io';

import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/modules/notification_api.dart';
import 'package:app/app/utils/theme/app_theme.dart';
import 'package:app/app/utils/translations/app_translations.dart';
import 'package:app/globale_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/invoice/controllers/invoice_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getFireBaseNotifications();

  await GetStorage().initStorage;
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  if (Platform.isAndroid)
    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
    );

  Get.put(GlobalController(), tag: "global");
  Get.put(HomeController(), tag: "home");
  Get.put(InvoiceController());
  runApp(
    GetMaterialApp(
      title: "FIT over FAT",
      enableLog: true,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      smartManagement: SmartManagement.keepFactory,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 500),
      locale: Locale('en'),
      textDirection: TextDirection.ltr,
      color: Colors.green,
      translations: AppTranslation(),
    ),
  );
}

void getFireBaseNotifications() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  print("messaging ${messaging.app.name}");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    NotificationApi.showNotification(
        id: 0, title: "FitOverFat", body: "While app is opened notification!!");
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}
