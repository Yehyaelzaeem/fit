import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBottomNavigationBar extends GetView<HomeController> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: CircularNotchedRectangle(),
        child: buildBottomNavigationBar(),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(top: 3),
      padding: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                controller.currentIndex.value = 0;
              },
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(controller.currentIndex == 0 ? kHomePrimary : kHomeBlack, height: 35),
                      kTextbody('Home', color: controller.currentIndex == 0 ? kColorPrimary : Colors.black87),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                controller.currentIndex.value = 1;
              },
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(controller.currentIndex == 1 ? kDiaryPrimary : kDiaryBlack, height: 35),
                      kTextbody('Diary', color: controller.currentIndex == 1 ? kColorPrimary : Colors.black87),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                controller.currentIndex.value = 2;
              },
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(controller.currentIndex == 2 ? kSessionsDiary : kSessionsBlack, height: 35),
                      kTextbody('Serssions', color: controller.currentIndex == 2 ? kColorPrimary : Colors.black87),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
