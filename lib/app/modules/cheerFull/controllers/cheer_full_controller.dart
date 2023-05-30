import 'package:app/app/models/cheerful_response.dart';
import 'package:app/app/models/meal_features_status_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/globale_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../network_util/shared_helper.dart';

class CheerFullController extends GetxController {
  final GlobalController globalController =
      Get.find<GlobalController>(tag: 'global');

  final response = MealFeatureHomeResponse().obs;
  final error = ''.obs;
  final loading = false.obs;
  final isLoading = true.obs;
  bool isGuest = false;
  bool isGuestSaved = false;
  String userId = "";
  CheerfulSocialsResponse cheerfulSocialsResponse = CheerfulSocialsResponse();

  void getData() async {
    await ApiProvider().getCheerfulSocialsResponse().then((value) {
      if (value.success == true) {
        cheerfulSocialsResponse = value;
        isLoading.value = false;
      } else {
        Fluttertoast.showToast(msg: "Something went wrong!");
        print("error");
      }
    });
  }

  @override
  void onInit() async {
    getNetworkData();
    getData();
    userId = await SharedHelper().readString(CachingKey.USER_ID);
    isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
    isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {
      response.value = await ApiProvider().getMealFeaturesHome();
      globalController.mealFeatureHomeResponse.value = response.value;
    } catch (e) {
      Echo('error response $e');
      error.value = '$e';
    }
    loading.value = false;
  }
}
