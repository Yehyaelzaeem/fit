import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../controllers/introduction_screen_controller.dart';

class IntroductionScreenView extends GetView<IntroductionScreenController> {
  final PageDecoration pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    contentMargin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    //bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 30,
        // title: Obx(() => GestureDetector(
        //     onTap: () {
        //       controller.changeLang();
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(4.0),
        //       child: Text(
        //         controller.lang.value,
        //         style: TextStyle(fontSize: 12, color: Colors.grey),
        //       ),
        //     ))),
      ),
      body: Obx(
        () => Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 16),
          child: IntroductionScreen(
            rtl: controller.lang.value.contains('عربي') ? true : false,
            pages: [
              ...controller.walkThroughList.map((singleItem) {
                return PageViewModel(
                  titleWidget: kTextHeader(singleItem.title),
                  bodyWidget: kTextbody(singleItem.content),
                  image: Image.asset('${singleItem.imageUrl}',
                      width: Get.width / 1.2),
                  decoration: pageDecoration,
                );
              }).toList(),
            ],
            onDone: () => controller.onDone(),
            onSkip: () => controller.onDone(),
            showSkipButton: true,
            //skipFlex: 0,
            // skipOrBackFlex: 0,
            nextFlex: 0,
            skip: kTextbody(Strings().skip),
            next: Icon(
              controller.lang.value.contains('Englis')
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
              color: Colors.black87,
            ),
            done: kTextbody(Strings().gotIt, bold: true),
            dotsDecorator: DotsDecorator(
              size: Size(10.0, 10.0),
              activeColor: kColorPrimary,
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
