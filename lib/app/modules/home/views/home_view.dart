import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/home_blog.dart';
import 'package:app/app/modules/home/home_bottom_navigation_bar.dart';
import 'package:app/app/modules/home/home_courses.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/home/home_menu.dart';
import 'package:app/app/modules/home/home_slider.dart';
import 'package:app/app/modules/sessions/views/sessions_view.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../home_page_view.dart';
import '../controllers/home_controller.dart';
import '../home_services.dart';

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
                HomeAppbar(type: "home",),
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
    return HomePageView();
  }
}
