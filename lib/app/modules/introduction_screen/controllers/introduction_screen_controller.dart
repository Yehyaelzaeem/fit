import 'dart:ui';

import 'package:app/app/data/database/shared_pref.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:get/get.dart';

class IntroductionScreenController extends GetxController {
  final lang = ''.obs;
  YemenyPrefs prefs = YemenyPrefs();

  RxList<WalkThrough> walkThroughList = RxList();

  init() {
    walkThroughList.clear();
    walkThroughList.add(WalkThrough(
      title: Strings().walkThroughTitle1,
      content: Strings().walkThroughBody1,
      imageUrl: kImgIntro1,
    ));
    walkThroughList.add(WalkThrough(
      title: Strings().walkThroughTitle2,
      content: Strings().walkThroughBody2,
      imageUrl: kImgIntro2,
    ));
    walkThroughList.add(WalkThrough(
      title: Strings().walkThroughTitle3,
      content: Strings().walkThroughBody3,
      imageUrl: kImgIntro3,
    ));
  }

  changeLang() {
    YemenyPrefs prefs = YemenyPrefs();
    String? lg = prefs.getLanguage();
    if (lg == null || lg.contains('ar')) {
      lang.value = 'عربي';
      prefs.setLanguage('en');
      Get.updateLocale(Locale('en'));
    } else {
      lang.value = 'English';
      prefs.setLanguage('ar');
      Get.updateLocale(Locale('ar'));
    }
    init();
  }

  @override
  void onInit() {
    YemenyPrefs prefs = YemenyPrefs();
    String? lg = prefs.getLanguage();
    if (lg == null || lg.contains('ar')) {
      lang.value = 'English';
    } else {
      lang.value = 'عربي';
    }

    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void onDone() async {
    prefs.setFirstTimeVisit(false);

    if (prefs.getToken() == null || prefs.getToken()!.isEmpty) {
      // Get.offAllNamed(Routes.AUTH);
      Get.toNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}

class WalkThrough {
  final title;
  final content;
  final imageUrl;

  WalkThrough({
    this.title,
    this.content,
    this.imageUrl,
  });
}
