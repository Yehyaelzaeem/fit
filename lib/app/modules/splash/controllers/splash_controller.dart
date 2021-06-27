import 'package:app/app/data/database/shared_pref.dart';
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

  navigateNextPage() {
    YemenyPrefs prefs = YemenyPrefs();
    if (prefs.getFirstTimeVisit()!) {
      Get.offAllNamed(Routes.INTRODUCTION_SCREEN);
    } else if (prefs.getToken() == null || prefs.getToken()!.isEmpty) {
      // Get.offAllNamed(Routes.AUTH);
      Get.toNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
