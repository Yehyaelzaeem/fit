import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:get/get.dart';

class MyMealsController extends GetxController {
  final response = MyMealResponse().obs;
  final error = ''.obs;
  final loading = false.obs;
  final getMyMealsLoading = false.obs;
  @override
  void onInit() {
    getNetworkData();
    super.onInit();
  }

  getNetworkData() async {
    error.value = '';
    getMyMealsLoading.value = true;
    try {
      response.value = await ApiProvider().getMyMeals();
    } catch (e) {
      error.value = '$e';
    }
    getMyMealsLoading.value = false;
  }

  void deleteMeals() {
    response.value.data!.forEach((element) {
      if (element.selected) {
        networkDeleteMeal(element.id.toString());
      }
    });
  }

  networkDeleteMeal(String id) async {
    getMyMealsLoading.value = true;
    try {
      await ApiProvider().deleteMeal(id: id);
      response.value.data!.removeWhere((element) => element.id == int.parse(id));
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
    getMyMealsLoading.value = false;
  }
}
