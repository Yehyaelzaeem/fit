import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'config/localization/cubit/l10n_cubit.dart';
import 'config/localization/l10n/l10n.dart';
import 'config/navigation/navigation.dart';
import 'config/theme/light_theme.dart';
import 'core/resources/app_colors.dart';
import 'core/services/bloc_observer.dart';
import 'core/utils/constants.dart';
import 'firebase_options.dart';
import 'modules/auth/cubit/auth_cubit/auth_cubit.dart';
import 'modules/general/cubits/general_data_cubit.dart';
import 'di_container.dart' as di;
import 'package:permission_handler/permission_handler.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        // BlocProvider(create: (_) => di.sl<L10nCubit>()),
        // BlocProvider(create: (_) => di.sl<LayoutCubit>()),
        BlocProvider(create: (_) => di.sl<GeneralDataCubit>()),
        BlocProvider(create: (_) => di.sl<AuthCubit>()),

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
