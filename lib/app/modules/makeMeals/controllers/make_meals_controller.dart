import 'package:app/app/models/meal_food_list_response.dart';
import 'package:app/app/network_util/api_provider.dart';
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

      if (globalController.response.value.data!.where((element) => element.title! == "Protien").isNotEmpty) protein.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Protien").food!;

      if (globalController.response.value.data!.where((element) => element.title! == "Carb").isNotEmpty) carb.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Carb").food!;

      if (globalController.response.value.data!.where((element) => element.title! == "Fats").isNotEmpty) fat.value = globalController.response.value.data!.firstWhere((element) => element.title! == "Fats").food!;
    } catch (e) {
      error.value = '$e';
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
    carb.forEach((element) {
      foodIds += element.id.toString() + ",";
      amountIds += element.selectedAmount.id.toString() + ",";
    });
    fat.forEach((element) {
      foodIds += element.id.toString() + ",";
      amountIds += element.selectedAmount.id.toString() + ",";
    });
    foodIds.substring(0, foodIds.length - 1);
    amountIds.substring(0, foodIds.length - 1);

    try {
      await ApiProvider().createNewMeal(
        name: mealName.value,
        amountsId: amountIds,
        foodIds: foodIds,
      );

      Get.back(result: true);
    } catch (e) {
      Get.snackbar("Error", "$e");
    }
    saveLoading.value = false;
  }
}
