import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:get/get.dart';

class MyMealsController extends GetxController {
  final response = MyMealResponse().obs;
  final error = ''.obs;
  final loading = false.obs;
  final requiredAuth = false.obs;
  final getMyMealsLoading = false.obs;
  @override
  void onInit() async {
    getNetworkData();

    super.onInit();
  }

  getNetworkData() async {
    requiredAuth.value = !await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    if (requiredAuth.value) return;
    error.value = '';
    getMyMealsLoading.value = true;
    try {
      response.value = await ApiProvider().getMyMeals();
    } catch (e) {
      error.value = '$e';
    }
    getMyMealsLoading.value = false;
  }

  void deleteMeals() async {
    response.value.data!.forEach((element) async {
      if (element.selected) {
        await networkDeleteMeal(element.id.toString());
      }
    });
    response.refresh();
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
    response.refresh();
  }
}
