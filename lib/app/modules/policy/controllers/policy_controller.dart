import 'package:app/app/utils/translations/strings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PolicyController extends GetxController {
  // final response = new PolicyResponse().obs;
  final error = ''.obs;
  var storage = GetStorage();

  String policy = '<h1> Title </h1><p>${Strings().longText}</p>';

  @override
  void onInit() {
    super.onInit();

    // getNetworkData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getNetworkData() async {
    // error.value = '';
    // try {
    //   response.value = await networkPolicy();
    // } catch (e) {
    //   Echo('error response $e');
    //   error.value = '$e';
    // }
  }
}
