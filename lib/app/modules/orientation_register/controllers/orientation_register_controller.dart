import 'package:get/get.dart';

class OrientationRegisterController extends GetxController {
  //TODO: Implement OrientationRegisterController

  final selectedTarget = ''.obs;
  final selectedSocial = ''.obs;
  final count = 0.obs;
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
  void increment() => count.value++;
}
