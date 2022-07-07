import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeMenu extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(color: kColorAccent, borderRadius: BorderRadius.circular(64), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ]),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  controller.currectMenuIdex.value = 1;
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: controller.currectMenuIdex.value == 1 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: kTextHeader(
                    Strings().services,
                    color: controller.currectMenuIdex.value == 1 ? kColorPrimary : Colors.white,
                    bold: controller.currectMenuIdex.value == 1,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  controller.currectMenuIdex.value = 2;
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: controller.currectMenuIdex.value == 2 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: kTextHeader(
                    Strings().courses,
                    color: controller.currectMenuIdex.value == 2 ? kColorPrimary : Colors.white,
                    bold: controller.currectMenuIdex.value == 2,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  controller.currectMenuIdex.value = 3;
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: controller.currectMenuIdex.value == 3 ? Colors.white : null,
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: kTextHeader(
                    Strings().blog,
                    color: controller.currectMenuIdex.value == 3 ? kColorPrimary : Colors.white,
                    bold: controller.currectMenuIdex.value == 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
