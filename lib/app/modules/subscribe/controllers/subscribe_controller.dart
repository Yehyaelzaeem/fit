import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeController extends GetxController with SingleGetTickerProviderMixin {
  final error = ''.obs;
  final loading = false.obs;
  List<Items> services = [];
  final serviceIndex = 0.obs;
  final currentPageIndex = 0.obs;
  PageController pc = PageController(viewportFraction: 0.7);
  bool smaller = false;
  @override
  void onInit() {
    if(Get.arguments != null)
    services = Get.arguments;
    
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

  
  }

  @override
  void onClose() {
  }

  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {} catch (e) {
      Echo('error response $e');
      error.value = '$e';
    }
    loading.value = false;
  }
}
