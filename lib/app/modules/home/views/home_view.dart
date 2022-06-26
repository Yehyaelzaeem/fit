import 'dart:io';

import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/home_bottom_navigation_bar.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/sessions/views/sessions_view.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../home_page_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return Scaffold(body: CircularLoadingWidget());
      if (controller.response.value.forceUpdate)
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 26),
              kTextHeader('Update required', size: 24),
              kTextHeader('${controller.response.value.message}', paddingH: 20),
              SizedBox(height: 26),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 100),
                height: Get.height / 5,
                child: Image.asset(
                  kLogoColumn,
                  width: double.infinity,
                ),
              ),
              kButtonDefault(
                "Update",
                func: () async {
                  String url = Platform.isAndroid ? StringConst.PLAY_STORE : StringConst.APP_STORE;
                  bool canLaun = await canLaunch(url);
                  if (canLaun) launch(url);
                },
              ),
            ],
          ),
        );
      return WillPopScope(child: Container(child: SafeArea(child: Scaffold(drawer: HomeDrawer(), body: Obx(() => Column(children: [HomeAppbar(type: "home"), Expanded(child: currentPage()), HomeBottomNavigationBar()]))))), onWillPop: _willPopCallback);
    });
  }

  Future<bool> _willPopCallback() async {
    Get.defaultDialog(
      title: 'Exit',
      content: Text('Are you sure you want to exit?'),
      confirm: TextButton(onPressed: () => SystemNavigator.pop(), child: Text('Yes')),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('No')),
    );
    return false;
  }

  Widget currentPage() {
    final controller = Get.put(HomeController());
    if (controller.currentIndex == 2) {
      return SessionsView();
    }
    if (controller.currentIndex == 1) {
      return HomePageView();
    }
    return DiaryView();
  }
}
