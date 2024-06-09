import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../notification_api.dart';
import '../../usuals/controllers/usual_controller.dart';

class SplashController extends GetxController
    with SingleGetTickerProviderMixin {
  final error = ''.obs;

  // final response = SplashResponse().obs;
  final response = ''.obs;
  AnimationController? animationController;
  Animation<double>? animation;
  var animationValue = (0.0).obs;

  initLocalNotification() {
    NotificationApi.init(isScheduled: true);

    Future.delayed(Duration(seconds: 2),()=>    NotificationApi.scheduleDailyNotifications());
    NotificationApi.showScheduledNotificationAtTime();
    // Future.delayed(Duration(seconds: 2),()=>    NotificationApi.showScheduledNotification(hour: 2, scheduleDate: DateTime.now().add(Duration(seconds: 2)), id: 5,));
    // Future.delayed(Duration(seconds: 2),()=>    NotificationApi.showScheduledNotification(hour: 11, scheduleDate: DateTime.now().add(Duration(seconds: 2)), id: 1,));
    // Future.delayed(Duration(seconds: 2),()=>    NotificationApi.showScheduledNotification(hour: 14, scheduleDate: DateTime.now().add(Duration(seconds: 2)), id: 2,));
    // Future.delayed(Duration(seconds: 2),()=>    NotificationApi.showScheduledNotification(hour: 17,scheduleDate: DateTime.now().add(Duration(seconds: 2)), id: 3,));
    // Future.delayed(Duration(seconds: 2),()=>    NotificationApi.showScheduledNotification(hour: 20, scheduleDate: DateTime.now().add(Duration(seconds: 2)), id: 4,));
  }

  @override
  void onInit() {
    super.onInit();
    initLocalNotification();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = new CurvedAnimation(
        parent: animationController!, curve: Curves.fastOutSlowIn);
  }

  @override
  void onReady() {
    super.onReady();

    animation!.addListener(() {
      animationValue.value = animationController!.value;
      if (animationValue.value >= 1) {
        // navigateNextPage();
      }
    });
    animationController!.forward();
  }

  @override
  void onClose() {
    animationController!.dispose();
  }

  getNetworkData() async {
    error.value = '';
    try {} catch (e) {
      Echo('error response $e');
      error.value = '$e';
    }
  }

  navigateNextPage() async {
    final controller = Get.find<HomeController>(tag: 'home');
    //print("Controller Data ===> Logged : ${controller.isLogggd.value} ,  Name : ${controller.name.value},  Last Name : ${controller.lastName.value},Id : ${controller.id.value},  Image : ${controller.avatar.value}");
    print("Controller Data ===> Logged :   Id : ${controller.id.value}, ");
    controller.isLogggd.value =
        await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    controller.name.value =
        await SharedHelper().readString(CachingKey.USER_NAME);
    controller.id.value = await SharedHelper().readString(CachingKey.USER_ID);
    controller.lastName.value =
        await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    controller.avatar.value =
        await SharedHelper().readString(CachingKey.AVATAR);
    if (controller.isLogggd.value == true) {
       Get.put(UsualController(), tag: "usual").getUserUsualMeals();
       Get.put(UsualController(), tag: "usual").usualMealsData();
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
