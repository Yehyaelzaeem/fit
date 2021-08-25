import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/models/user_response.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/sessions/controllers/sessions_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final selectedService = 0.obs;
  final currectMenuIdex = 1.obs;
  final homeResponse = HomePageResponse().obs;
  final userData = UserResponse().obs;

  RxList<String> slider = RxList();
  RxList<Services> servicesList = RxList();
  var name = "".obs;
  var phone = "".obs;
  var avatar = "".obs;
  var isLogggd = false.obs;
  var id = "".obs;

  @override
  void onInit() async {
    isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    name.value = await SharedHelper().readString(CachingKey.USER_NAME);
    avatar.value = await SharedHelper().readString(CachingKey.AVATAR);
    id.value = await SharedHelper().readString(CachingKey.USER_ID);

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
