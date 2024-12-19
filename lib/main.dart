import 'package:app/modules/home/cubits/home_cubit.dart';
import 'package:app/modules/myMeals/cubits/my_meals_cubit.dart';
import 'package:app/modules/profile/cubits/profile_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';

import 'config/localization/cubit/l10n_cubit.dart';
import 'config/navigation/navigation.dart';
import 'core/resources/app_colors.dart';
import 'core/services/bloc_observer.dart';

import 'modules/about/cubits/about_cubit.dart';
import 'modules/auth/cubit/auth_cubit/auth_cubit.dart';
import 'modules/cheerful/cubits/cheerfull_cubit.dart';
import 'modules/diary/cubits/diary_cubit.dart';
import 'modules/force_update/cubits/force_update_cubit.dart';
import 'modules/general/cubits/general_data_cubit.dart';
import 'di_container.dart' as di;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'modules/makeMeals/cubits/make_meals_cubit.dart';
import 'modules/orders/cubits/order_cubit.dart';
import 'modules/other_calories/cubits/other_calories_cubit.dart';
import 'modules/packages/cubits/packages_cubit.dart';
import 'modules/sessions/cubits/session_cubit.dart';
import 'modules/subscribe/cubits/subscribe_cubit.dart';
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

  // debugPaintSizeEnabled = false; // Show layout gridlines


  // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  // await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // int _orderID;
  // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  //   _orderID = ((notificationAppLaunchDetails!.notificationResponse!.payload != null && notificationAppLaunchDetails.notificationResponse!.payload!.isNotEmpty)
  //       ? int.parse(notificationAppLaunchDetails.notificationResponse!.payload!)
  //       : null)!;
  // }
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
        BlocProvider(create: (_) => di.sl<CheerFullCubit>()),
        BlocProvider(create: (_) => di.sl<OrdersCubit>()),
        BlocProvider(create: (_) => di.sl<MyMealsCubit>()),
        BlocProvider(create: (_) => di.sl<MakeMealsCubit>()),
        BlocProvider(create: (_) => di.sl<PackagesCubit>()),
        BlocProvider(create: (_) => di.sl<SubscribeCubit>()),
        BlocProvider(create: (_) => di.sl<ForceUpdateCubit>()),

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
      builder: (context, child) =>Builder(builder: (context) =>
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
                devicePixelRatio: 1
            ),
            child:  child!
          )),
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

  // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
  //     .copyWith(secondary: Colors.deepOrange),
  fontFamily: 'appFont',
  // textTheme: TextTheme(
  //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  // ),
);



// void getFireBaseNotifications() {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   print("messaging ${messaging.app.name}");
//   // while app is opened
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Got a message whilst in the foreground!');
//     // NotificationApi.showNotification(
//     //   id: 0,
//     //   title: message.notification?.title ?? "",
//     //   body: message.notification?.body ?? "",
//     // );
//     if (message.notification != null) {
//       print('Message also contained a notification: ${message.data}');
//       print("message $message");
//       print("data ${message.data}");
//     }
//   });
//   // while app is closed
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print("message $message");
//     if (message.notification != null) {
//       _showLocalNotification(message); // Show the notification
//     }  });
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     if (message.notification != null) {
//       _showLocalNotification(message); // Show the notification
//     }
//   });
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print("onBackgroundMessage");
//     print("message $message");
//     if (message.notification != null) {
//       _showLocalNotification(message); // Show the notification
//     }
//   });
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     if (message.notification != null) {
//       _showLocalNotification(message); // Show the notification
//     }
//   });
// }
//
Future getNotificationPermission() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  var permissionStatus =
  NotificationPermissions.getNotificationPermissionStatus();
  permissionStatus.then((value) {
    if (value.name != 'granted') {
      Future.delayed(const Duration(seconds: 5), () {
        NotificationPermissions.requestNotificationPermissions();
      });
    }
  });
}
//
// void _showLocalNotification(RemoteMessage message) async {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails(
//     'high_importance_channel', // Channel ID
//     'High Importance Notifications', // Channel name
//     channelDescription: 'This channel is used for important notifications.',
//     importance: Importance.max,
//     priority: Priority.high,
//     ticker: 'ticker',
//     icon: '@drawable/ic_notification', // Custom icon
//   );
//
//   const NotificationDetails platformChannelSpecifics =
//   NotificationDetails(android: androidPlatformChannelSpecifics);
//
//   await flutterLocalNotificationsPlugin.show(
//     message.notification.hashCode,
//     message.notification?.title,
//     message.notification?.body,
//     platformChannelSpecifics,
//   );
// }


