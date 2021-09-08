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
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../home_page_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Container(
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
    ), onWillPop: _willPopCallback);
  }


  Future<bool> _willPopCallback() async {
    Get.defaultDialog(
      title: 'Exit',
      content: Text('Are you sure you want to exit?'),
      confirm: TextButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Text('Yes')),
      cancel: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('No')),
    );
    return false;

  }

  Widget currentPage() {
    final controller = Get.put(HomeController());
    if (controller.currentIndex == 2) {
      return SessionsView();
    }
    if (controller.currentIndex == 1) {
      return DiaryView();
    }
    return HomePageView();
  }
}
