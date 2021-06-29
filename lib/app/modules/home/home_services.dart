import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeServices extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (int i = 0; i < controller.servicesList.length; i++)
                    GestureDetector(
                      onTap: () {
                        controller.selectedService.value = i;
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: controller.selectedService.value == i ? kColorPrimary : Colors.black87,
                                width: controller.selectedService.value == i ? 1 : 0.4,
                              ),
                              boxShadow: [
                                if (controller.selectedService.value == i)
                                  BoxShadow(
                                    color: kColorPrimary,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(0, 0),
                                  ),
                              ],
                            ),
                            child: Icon(
                              controller.servicesList[i].icon,
                              color: kColorPrimary,
                              size: 32,
                            ),
                          ),
                          kTextbody(
                            controller.servicesList[i].name,
                            color: controller.selectedService.value == i ? kColorPrimary : Colors.black87,
                            bold: controller.selectedService.value == i,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(8),
              color: Colors.grey[300],
              width: double.infinity,
              child: kTextbody(Strings().longText, align: TextAlign.start),
            ),
            Image.asset(
              kImgTestSlider,
              width: double.infinity,
              height: Get.height / 4,
              fit: BoxFit.cover,
            ),
            kButtonDefault(
              'Prientation Registration',
              textColor: Colors.white,
              color: kColorPrimary,
              paddingH: 8,
              paddingV: 0,
              func: () {
                Get.toNamed(Routes.ORIENTATION_REGISTER);
              },
            )
          ],
        ),
      ),
    );
  }
}
