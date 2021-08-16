import 'package:app/app/data/database/shared_pref.dart';
import 'package:app/app/modules/sessions/controllers/sessions_controller.dart';
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
    bool IsLogggd = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    var token = await SharedHelper().readString(CachingKey.TOKEN);
    print("Status  Logged : ${IsLogggd} ,  Token : ${token}");
    if (IsLogggd == true) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);

    }
  }

}
