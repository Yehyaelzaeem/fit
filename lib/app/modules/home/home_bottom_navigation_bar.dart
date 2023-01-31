import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeBottomNavigationBar extends GetView<HomeController> {
  final textEditController = Get.find<HomeController>(tag: 'home');

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
          InkWell(
            onTap: () {
              textEditController.currentIndex.value = 0;
              final controllerDiary = Get.find<DiaryController>(tag: 'diary');
              controllerDiary.onInit();
            },
            child: Container(
              height: 60,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                    textEditController.currentIndex.value == 0
                        ? SvgPicture.asset(
                            "assets/icons/notebook1.svg",
                            width: 30,
                            height: 30,
                          )
                        : SvgPicture.asset(
                            "assets/icons/notebook.svg",
                            width: 30,
                            height: 30,
                          ),
                    kTextbody('Diary',
                        color: textEditController.currentIndex.value == 0
                            ? kColorPrimary
                            : Colors.black87),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              textEditController.currentIndex.value = 1;
            },
            child: Container(
              height: 60,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                    textEditController.currentIndex.value == 1
                        ? SvgPicture.asset(
                            "assets/icons/home1.svg",
                            width: 30,
                            height: 30,
                          )
                        : SvgPicture.asset(
                            "assets/icons/home.svg",
                            width: 30,
                            height: 30,
                          ),
                    kTextbody(
                      'Home',
                      color: textEditController.currentIndex.value == 1
                          ? kColorPrimary
                          : Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              textEditController.currentIndex.value = 2;
            },
            child: Container(
              height: 60,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                    textEditController.currentIndex.value == 2
                        ? SvgPicture.asset(
                            "assets/icons/doctor.svg",
                            width: 30,
                            height: 30,
                          )
                        : SvgPicture.asset(
                            "assets/icons/doctor1.svg",
                            width: 30,
                            height: 30,
                          ),
                    kTextbody('Sessions',
                        color: textEditController.currentIndex.value == 2
                            ? kColorPrimary
                            : Colors.black87),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
