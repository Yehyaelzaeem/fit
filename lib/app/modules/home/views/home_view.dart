import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/home_bottom_navigation_bar.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/home/home_menu.dart';
import 'package:app/app/modules/home/home_services.dart';
import 'package:app/app/modules/home/home_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: HomeBottomNavigationBar(),
          drawer: HomeDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                HomeAppbar(),
                HomeSlider(sliders: controller.slider),
                HomeMenu(),
                HomeServices(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
