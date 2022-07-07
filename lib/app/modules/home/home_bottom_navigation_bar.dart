import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBottomNavigationBar extends GetView<HomeController> {
  final controller = Get.find<HomeController>(tag: 'home');
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
              controller.currentIndex.value = 0;
            },
            child: Container(
              height: 60,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                    controller.currentIndex.value == 0
                        ? Image.asset(
                            "assets/img/notebook.png",
                            width: 30,
                            height: 30,
                          )
                        : Image.asset(
                            "assets/img/notebook1.png",
                            width: 30,
                            height: 30,
                          ),
                    kTextbody('Diary', color: controller.currentIndex.value == 0 ? kColorPrimary : Colors.black87),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              controller.currentIndex.value = 1;
            },
            child: Container(
              height: 60,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                    controller.currentIndex.value == 1
                        ? Image.asset(
                            "assets/img/home0.png",
                            width: 30,
                            height: 30,
                          )
                        : Image.asset(
                            "assets/img/home1.png",
                            width: 30,
                            height: 30,
                          ),
                    kTextbody(
                      'Home',
                      color: controller.currentIndex.value == 1 ? kColorPrimary : Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              controller.currentIndex.value = 2;
            },
            child: Container(
              height: 60,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                    controller.currentIndex.value == 2
                        ? Image.asset(
                            "assets/img/doctor0.png",
                            width: 30,
                            height: 30,
                          )
                        : Image.asset(
                            "assets/img/doctor.png",
                            width: 30,
                            height: 30,
                          ),
                    kTextbody('Sessions', color: controller.currentIndex.value == 2 ? kColorPrimary : Colors.black87),
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
