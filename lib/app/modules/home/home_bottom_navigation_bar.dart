import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/utils/theme/app_colors.dart';
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
                height: 60,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      controller.currentIndex == 0
                          ? Icon(
                              Icons.home,
                              color: kColorPrimary,
                              size: 30,
                            )
                          : Icon(
                              Icons.home_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                      kTextbody('Home',
                          color: controller.currentIndex == 0 ? kColorPrimary : Colors.black87),
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
                height: 60,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      controller.currentIndex == 1
                          ? Icon(
                              Icons.receipt_long,
                              color: kColorPrimary,
                              size: 30,
                            )
                          : Icon(
                              Icons.receipt_long_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                      kTextbody('Diary',
                          color: controller.currentIndex == 1 ? kColorPrimary : Colors.black87),
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
                height: 60,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      controller.currentIndex == 2
                          ? Icon(
                              Icons.person,
                              color: kColorPrimary,
                              size: 30,
                            )
                          : Icon(
                              Icons.person_outline,
                              color: Colors.black,
                              size: 30,
                            ),
                      kTextbody('Sessions',
                          color: controller.currentIndex == 2 ? kColorPrimary : Colors.black87),
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
