import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/home_bottom_navigation_bar.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/home/home_menu.dart';
import 'package:app/app/modules/home/home_services.dart';
import 'package:app/app/modules/home/home_slider.dart';
import 'package:app/app/modules/sessions/views/sessions_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          drawer: HomeDrawer(),
          body: Obx(
            () => Column(
              children: [
                HomeAppbar(),
                Expanded(
                  child: currentPage(),
                ),
                HomeBottomNavigationBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget currentPage() {
    if (controller.currentIndex == 2) {
      return SessionsView();
    }
    if (controller.currentIndex == 1) {
      return DiaryView();
    } 
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeSlider(sliders: controller.slider),
          HomeMenu(),
          HomeServices(),
        ],
      ),
    );
  }
}
