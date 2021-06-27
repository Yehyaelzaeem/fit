import 'package:app/app/utils/theme/app_theme.dart';
import 'package:app/app/utils/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "FIT over FAT",
      enableLog: true,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      smartManagement: SmartManagement.keepFactory,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 500),
      locale: Locale('ar'),
      color: Colors.green,
      translations: AppTranslation(),
    ),
  );
}
