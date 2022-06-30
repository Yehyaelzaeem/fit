import 'dart:io';

import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/home_bottom_navigation_bar.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/sessions/views/sessions_view.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      return WillPopScope(child: Container(child: SafeArea(child: Scaffold(drawer: HomeDrawer(), body: Obx(() => Column(children: [HomeAppbar(type: "home"), Expanded(child: currentPage()), HomeBottomNavigationBar()]))))), onWillPop: _willPopCallback);
    });
  }

  Future<bool> _willPopCallback() async {
    Get.defaultDialog(
      title: 'Exit',
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          color: Color(0xffF6F6F6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 3,
              spreadRadius: 1,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Text('Are you sure you want to exit?'),
      ),
      confirm: GestureDetector(
        onTap: () {
          SystemNavigator.pop();
        },
        child: Container(
          width: Get.width / 5,
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kColorPrimary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Yes',
                style: GoogleFonts.cairo(
                  fontSize: 14.0,
                  color: const Color(0xFF7FC902),
                ),
              ),
            ],
          ),
        ),
      ),
      cancel: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: Get.width / 5,
          margin: EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kColorPrimary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'No',
                style: GoogleFonts.cairo(
                  fontSize: 14.0,
                  color: const Color(0xFF7FC902),
                ),
              ),
            ],
          ),
        ),
      ),
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
