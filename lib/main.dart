import 'dart:io';

import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/modules/myPackages/controllers/my_packages_controller.dart';
import 'package:app/app/modules/notification_api.dart';
import 'package:app/app/utils/theme/app_theme.dart';
import 'package:app/app/utils/translations/app_translations.dart';
import 'package:app/globale_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/modules/invoice/controllers/invoice_controller.dart';
import 'app/modules/subscribe/controllers/subscribe_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getFireBaseNotifications();
  await NotificationApi.init();
  await GetStorage().initStorage;
  Get.put(GlobalController(), tag: "global");
  Get.put(HomeController(), tag: "home");
  Get.put(InvoiceController());
  Get.put(SubscribeController());
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
  // while app is opened
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    NotificationApi.showNotification(
      id: 0,
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
    //  payLoad: message.data['screen']=='video'?"Video ${message.data['video_id']??""}":"News ${message.data['blog_id']??""}",
    );
    if (message.notification != null) {
      print('Message also contained a notification: ${message.data}');
      print("message $message");
      print("data ${message.data}");
    }
  });
  // while app is closed
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("message $message");
    print("data ${message.data}");
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("onBackgroundMessage");
    print("message $message");
    print("data ${message.data}");
  });
}