import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/globale_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>(tag: 'global');
  RxList<SingleMyMeal> meals = RxList<SingleMyMeal>();
  final loading = false.obs;
  late String name;
  late String phone;
  late String email;
  late String address;
  late String latitude;
  late String longitude;
  @override
  void onInit() {
    meals.value = Get.arguments;
    name = Get.parameters['name'] ?? '';
    phone = Get.parameters['phone'] ?? '';
    email = Get.parameters['email'] ?? '';
    address = Get.parameters['address'] ?? '';
    latitude = Get.parameters['latitude'] ?? '';
    longitude = Get.parameters['longitude'] ?? '';
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  totalAmount() {
    double total = 0;
    meals.forEach((element) {
      if (element.price != null) total += double.parse(element.price!);
    });
    return total;
  }

  void deleteMeal(int id) {
    meals.removeWhere((element) => element.id == id);
    if (meals.length == 0)
      Get.back();
    else
      meals.refresh();
  }

  void createOrder(String shippingMethod) async {
    loading.value = true;
    try {
      String meals = '';
      this.meals.forEach((element) {
        meals += '${element.id},';

        // element.items.forEach((item) {
        //   item.items.forEach((subItem) {
        //     meals += '${subItem.id},';
        //   });
        // });
      });
      meals = meals.replaceRange(meals.length - 1, meals.length, '');
      bool status = await ApiProvider().createShoppingCart(
        name: name,
        phone: phone,
        email: email,
        address: address,
        latitude: latitude,
        longitude: longitude,
        meals: meals,
        deliveryMethod: shippingMethod,
      );
      Get.back();
      Get.back();
      Get.back();
      Get.back();

      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                kTextbody("Thank you for ordering from Cheer-Full Have a cheerful day", color: Colors.black, bold: true, align: TextAlign.center),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      Get.snackbar(Strings().notification, '$e');
    }
    loading.value = false;
  }
}
