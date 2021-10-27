
import 'dart:io';

import 'package:app/app/utils/theme/app_theme.dart';
import 'package:app/app/utils/translations/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

Future selectNotification(payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  // await Navigator.push(
  //   context,
  //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  // );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  if (Platform.isAndroid) await FlutterLocalNotificationsPlugin().initialize(initializationSettings, onSelectNotification: selectNotification);

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
