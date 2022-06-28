import 'package:app/app/models/meal_food_list_response.dart';
import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/globale_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakeMealsController extends GetxController {
  TextEditingController mealNameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final globalController = Get.find<GlobalController>(tag: 'global');
  final mealName = "".obs;
  final note = "".obs;
  final error = ''.obs;
  final loading = false.obs;
  final saveLoading = false.obs;

  RxList<Food> proteinSelected = RxList<Food>();
  RxList<Food> carbSelected = RxList<Food>();
  RxList<Food> fatSelected = RxList<Food>();

  RxList<Food> protein = RxList<Food>();
  RxList<Food> carb = RxList<Food>();
  RxList<Food> fat = RxList<Food>();

  SingleMyMeal? meal;
  @override
  void onInit() {
    getNetworkData();
    super.onInit();
  }

  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {
      if (globalController.response.value.data == null) globalController.response.value = await ApiProvider().getMealFoodList();

      if (globalController.response.value.data!.where((element) => element.title! == "Protien").isNotEmpty) protein.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Protien").food;

      if (globalController.response.value.data!.where((element) => element.title! == "Carb").isNotEmpty) carb.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Carb").food;

      if (globalController.response.value.data!.where((element) => element.title! == "Fats").isNotEmpty) fat.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Fats").food;

      if (Get.arguments != null) meal = Get.arguments;
      if (meal != null) {
        meal!.items.forEach((element) {
          Echo('title ${element.title} length ${element.items.length}');
        });
        mealName.value = meal!.name;
        note.value = meal!.note ?? '';
        mealNameController.text = meal!.name;
        noteController.text = note.value;
        meal!.items.forEach((element) {
          if (element.title == "Protien") {
            element.items.forEach((element) {
              Food? food;
              Amount? amount;
              protein.forEach((item) {
                if (item.id == element.id) {
                  item.amounts.forEach((amountItem) {
                    if (element.amount == amountItem.name) amount = amountItem;
                  });
                  if (amount != null)
                    food = Food(
                      id: item.id,
                      title: item.title,
                      selectedAmount: amount!,
                      amounts: item.amounts,
                    );
                }
              });
              if (food != null) proteinSelected.add(food!);
            });
          }

          if (element.title == "Carb" || element.title == "carb") {
            element.items.forEach((element) {
              Food? food;
              Amount? amount;
              carb.forEach((item) {
                if (item.id == element.id) {
                  item.amounts.forEach((amountItem) {
                    if (element.amount == amountItem.name) amount = amountItem;
                  });
                  if (amount != null)
                    food = Food(
                      id: item.id,
                      title: item.title,
                      selectedAmount: amount!,
                      amounts: item.amounts,
                    );
                }
              });
              if (food != null) carbSelected.add(food!);
            });
          }
          if (element.title == "Fat" || element.title == "fat") {
            element.items.forEach((element) {
              Food? food;
              Amount? amount;
              fat.forEach((item) {
                if (item.id == element.id) {
                  item.amounts.forEach((amountItem) {
                    if (element.amount == amountItem.name) amount = amountItem;
                  });
                  if (amount != null)
                    food = Food(
                      id: item.id,
                      title: item.title,
                      selectedAmount: amount!,
                      amounts: item.amounts,
                    );
                }
              });
              if (food != null) fatSelected.add(food!);
            });
          }
        });
      }
    } catch (e) {
      error.value = '$e';
      loading.value = false;
    }
    loading.value = false;
  }

  double totalPrice() {
    double total = 0;
    proteinSelected.forEach((element) {
      if (element.selectedAmount.price.isNotEmpty) total += double.parse(element.selectedAmount.price);
    });
    carbSelected.forEach((element) {
      if (element.selectedAmount.price.isNotEmpty) total += double.parse(element.selectedAmount.price);
    });
    fatSelected.forEach((element) {
      if (element.selectedAmount.price.isNotEmpty) total += double.parse(element.selectedAmount.price);
    });
    return total;
  }

  void saveMeal() async {
    saveLoading.value = true;

    String foodIds = "";
    String amountIds = "";
    proteinSelected.forEach((element) {
      foodIds += element.id.toString() + ",";
      amountIds += element.selectedAmount.id.toString() + ",";
    });
    carbSelected.forEach((element) {
      foodIds += element.id.toString() + ",";
      amountIds += element.selectedAmount.id.toString() + ",";
    });
    fatSelected.forEach((element) {
      foodIds += element.id.toString() + ",";
      amountIds += element.selectedAmount.id.toString() + ",";
    });
    foodIds.substring(0, foodIds.length - 1);
    amountIds.substring(0, amountIds.length - 1);

    try {
      if (meal != null) {
        await ApiProvider().updateNewMeal(
          id: meal!.id.toString(),
          name: mealName.value,
          amountsId: amountIds,
          foodIds: foodIds,
          note: note.value,
        );
      } else
        await ApiProvider().createNewMeal(
          name: mealName.value,
          amountsId: amountIds,
          foodIds: foodIds,
          note: note.value,
        );

      Get.back(result: true);
    } catch (e) {
      Get.snackbar("Error", "$e");
      saveLoading.value = false;
    }
    saveLoading.value = false;
  }
}
