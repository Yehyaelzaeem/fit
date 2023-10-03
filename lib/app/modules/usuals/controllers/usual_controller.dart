import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/modules/splash/controllers/splash_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/pdf_viewr.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/usual_meals_data_reposne.dart';
import '../../../models/usual_meals_reposne.dart';
import '../../../routes/app_pages.dart';
import '../../diary/controllers/diary_controller.dart';

class UsualController extends GetxController  with SingleGetTickerProviderMixin {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController textEditController = TextEditingController();
  RxList<FoodDataItem> caloriesDetails = RxList();
  RxList<FoodDataItem> carbsDetails = RxList();
  RxList<FoodDataItem> fatsDetails = RxList();
  final response = UsualMealsDataResponse().obs;
  final mealsResponse = UsualMealsResponse().obs;
  FocusNode workoutTitleDescFocus = FocusNode();
  final isLoading = false.obs;
  final deleteLoading = false.obs;
  final addLoading = false.obs;
  final refreshLoadingProtine = false.obs;
  final refreshLoadingCarbs = false.obs;
  final refreshLoadingFats = false.obs;
  final lastSelectedDate = ''.obs;
  final kUpdate = 1.obs;
  @override
  void onInit() async {
    super.onInit();
    await  getUserUsualMeals();
  }


  Future usualMealsData() async {
    isLoading.value = true;
    await ApiProvider().getUsualMealsData().then((value) {
      if (value.data != null) {
        response.value = value;
      }
    });
    isLoading.value = false;

  }
  List<FoodItem> foodItems = [];
   sendJsonData(FoodDataItem myFood) {
     FoodItem item = FoodItem(foodId: myFood.id!,quantity: myFood.qty!);
     foodItems.add(item);
  }
  Future<void> createUsualMeal({required Map<String,dynamic> mealParameters}) async {
    addLoading.value=true;
    isLoading.value=true;
    await ApiProvider().createUsualMeal(mealParameters: mealParameters)
        .then((value) async {
      if (value.success == true) {
        addLoading.value=false;
        mealsResponse.value=UsualMealsResponse();
        await getUserUsualMeals();
        Fluttertoast.showToast(fontSize: 10,msg: "${value.message}");
      } else {
        Fluttertoast.showToast(fontSize: 10,msg: "${value.message}");
        addLoading.value=false;
      }
      isLoading.value=false;

    });
  }

  Future<void> updateCurrentUsualMeal({required Map<String,dynamic> mealParameters}) async {
    addLoading.value=true;
    isLoading.value=true;
    await ApiProvider().updateUsualMeal(mealParameters: mealParameters)
        .then((value) async {
      if (value.success == true) {
        addLoading.value=false;
        mealsResponse.value=UsualMealsResponse();
        await getUserUsualMeals();
        Fluttertoast.showToast(fontSize: 10,msg: "${value.message}");
      } else {
        Fluttertoast.showToast(fontSize: 10,msg: "${value.message}");
      }
      isLoading.value=false;

    });
  }

  Future addMealToDiary({required int mealId}) async {
    await ApiProvider().mealToDiary(mealId: mealId)
        .then((value) async {
      if (value.success == true) {
        Get.find<DiaryController>(tag: 'diary').onInit();
        Fluttertoast.showToast(fontSize: 10,msg: "${value.message}");
      } else {
        Fluttertoast.showToast(fontSize: 10,msg: "${value.message}");
      }
    });
  }

  Future getUserUsualMeals() async {
     isLoading.value=true;
     addLoading.value=true;

     await ApiProvider().getMyUsualMeals().then((value) {
      if (value.success == true) {
        print("Here success");
        print( mealsResponse.value.data);
        mealsResponse.value = value;
        print("Here success ${mealsResponse.value.data?.length}");
        isLoading.value=false;
        addLoading.value=false;
      } else {
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      }
    });
     kUpdate.value=kUpdate.value+1;
  }

  Future<void> deleteUserUsualMeal(int mealId) async {
    deleteLoading.value = true;
    try {
      final response = await ApiProvider().deleteUsualMeal(mealId: mealId);
      if (response.success == true) {
        mealsResponse.value=UsualMealsResponse();
        await getUserUsualMeals();
        update();
        mealsResponse.refresh();
        deleteLoading.value = false;
        Fluttertoast.showToast(fontSize: 8,msg: "${response.message}");
      } else {
        Fluttertoast.showToast(fontSize: 8,msg: "${response.message}");
      }
    } catch (error) {
      print("Error: $error");
      Fluttertoast.showToast(fontSize: 8,msg: "An error occurred while deleting the meal.");
    }
  }


  Future<void> deleteItemCalories(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        caloriesDetails.removeWhere((element) => element.id == id);
      } else {
        caloriesDetails.removeWhere((element) => element.id == id);
      }
    });
  }


  Future<void> deleteItemCarbs(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        carbsDetails.removeWhere((element) => element.id == id);
      } else {
        carbsDetails.removeWhere((element) => element.id == id);
      }
    });
  }

  Future<void> deleteItemFats(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        fatsDetails.removeWhere((element) => element.id == id);
      } else {
        fatsDetails.removeWhere((element) => element.id == id);
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      }
    });
  }

}




class FoodItem {
  int foodId;
  dynamic quantity;

  FoodItem({required this.foodId,required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'food_id[]': foodId,
      'qty[]': quantity,
    };
  }
}