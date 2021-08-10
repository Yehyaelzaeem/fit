import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/sessions/controllers/sessions_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final selectedService = 0.obs;
  final currectMenuIdex = 1.obs;
  final homeResponse = HomePageResponse().obs;

  RxList<String> slider = RxList();
  RxList<Services> servicesList = RxList();

  @override
  void onInit() async {
    homeResponse.value = await ApiProvider().getHomeData();
    Get.put(SessionsController(), tag: 'SessionsController');
    Get.put(DiaryController(), tag: 'DiaryController');

    super.onInit();
    homeResponse.value.data!.slider!.forEach((v) {
      slider.add(v.image ??
          "https://dev.matrixclouds.com/fitoverfat/public/uploads/choose_us/1627982041Cover.jpg");
    });
    print(slider);
    homeResponse.value.data!.services!.forEach((v) {
      servicesList.add(Services(id: v.id, title: v.title, items: v.items));
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void updateCurrentIndex(int value) {
    currentIndex.value = value;
  }
}
