import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static final List<Locale> supportedLocales = [
    const Locale("en", ""),
    const Locale("ar", ""),
  ];

  static const List<LocalizationsDelegate> localizationDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static Locale? setFallbackLocale(deviceLocale, _) {
    final List<String> supportedLangCodes = supportedLocales.map((e) => e.languageCode).toList();
    final String deviceLangCode = deviceLocale.toString().substring(0, 2);
    if (!supportedLangCodes.contains(deviceLangCode)) return supportedLocales[0];
    return null;
  }

  static AppLocalizations tr(BuildContext context) => AppLocalizations.of(context)!;

  static bool isAr(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar';
}
