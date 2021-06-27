import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
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

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: controller.currentIndex.value,
      fixedColor: Colors.white,
      backgroundColor: kColorPrimary,
      unselectedItemColor: Colors.white70,
      onTap: controller.updateCurrentIndex,
      items: [
        
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: Strings().home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: Strings().diary,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: Strings().sessions,

        ),
      ],
    );
  }
}
