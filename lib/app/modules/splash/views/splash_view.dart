import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
                      AnimationConfiguration.staggeredList(
                        position: 1,
                        duration: Duration(seconds: 1),
                        child: SlideAnimation(
                          verticalOffset: 375.0,
                          child: FadeInAnimation(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 100),
                              child: Image.asset(
                                kLogoColumn,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // AnimationConfiguration.staggeredList(
                      //   position: 1,
                      //   duration: Duration(seconds: 2),
                      //   child: SlideAnimation(
                      //     horizontalOffset: 500.0,
                      //     child: FadeInAnimation(
                      //       child:Text(
                      //         " Dr/ Ramy Mansour",
                      //         style: TextStyle(color: Colors.black87, fontSize: 18),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        width: Get.width,
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'appFont',
                                color: Colors.white),
                            child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText('                     ',
                                    speed: Duration(milliseconds: 45)),
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
            ],
          ),
        ),
      )),
    );
  }
}
