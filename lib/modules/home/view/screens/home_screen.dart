import 'dart:io';

import 'package:app/core/resources/resources.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/const_strings.dart';
import '../../../../core/view/widgets/app_dialog.dart';
import '../../../../core/view/widgets/default/app_buttons.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../../diary/controllers/diary_controller.dart';
import '../../../diary/views/diary_view.dart';
import '../../../sessions/views/sessions_view.dart';
import '../../cubits/home_cubit.dart';
import '../widgets/home_appbar.dart';
import '../widgets/home_bottom_navigation_bar.dart';
import '../widgets/home_drawer.dart';
import 'home_page_view.dart';

bool globalIsIosInReview = true;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  late final HomeCubit homeCubit;


  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
    // homeCubit.onInit(BlocProvider.of<DiaryCubit>(context));
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<HomeCubit>(context).response.value.forceUpdate)
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              height: deviceHeight / 3.4,
              child: Image.asset(
                AppImages.kLogoColumn,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 26),
            kTextHeader('Update required', size: 24),
            kTextHeader('${homeCubit.response.value.message}', paddingH: 20),
            SizedBox(height: 30),
            kButtonDefault(
              "Update",
              func: () async {
                String url = Platform.isAndroid
                    ? StringConst.PLAY_STORE
                    : StringConst.APP_STORE;
                bool canLaun = await canLaunch(url);
                if (canLaun) launch(url);
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      );
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            drawer: HomeDrawer(),
            body: Obx(
                  () => Column(
                children: [
                  HomeAppbar(
                    type: "home",
                  ),
                  Expanded(child: currentPage()),
                  // HomeBottomNavigationBar()
                ],
              ),
            ),
            bottomNavigationBar: HomeBottomNavigationBar(),
          ),
        ),
        onWillPop: () async {
          return _willPopCallback(context);
        });  }


  Future<bool> _willPopCallback(BuildContext context) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    appDialog(
      title: 'Are you sure you want to exit?',
      image: Icon(Icons.warning_amber_rounded, size: 50, color: Colors.grey),
      cancelAction: () {
        Get.back();
        FocusScope.of(Get.context!).requestFocus(FocusNode());
      },
      confirmAction: () {
        SystemNavigator.pop();
      },
      cancelText: 'No',
      confirmText: 'Yes',
    );

    return false;
  }

  Widget currentPage() {
    // return SizedBox();
    // final controller = Get.find<HomeController>(tag: 'home');
    if (homeCubit.currentIndex == 2) {
      return SessionsView();
    }
    if (homeCubit.currentIndex == 1) {
      return HomePageView();
    }
    // bool isReg = Get.isRegistered(tag: 'diary');
    // if (!isReg) Get.put(DiaryController(), tag: 'diary');

    return DiaryView();
  }
}

