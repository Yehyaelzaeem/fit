import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

class HomeAppbar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: Get.width,
        height: kToolbarHeight,
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 3,
            spreadRadius: 3,
            offset: Offset(3, 3),
          ),
        ]),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.NOTIFICATIONS);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.chat,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: SizedBox(width: 1)),
                  Image.asset(
                    kImgLogoIcon,
                  ),
                  SizedBox(width: 4),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        key: Key('DefaultTextStyle1'),
                        style: const TextStyle(fontFamily: 'appFont', color: Colors.black87),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'Fit over FAT',
                              textStyle: TextStyle(fontSize: 14),
                              colors: colorizeColors,
                            ),
                          ],
                        ),
                      ),
                      DefaultTextStyle(
                        key: Key('DefaultTextStyle2'),
                        style: const TextStyle(fontFamily: 'appFont', color: Colors.black87),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'Dr/ Ramy Mansour',
                              textStyle: TextStyle(fontSize: 10),
                              colors: colorizeColors,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox(width: 1)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.menu,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
