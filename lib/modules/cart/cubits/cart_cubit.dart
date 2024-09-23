
import 'package:app/config/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../core/models/cheerful_response.dart';
import '../../../core/models/meal_features_home_response.dart';
import '../../../core/models/meal_features_status_response.dart';

import '../../../core/models/mymeals_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/globals.dart';
import '../../../core/utils/shared_helper.dart';
import '../../../core/view/widgets/default/text.dart';
import '../repositories/cart_repository.dart';
import '../views/web_view.dart';

part 'cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  final CartRepository _cartRepository;

  CartCubit(this._cartRepository) : super(CartInitialState());
  RxList<SingleMyMeal> meals = RxList<SingleMyMeal>();
  MealFeatureStatusResponse mealFeatureStatusResponse = MealFeatureStatusResponse();

  final loading = false.obs;
  final isLoading = false.obs;

  void getStatus() async {
    isLoading.value = true;
    await ApiProvider().getMealFeaturesStatus().then((value) {
      if (value.success == true) {
        mealFeatureStatusResponse = value;
        emit(state);
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }
    });
    isLoading.value = false;
  }

  void onInit() {
    getStatus();

  }

  int mealPrice({
    required SingleMyMeal meal,
  }) {
    int sum = (double.tryParse('${meal.price}')?.floor() ?? 0);
    if (meal.qty != 1) {
      sum = (double.tryParse('${meal.price}')?.floor() ?? 0) * meal.qty!;
    }
    return sum;
  }

  totalAmount() {
    double total = 0;
    meals.forEach((element) {
      if (element.price != null) total += (double.parse(element.price!).floor()) * element.qty!;
    });
    return total;
  }

  void deleteMeal(int id) {
    meals.removeWhere((element) => element.id == id);
    if (meals.length == 0)
      NavigationService.goBack(NavigationService.navigationKey.currentState!.context);
    else
      meals.refresh();
  }

  void createOrder({
    required String shippingMethod,
    required BuildContext context,
    required String payMethod,
    required String name,   required String lastName,   required String phone,   required String email,   required String address,   required String latitude,   required String longitude,
  }) async {
    loading.value = true;
    try {
      String meals = '';
      String qtys = '';
      this.meals.forEach((element) {
        meals += '${element.id},';
        qtys += '${element.qty},';
        // element.items.forEach((item) {
        //   item.items.forEach((subItem) {
        //     meals += '${subItem.id},';
        //   });
        // });
      });
      meals = meals.replaceRange(meals.length - 1, meals.length, '');
      qtys = qtys.replaceRange(qtys.length - 1, qtys.length, '');
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
        NavigationService.goBack(context);
        NavigationService.goBack(context);
        NavigationService.goBack(context);
        NavigationService.goBack(context);

        showDialog(
         builder: (context){
           return  Dialog(
             child: Padding(
               padding: const EdgeInsets.all(12.0),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   SizedBox(height: 12),
                   kTextbody("Thank you for ordering from Cheer-Full \n \n 😍 Have a cheerful day 😍", color: Colors.black, bold: true, align: TextAlign.center),
                   SizedBox(height: 12),
                 ],
               ),
             ),
           );
         }, context: context
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
      print(e.toString());
    }
    loading.value = false;
  }
}
