import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/modules/cart/views/web_view.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/globale_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final GlobalController globalController =
      Get.find<GlobalController>(tag: 'global');
  RxList<SingleMyMeal> meals = RxList<SingleMyMeal>();
  final loading = false.obs;
  late String name;
  late String lastName;
  late String phone;
  late String email;
  late String address;
  late String latitude;
  late String longitude;

  @override
  void onInit() {
    meals.value = Get.arguments;
    name = Get.parameters['name'] ?? '';
    lastName = Get.parameters['last_name'] ?? '';
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

  void createOrder({
    required String shippingMethod,
    required BuildContext context,
    required String payMethod,
  }) async {
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
      String paymentUrl = await ApiProvider().createShoppingCart(
        name: name,
        lastName: lastName,
        phone: phone,
        email: email,
        address: address,
        latitude: latitude,
        longitude: longitude,
        meals: meals,
        deliveryMethod: shippingMethod,
        payMethod: payMethod,
      );
      if (payMethod.contains('cash')) {
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
                  kTextbody(
                      "Thank you for ordering from Cheer-Full \n \n 😍 Have a cheerful day 😍",
                      color: Colors.black,
                      bold: true,
                      align: TextAlign.center),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      } else {
        paymentUrl==""?  Fluttertoast.showToast(msg: "  Payment is deactivated  ")
        :    Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => WebViewScreen(
                      url: paymentUrl,
                      fromCheerfull: "From Cheerful Order",
                    )));
        print("URL ==========>${paymentUrl}");
      }
    } catch (e) {
      Get.snackbar(Strings().notification, '$e');
    }
    loading.value = false;
  }
}
