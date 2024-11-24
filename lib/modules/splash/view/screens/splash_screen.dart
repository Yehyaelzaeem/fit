import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../config/navigation/navigation_services.dart';
import '../../../../config/navigation/routes.dart';
import '../../../../core/resources/resources.dart';
import '../../../auth/cubit/auth_cubit/auth_cubit.dart';
import '../../../notification_api.dart';
import '../../../profile/cubits/profile_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthCubit authCubit;
  late final ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    authCubit = BlocProvider.of<AuthCubit>(context);
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    Future.delayed(
      Time.t2_5s,
          () async {
            fetchAndRedirect();
          },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchAndRedirect() async {

    initLocalNotification();

    if (authCubit.isAuthed) {
      profileCubit.getProfile();
      NavigationService.pushReplacementAll(context, Routes.homeScreen);

    } else {

      bool isSaved = await authCubit.isDataSaved();

      if(isSaved){
        if (authCubit.isAuthed) {
          await profileCubit.getProfile();
          NavigationService.pushReplacementAll(context, Routes.homeScreen);

        } else {
          NavigationService.pushReplacementAll(context, Routes.authScreen);

        }
      }else {
        NavigationService.pushReplacementAll(context, Routes.authScreen);
      }
    }
  }

  initLocalNotification() {
    NotificationApi.init(isScheduled: true);


    NotificationApi.scheduleDailyNotifications();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: AppColors.white,
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppIcons.splashIcon),

                          // AnimationConfiguration.staggeredList(
                          //   position: 1,
                          //   duration: Duration(seconds: 1),
                          //   child: SlideAnimation(
                          //     verticalOffset: 375.0,
                          //     child: FadeInAnimation(
                          //       child: Container(
                          //         margin: EdgeInsets.symmetric(horizontal: 100),
                          //         child: Image.asset(
                          //           AppImages.kLogoColumn,
                          //           width: double.infinity,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // AnimationConfiguration.staggeredList(
                          //   position: 1,
                          //   duration: Duration(seconds: 2),
                          //   child: SlideAnimation(
                          //     horizontalOffset: 500.0,
                          //     child: FadeInAnimation(
                          //       child:Text(
                          //         " Dr/ Ramy Mansour",
                          //         style: TextStyle(color: Colors.black87, fontSize: 18),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   width: deviceWidth,
                          //   child: Center(
                          //     child: DefaultTextStyle(
                          //       style: const TextStyle(
                          //           fontSize: 18.0,
                          //           fontFamily: 'appFont',
                          //           color: Colors.white),
                          //       child: AnimatedTextKit(
                          //         totalRepeatCount: 1,
                          //         animatedTexts: [
                          //           TyperAnimatedText('                     ',
                          //               speed: Duration(milliseconds: 45)),
                          //         ],
                          //         onFinished: () {
                          //           fetchAndRedirect();
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )

    ;
  }

  navigateNextPage() async {
    // final controller = BlocProvider.of<HomeCubit>(context);
    // //print("Controller Data ===> Logged : ${controller.isLogggd.value} ,  Name : ${controller.name.value},  Last Name : ${controller.lastName.value},Id : ${controller.id.value},  Image : ${controller.avatar.value}");
    // print("Controller Data ===> Logged :   Id : ${controller.id.value}, ");
    // controller.isLogggd.value =
    // await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    // controller.name.value =
    // await SharedHelper().readString(CachingKey.USER_NAME);
    // controller.id.value = await SharedHelper().readString(CachingKey.USER_ID);
    // controller.lastName.value =
    // await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    // controller.avatar.value =
    // await SharedHelper().readString(CachingKey.AVATAR);
    // if (controller.isLogggd.value == true) {
    //   BlocProvider.of<UsualCubit>(context).getUserUsualMeals();
    //   BlocProvider.of<UsualCubit>(context).usualMealsData();
    //   // Get.offAllNamed(Routes.HOME);
    //   NavigationService.pushReplacementAll(context, Routes.homeScreen);
    // } else {
    //   NavigationService.push(context, Routes.authScreen);
    //
    // }
  }

}
