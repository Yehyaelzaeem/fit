import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/modules/notification_api.dart';
import 'package:app/app/utils/theme/app_theme.dart';
import 'package:app/app/utils/translations/app_translations.dart';
import 'package:app/globale_controller.dart';
//import 'package:appspector/appspector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'app/modules/invoice/controllers/invoice_controller.dart';
import 'app/modules/subscribe/controllers/subscribe_controller.dart';
import 'app/modules/usuals/controllers/usual_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runAppSpector();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  getFireBaseNotifications();
  getNotificationPermission();
  await NotificationApi.init();
  await GetStorage().initStorage;
  Get.put(GlobalController(), tag: "global");
  Get.put(HomeController(), tag: "home");
  Get.put(DiaryController(), tag: "diary");
  Get.put(UsualController(), tag: "usual");
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

Future getNotificationPermission() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  Future<PermissionStatus> permissionStatus =
      NotificationPermissions.getNotificationPermissionStatus();
  permissionStatus.then((value) {
    if (value.name != 'granted') {
      Future.delayed(const Duration(seconds: 5), () {
        NotificationPermissions.requestNotificationPermissions();
      });
    }
  });
}

// runAppSpector() {
//   final config = Config()
//     ..iosApiKey = "Your iOS API_KEY"
//     ..androidApiKey = "android_YzkyZjQ2NmEtMTQ0OS00YTVkLWJlODItYmIxOTdlYjkwNDQz";
//   // If you don't want to start all monitors you can specify a list of necessary ones
//   config.monitors = Monitors.all();
//
//   AppSpectorPlugin.run(config);
// }