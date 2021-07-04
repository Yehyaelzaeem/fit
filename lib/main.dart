import 'package:app/app/utils/theme/app_theme.dart';
import 'package:app/app/utils/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    GetMaterialApp(
      title: "FIT over FAT",
      enableLog: true,
      initialRoute: AppPages.INITIAL,
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
