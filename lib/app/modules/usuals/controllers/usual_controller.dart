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
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
        foodItems.clear();
        carbsDetails.clear();
        caloriesDetails.clear();
        fatsDetails.clear();
      } else {
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
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
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
        foodItems.clear();
        carbsDetails.clear();
        caloriesDetails.clear();
        fatsDetails.clear();
      } else {
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
        addLoading.value=false;
      }
      isLoading.value=false;

    });
  }

  Future addMealToDiary({required int mealId}) async {
    await ApiProvider().mealToDiary(mealId: mealId)
        .then((value) async {
      if (value.success == true) {
        Get.find<DiaryController>(tag: 'diary').onInit();
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      } else {
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      }
    });
  }

  Future getUserUsualMeals() async {
     isLoading.value=true;
     await ApiProvider().getMyUsualMeals().then((value) {
      if (value.success == true) {
        print("Here success");
        print( mealsResponse.value.data);
        mealsResponse.value = value;
        print("Here success ${mealsResponse.value.data?.length}");
        isLoading.value=false;
      } else {
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      }
    });
  }

  Future<void> deleteUserUsualMeal(int mealId) async {
    deleteLoading.value = true;
    try {
      final response = await ApiProvider().deleteUsualMeal(mealId: mealId);
      if (response.success == true) {
      //  print("Before ${mealsResponse.value.data!.length}");
    //    mealsResponse.value.data!.removeWhere((element) => element.id == mealId);
      //  print("After ${mealsResponse.value.data!.length}");
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
       // refreshDiaryData(apiDate.value, type);
      } else {
        caloriesDetails.removeWhere((element) => element.id == id);
   //     refreshDiaryData(apiDate.value, type);
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      }
    });
  }


  Future<void> deleteItemCarbs(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        carbsDetails.removeWhere((element) => element.id == id);
      //  refreshDiaryData(apiDate.value, type);
      } else {
        carbsDetails.removeWhere((element) => element.id == id);
    //    refreshDiaryData(apiDate.value, type);
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      }
    });
  }

  Future<void> deleteItemFats(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        fatsDetails.removeWhere((element) => element.id == id);
   //     refreshDiaryData(apiDate.value, type);
      } else {
        fatsDetails.removeWhere((element) => element.id == id);
        //refreshDiaryData(apiDate.value, type);
        Fluttertoast.showToast(fontSize: 8,msg: "${value.message}");
      }
    });
  }
  void downloadFile(String url) async {
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
            builder: (context) =>
                PDFPreview(res: "$url", name: "Calories Calculator")));
  }

  void showPobUp(String text) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return Dialog(
            child: Container(
                height: MediaQuery.of(Get.context!).size.height / 1.5,
                padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        "${text}",
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          );
        });
  }

  void launchURL(_url) async => await launch(_url);
/*

  void createProtineData(int? food, double _quantity,
      {int? index, required String type}) async {
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;
    */
/*  await ApiProvider().createDiaryData(
        foodProtine: food, qtyProtiene: _quantity, date: apiDate.value);
    refreshDiaryData(apiDate.value, type);
  }*//*


    */
/* void updateProtineData(int? index, int? food, double _quantity,
      {required String type}) async {
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;
    await ApiProvider().editDiaryData(
        foodProtine: food,
        qtyProtiene: _quantity,
        date: apiDate.value,
        id: index);
    refreshDiaryData(apiDate.value, type);
  }*//*

*/
/*
    Color getColor(String title) {
      if (title == 'أنتويرب') return Colors.red;
      if (title == 'خقخل') return Colors.red;

      return Colors.black87;
    }

    void refreshCaloriesList(List<CaloriesDetails> list) {
      List<CaloriesDetails> emptyList = [];
      emptyList.addAll(
          caloriesDetails.where((element) => element.qty == null).toList());
      caloriesDetails.clear();
      caloriesDetails.addAll(list);
      caloriesDetails.addAll(emptyList);
      return;
      list.forEach((resItem) {
        if (caloriesDetails.where((item) {
          Echo('item ${item.quality} resItem${resItem.quality}');
          Echo('item ${item.qty} resItem${resItem.qty}');
          return item.quality == resItem.quality && item.qty == resItem.qty;
        }).length >
            0) {
          caloriesDetails.forEach((item) {
            if (item.quality == resItem.quality && item.qty == resItem.qty) {
              item.id = resItem.id;
              item.calories = resItem.calories;
              item.unit = resItem.unit;
            }
          });
        } else {
          caloriesDetails.add(resItem);
        }
      });
    }

    void refreshCarbsList(List<CaloriesDetails> list) {
      List<CaloriesDetails> emptyList = [];
      emptyList
          .addAll(
          carbsDetails.where((element) => element.qty == null).toList());
      carbsDetails.clear();
      carbsDetails.addAll(list);
      carbsDetails.addAll(emptyList);
      return;
      list.forEach((resItem) {
        if (carbsDetails.where((item) {
          Echo('item ${item.quality} resItem${resItem.quality}');
          Echo('item ${item.qty} resItem${resItem.qty}');
          return item.quality == resItem.quality && item.qty == resItem.qty;
        }).length >
            0) {
          carbsDetails
            ..forEach((item) {
              if (item.quality == resItem.quality && item.qty == resItem.qty) {
                item.id = resItem.id;
                item.calories = resItem.calories;
                item.unit = resItem.unit;
              }
            });
        } else {
          carbsDetails..add(resItem);
        }
      });
    }

    void refreshFatsList(List<CaloriesDetails> list) {
      List<CaloriesDetails> emptyList = [];
      emptyList
          .addAll(fatsDetails.where((element) => element.qty == null).toList());
      fatsDetails.clear();
      fatsDetails.addAll(list);
      fatsDetails.addAll(emptyList);
      return;
      list.forEach((resItem) {
        if (fatsDetails.where((item) {
          Echo('item ${item.quality} resItem${resItem.quality}');
          Echo('item ${item.qty} resItem${resItem.qty}');
          return item.quality == resItem.quality && item.qty == resItem.qty;
        }).length >
            0) {
          fatsDetails
            ..forEach((item) {
              if (item.quality == resItem.quality && item.qty == resItem.qty) {
                item.id = resItem.id;
                item.calories = resItem.calories;
                item.unit = resItem.unit;
              }
            });
        } else {
          fatsDetails..add(resItem);
        }
      });
    }*//*

  }
*/
}
class FoodItem {
  int foodId;
  double quantity;

  FoodItem({required this.foodId,required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'food_id[]': foodId,
      'qty[]': quantity,
    };
  }
}