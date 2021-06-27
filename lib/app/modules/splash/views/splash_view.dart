import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: Scaffold(
          body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        kImgLogoWhiteNoBk,
                        width: Get.width / 2,
                      ),
                      Container(
                        width: Get.width,
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(fontSize: 18.0, fontFamily: 'appFont', color: Colors.black87),
                            child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText('Dr/ Ramy Mansour', speed: Duration(milliseconds: 60)),
                              ],
                              onFinished: () {
                                controller.navigateNextPage();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Get.height / 20),
                child: Center(child: CircularLoadingWidget(white: false)),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
