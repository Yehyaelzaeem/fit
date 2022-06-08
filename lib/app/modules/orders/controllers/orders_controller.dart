import 'package:app/app/models/my_orders_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/globale_controller.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>(tag: 'global');

  final response = MyOrdersResponse(code: 200, success: false, data: null).obs;
  final error = ''.obs;
  final selectedTap = 1.obs;

  final loading = false.obs;
  final requiredAuth = false.obs;
  final getMyMealsLoading = false.obs;

  @override
  void onInit() async {
    getNetworkData();

    super.onInit();
  }

  getNetworkData() async {
    if (requiredAuth.value) return;
    error.value = '';
    getMyMealsLoading.value = true;
    try {
      response.value = await ApiProvider().myOrders();
    } catch (e) {
      error.value = '$e';
    }
    getMyMealsLoading.value = false;
  }

  String getMealsName(List<Meal> meals) {
    String mealsName = '';
    meals.forEach((element) {
      mealsName += '${element.name}, ';
    });
    mealsName = mealsName.substring(0, mealsName.length - 2);
    return mealsName;
  }
}
