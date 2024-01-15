import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  cupertinoOverrideTheme: NoDefaultCupertinoThemeData(applyThemeToAll: false),
  primarySwatch: Colors.green,
  primaryColor: PRIMART_COLOR,
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'appFont',
  // textTheme: TextTheme(
  //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  // ),
);
