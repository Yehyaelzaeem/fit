import 'package:app/app/models/faq_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  final faqResponse = FaqResponse().obs;
  final selectedFaq = 0.obs;

  @override
  Future<void> onInit() async {
    faqResponse.value = await ApiProvider().getFaqtData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
