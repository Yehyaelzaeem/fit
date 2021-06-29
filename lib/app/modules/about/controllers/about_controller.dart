import 'package:app/app/utils/translations/strings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AboutController extends GetxController {
  // final response = new AboutResponse().obs;
  final error = ''.obs;
  var storage = GetStorage();

  String about = '<h1> Title </h1><p>${Strings().longText}</p>';
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
    //   response.value = await networkAbout();
    // } catch (e) {
    //   Echo('error response $e');
    //   error.value = '$e';
    // }
  }
}
