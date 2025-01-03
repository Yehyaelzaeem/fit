
import 'package:get/get.dart';

import '../../../core/models/my_orders_response.dart';
import '../../../core/services/api_provider.dart';

class OrdersController extends GetxController {
  // final GlobalController globalController =
  //     Get.find<GlobalController>(tag: 'global');

  final List<Completed> pending=[];
  final List<Completed> completed=[];
  final response = MyOrdersResponse(code: 200, success: false, data: null).obs;
  final error = ''.obs;
  final selectedTap = 2.obs;

  final loading = false.obs;
  final requiredAuth = false.obs;
  final getMyMealsLoading = false.obs;
  filter({required MyOrdersResponse response}){
    print("Pending list => ${pending.length}");
    pending.addAll(
        response.data!.pending.toList());
    print("Pending list => ${pending.length}");
    print("Completed list => ${completed.length}");
    completed.addAll(
        response.data!.completed.toList());
    print("Completed list => ${completed.length}");
  }
  @override
  void onInit() async {
    getNetworkData();
    super.onInit();
  }

  getNetworkData() async {
    if (requiredAuth.value) return;
    error.value = '';
    getMyMealsLoading.value = true;
    loading.value=false;
    try {
      response.value = await ApiProvider().myOrders();
      filter(response: response.value,);
      loading.value=true;
      update();
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

