import 'package:app/app/models/about_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AboutController extends GetxController {
  final aboutResponse = AboutResponse().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    aboutResponse.value = await ApiProvider().getAboutData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

}
