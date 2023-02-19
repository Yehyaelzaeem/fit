import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/models/user_response.dart';
import 'package:app/app/models/version_response.dart';
import 'package:app/app/modules/sessions/controllers/sessions_controller.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/cheer_full_response.dart';
import '../../../utils/helper/echo.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final selectedService = 0.obs;
  final currectMenuIdex = 1.obs;
  final homeResponse = HomePageResponse().obs;
  final userData = UserResponse().obs;
  final cheerfulResponse = CheerFullResponse().obs;
  late bool login = false;

  //bool cheerFullStatus = false;
  // bool faqStatus = false;
  bool? orientationStatus;
  bool? faqStatus;
  RxList<String> slider = RxList();
  RxList<Services> servicesList = RxList();
  var name = "".obs;
  var lastName = "".obs;
  var phone = "".obs;
  var avatar = "".obs;
  var isLogggd = false.obs;
  var id = "".obs;
  late int newMessage = 0;
  final response =
      VersionResponse(success: false, code: 0, message: "", forceUpdate: false)
          .obs;
  final loading = false.obs;
  UserResponse ress = UserResponse();
  SharedPreferences? preferences;
  @override
  void onInit() async {
    await SharedHelper().removeData(CachingKey.INVOICE);

    isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    name.value = await SharedHelper().readString(CachingKey.USER_NAME);
    phone.value = await SharedHelper().readString(CachingKey.PHONE);
    avatar.value = await SharedHelper().readString(CachingKey.AVATAR);
    id.value = await SharedHelper().readString(CachingKey.USER_ID);
    login = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    lastName.value = await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    cheerfulResponse.value = await ApiProvider().getCheerFullStatus();
    homeResponse.value = await ApiProvider().getHomeData();
    orientationStatus = await ApiProvider().getOrientationVideosStatusStatus();
    faqStatus = await ApiProvider().getFaqStatus();
    if (homeResponse.value.success == false && homeResponse.value.code == 401) {
      SharedHelper().logout();
      Get.offAllNamed(Routes.SPLASH);
    }
    Get.put(SessionsController(), tag: 'SessionsController');
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

  void refreshController(bool getNeworkData) async {
    isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    name.value = await SharedHelper().readString(CachingKey.USER_NAME);
    id.value = await SharedHelper().readString(CachingKey.USER_ID);
    lastName.value = await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    avatar.value = await SharedHelper().readString(CachingKey.AVATAR);
    login = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    homeResponse.value = await ApiProvider().getHomeData();
  }

  @override
  void onReady() {
    getNetworkData();
    super.onReady();
  }

  @override
  void onClose() {}

  void updateCurrentIndex(int value) {
    currentIndex.value = value;
  }

  void getNetworkData() async {
    try {
      response.value = await ApiProvider().kAppVersion();
    } catch (e) {}
  }
}
