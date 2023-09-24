import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/pdf_viewr.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/day_details_reposne.dart';
import '../../../models/usual_meals_data_reposne.dart';
import '../../../routes/app_pages.dart';

class UsualController extends GetxController {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController textEditController = TextEditingController();
  RxList<FoodCaloriesDetails> caloriesDetails = RxList();
  RxList<FoodCaloriesDetails> carbsDetails = RxList();
  RxList<FoodCaloriesDetails> fatsDetails = RxList();
  TextEditingController mealNameController = TextEditingController();
  final mealName = "".obs;
  final response = UsualMealsDataResponse().obs;
  FocusNode workoutTitleDescFocus = FocusNode();
  final isLoading = false.obs;
  final refreshLoadingProtine = false.obs;
  final refreshLoadingCarbs = false.obs;
  final refreshLoadingFats = false.obs;
  final isToday = false.obs;
  final noSessions = false.obs;
  final showLoader = false.obs;
  final lastSelectedDate = ''.obs;
  final date = ''.obs;
  final apiDate = ''.obs;
  final workOutData = ''.obs;
  final qtyProtine = ''.obs;
  final foodProtine = ''.obs;
  String? workDesc;
  final length = 0.obs;
  final workOut = 0.obs;

  @override
  void onInit() {
    super.onInit();
    usualMealsData();
  }


  void usualMealsData() async {
/*
    if (isLoading.value) return;
    if (refreshLoadingProtine.value) return;
    if (refreshLoadingCarbs.value) return;
    if (refreshLoadingFats.value) return;
    Echo('getDiaryData');
    isLoading.value = true;
    caloriesDetails.clear();
    carbsDetails.clear();
    fatsDetails.clear();
*/
    isLoading.value = true;

    await ApiProvider().getUsualMealsData().then((value) {

      if (value.data != null) {
        showLoader.value = false;
        response.value = value;
      }
      isLoading.value = false;

    });
  }

/*
  void refreshDiaryData(String _date, String type) async {
    Echo('refreshDiaryData');
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;
    lastSelectedDate.value = _date;
    response.value = await ApiProvider().getDiaryView(_date);
    if (response.value.data!.proteins!.caloriesDetails!.isEmpty &&
        response.value.data!.carbs!.caloriesDetails!.isEmpty &&
        response.value.data!.fats!.caloriesDetails!.isEmpty) {
      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;
      return;
    } else {
      // caloriesDetails.removeWhere((element) => element.id == null);
      // carbsAndFats.removeWhere((element) => element.id == null);
      response.value.data!.proteins!.caloriesDetails!.forEach((element) {
        if (caloriesDetails
                .where((element2) => element.id == element2.id)
                .toList()
                .length >
            0) {
          caloriesDetails.forEach((item) {
            if (item.id == element.id) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
        //  refreshCaloriesList(response.value.data!.proteins!.caloriesDetails ?? []);
        }
      });
      response.value.data!.carbs!.caloriesDetails!.forEach((element) {
        if (carbsDetails
                .where((element2) => element.id == element2.id)
                .toList()
                .length >
            0) {
          carbsDetails.forEach((item) {
            if (item.id == element.id) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
      ///    refreshCarbsList(response.value.data!.carbs!.caloriesDetails ?? []);
        }
      });

      response.value.data!.fats!.caloriesDetails!.forEach((element) {
        if (fatsDetails
                .where((element2) => element.id == element2.id)
                .toList()
                .length >
            0) {
          fatsDetails.forEach((item) {
            if (item.id == element.id) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
     //     refreshFatsList(response.value.data!.fats!.caloriesDetails ?? []);
        }
      });
    }
    caloriesDetails.refresh();
    carbsDetails.refresh();
    fatsDetails.refresh();
    caloriesDetails.forEach((element) {});
    carbsDetails.forEach((element) {});
    carbsDetails.forEach((element) {});
    fatsDetails.forEach((element) {});
    if (type == 'proteins') refreshLoadingProtine.value = false;
    if (type == 'carbs') refreshLoadingCarbs.value = false;
    if (type == 'fats') refreshLoadingFats.value = false;
  }
*/

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
        Fluttertoast.showToast(msg: "${value.message}");
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
        Fluttertoast.showToast(msg: "${value.message}");
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
        Fluttertoast.showToast(msg: "${value.message}");
      }
    });
  }

  void updateWaterData(String water) async {
    showLoader.value = true;
    await ApiProvider()
        .createDiaryData(water: water, date: apiDate.value)
        .then((value) {
      if (value.success == true) {
        showLoader.value = false;
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        // Fluttertoast.showToast(msg: "${value.message}");
        Echo("error");
      }
    });
  }

  final workoutLoading = false.obs;

  void updateWork() async {
    workoutLoading.value = true;
    await ApiProvider().createDiaryData(
      workOut: workOut.value,
      workout_desc: workDesc,
      date: apiDate.value,
    ).then((value) {
      if (value.success == true) {
        workoutLoading.value = false;
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        workoutLoading.value = false;
        Fluttertoast.showToast(msg: "Server Error");
        Echo("error");
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