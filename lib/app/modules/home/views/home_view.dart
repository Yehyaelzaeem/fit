import 'dart:io';

import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/home_bottom_navigation_bar.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/sessions/views/sessions_view.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/widgets/app_dialog.dart';
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
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return Scaffold(body: Container(child: CircularLoadingWidget()));
      if (controller.response.value.forceUpdate)
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: Get.height / 3.4,
                child: Image.asset(
                  kLogoColumn,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 26),
              kTextHeader('Update required', size: 24),
              kTextHeader('${controller.response.value.message}', paddingH: 20),
              SizedBox(height: 30),
              kButtonDefault(
                "Update",
                func: () async {
                  String url = Platform.isAndroid ? StringConst.PLAY_STORE : StringConst.APP_STORE;
                  bool canLaun = await canLaunch(url);
                  if (canLaun) launch(url);
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        );
      return WillPopScope(
          child: Container(
            child: SafeArea(
              child: Scaffold(
                drawer: HomeDrawer(),
                body: Obx(
                  () => Column(
                    children: [
                      HomeAppbar(
                        type: "home",
                      ),
                      Expanded(child: currentPage()),
                      HomeBottomNavigationBar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onWillPop: _willPopCallback);
    });
  }

  Future<bool> _willPopCallback() async {
    appDialog(
      title: 'Are you sure you want to exit?',
      image: Icon(Icons.warning_amber_rounded, size: 50, color: Colors.grey),
      cancelAction: () {
        Get.back();
      },
      confirmAction: () {
        SystemNavigator.pop();
      },
      cancelText: 'No',
      confirmText: 'Yes',
    );

    return false;
  }

  Widget currentPage() {
    final controller = Get.find<HomeController>(tag: 'home');
    if (controller.currentIndex == 2) {
      return SessionsView();
    }
    if (controller.currentIndex == 1) {
      return HomePageView();
    }
    bool isReg = Get.isRegistered(tag: 'diary');
    if (!isReg) Get.put(DiaryController(), tag: 'diary');

    return DiaryView();
  }
}
