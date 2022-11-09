import 'package:app/app/utils/helper/echo.dart';
import 'package:get/get.dart';

class TimeSleepController extends GetxController {
  String ?selectedGender;
  final List<String> dayTime = ["From", "To"];

  String? select;
  void onClickRadioButton(value) {
    print(value);
    select = value;
    update();
  }
  final error = ''.obs;
  final loading = false.obs;
  @override
  void onInit() {
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
    } catch (e) {
      Echo('error response $e');
      error.value = '$e';
    }
    loading.value = false;
  }
}
