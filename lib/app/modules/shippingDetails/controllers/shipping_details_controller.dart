import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/globale_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingDetailsController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>(tag: 'global');
  GlobalKey<FormState> key = GlobalKey();
  List<SingleMyMeal> meals = [];
  final detailedAddress = ''.obs;
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  @override
  void onInit() async {
    meals = Get.arguments;

    if (kDebugMode) {
      detailedAddress.value = 'address';
      name.value = 'name';
      email.value = 'email@email.com';
      phone.value = 'phome';
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void submit() {
    Get.toNamed(Routes.CART, arguments: meals, parameters: {
      'name': name.value,
      'email': email.value,
      'phone': phone.value,
      'address': detailedAddress.value,
      'latitude': latitude.value.toString(),
      'longitude': longitude.value.toString(),
    });
  }
}
