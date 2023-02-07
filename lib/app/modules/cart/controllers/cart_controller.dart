import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/modules/cart/views/web_view.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/globale_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../models/meal_features_home_response.dart';
import '../../../models/meal_features_status_response.dart';

class CartController extends GetxController {
  final GlobalController globalController =
      Get.find<GlobalController>(tag: 'global');
  RxList<SingleMyMeal> meals = RxList<SingleMyMeal>();
  MealFeatureStatusResponse  mealFeatureStatusResponse = MealFeatureStatusResponse();

  final loading = false.obs;
  final isLoading = false.obs;
  late String name;
  late String lastName;
  late String phone;
  late String email;
  late String address;
  late String latitude;
  late String longitude;
  void getStatus() async {
    isLoading.value=true;
    await ApiProvider().getMealFeaturesStatus().then((value) {
      if (value.success == true) {
        mealFeatureStatusResponse = value;
        update();
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }
    });
    isLoading.value=false;

  }
  @override
  void onInit() {
    getStatus();
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


  int mealPrice({
    required SingleMyMeal meal,
  }) {
    int sum = int.parse(meal.price!);
    if (meal.qty != 1) {
      sum = int.parse(meal.price!) * meal.qty!;
    }
    return sum;
  }


  totalAmount() {
    double total = 0;
    meals.forEach((element) {
      if (element.price != null) total += double.parse(element.price!)*element.qty!;
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
      String qtys='' ;
      this.meals.forEach((element) {
        meals += '${element.id},';
        qtys +='${element.qty},';
        // element.items.forEach((item) {
        //   item.items.forEach((subItem) {
        //     meals += '${subItem.id},';
        //   });
        // });
      });
      meals = meals.replaceRange(meals.length - 1, meals.length, '');
      qtys = qtys.replaceRange(qtys.length - 1, qtys.length, '');
      print("qtys ${qtys}");
      String paymentUrl = await ApiProvider().createShoppingCart(
        name: name,
        lastName: lastName,
        phone: phone,
        email: email,
        address: address,
        latitude: latitude,
        longitude: longitude,
        meals: meals,
        qtys: qtys,
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
        paymentUrl == ""
            ? Fluttertoast.showToast(msg: "  Payment is deactivated  ")
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                          url: paymentUrl,
                          fromCheerfull: "From Cheerful Order",
                        )));
        print("URL ==========> ${paymentUrl}");
      }
    } catch (e) {
      Get.snackbar(Strings().notification, '$e');
    }
    loading.value = false;
  }
}
