import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with SingleGetTickerProviderMixin {
  final error = ''.obs;

  // final response = SplashResponse().obs;
  final response = ''.obs;

  AnimationController? animationController;
  Animation<double>? animation;
  var animationValue = (0.0).obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = new CurvedAnimation(parent: animationController!, curve: Curves.fastOutSlowIn);
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
    final controller = Get.put(HomeController());
    String id = await SharedHelper().readString(CachingKey.USER_ID);
    print("Controller Data ===> Logged : ${controller.isLogggd.value} ,  Name : ${controller.name
        .value},  Id : ${controller.id.value},  Image : ${controller.avatar.value}");
    controller.isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    controller.name.value = await SharedHelper().readString(CachingKey.USER_NAME);
    controller.avatar.value = await SharedHelper().readString(CachingKey.AVATAR);
    controller.id.value = await SharedHelper().readString(CachingKey.USER_ID);
    if (controller.isLogggd.value == true) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
