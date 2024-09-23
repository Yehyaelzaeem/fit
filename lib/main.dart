import 'package:app/modules/home/cubits/home_cubit.dart';
import 'package:app/modules/profile/cubits/profile_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'config/localization/cubit/l10n_cubit.dart';
import 'config/navigation/navigation.dart';
import 'core/resources/app_colors.dart';
import 'core/services/bloc_observer.dart';

import 'modules/about/cubits/about_cubit.dart';
import 'modules/auth/cubit/auth_cubit/auth_cubit.dart';
import 'modules/diary/cubits/diary_cubit.dart';
import 'modules/general/cubits/general_data_cubit.dart';
import 'di_container.dart' as di;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'modules/other_calories/cubits/other_calories_cubit.dart';
import 'modules/sessions/cubits/session_cubit.dart';
import 'modules/timeSleep/cubits/time_sleep_cubit.dart';
import 'modules/usuals/cubits/usual_cubit.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart' as permission;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  await di.init();
  Bloc.observer = MyBlocObserver();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  int _orderID;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    _orderID = ((notificationAppLaunchDetails!.notificationResponse!.payload != null && notificationAppLaunchDetails.notificationResponse!.payload!.isNotEmpty)
        ? int.parse(notificationAppLaunchDetails.notificationResponse!.payload!)
        : null)!;
  }
  // await MyNotification.initialize(flutterLocalNotificationsPlugin);
  // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);


  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<L10nCubit>()),
        // BlocProvider(create: (_) => di.sl<LayoutCubit>()),
        BlocProvider(create: (_) => di.sl<GeneralDataCubit>()),
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider(create: (_) => di.sl<UsualCubit>()),
        BlocProvider(create: (_) => di.sl<DiaryCubit>()),
        BlocProvider(create: (_) => di.sl<TimeSleepCubit>()),
        BlocProvider(create: (_) => di.sl<SessionCubit>()),
        BlocProvider(create: (_) => di.sl<OtherCaloriesCubit>()),
        BlocProvider(create: (_) => di.sl<AboutCubit>()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FIT over FAT",
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      navigatorKey: NavigationService.navigationKey,
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      // localizationsDelegates: L10n.localizationDelegates,
      // supportedLocales: L10n.supportedLocales,
      // localeResolutionCallback: L10n.setFallbackLocale,
      // locale: BlocProvider.of<L10nCubit>(context, listen: true).appLocale,
    );
  }
}


final ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  //cupertinoOverrideTheme: NoDefaultCupertinoThemeData(: false),
  primarySwatch: Colors.green,
  primaryColor: AppColors.PRIMART_COLOR,
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'appFont',
  // textTheme: TextTheme(
  //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  // ),
);
