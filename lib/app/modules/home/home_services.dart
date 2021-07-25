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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Container(
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: controller.selectedService.value == i ? kColorPrimary : Colors.black87,
                                  width: controller.selectedService.value == i ? 1 : 0.02,
                                ),
                                boxShadow: [
                                  if (controller.selectedService.value == i)
                                    BoxShadow(
                                      color: kColorPrimary,
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: Offset(0, 0),
                                    ),
                                  if (controller.selectedService.value != i)
                                    BoxShadow(
                                      color: const Color(0xFF414042).withOpacity(0.35),
                                      offset: Offset(0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                ],
                              ),
                              child: Image.asset(
                                controller.servicesList[i].image,
                                color: kColorPrimary,
                                width: 50,
                                height: 40,
                              ),
                            ),
                            Expanded(
                              child: kTextbody(
                                controller.servicesList[i].name,
                                color: controller.selectedService.value == i ? kColorPrimary : Colors.black87,
                                bold: controller.selectedService.value == i,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Group: Group 783
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment(-0.14, -1.0),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              width: Get.width / 2.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(15.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF414042).withOpacity(0.35),
                    offset: Offset(0, 1.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Roof Workout',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: const Color(0xFF7FC902),
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
              kFitServices,
              width: double.infinity,
              height: Get.height / 4,
              fit: BoxFit.fitWidth,
            ),
            kButton(
              'Orientation Registration',
              textColor: Colors.white,
              color: kColorPrimary,
              paddingH: 4,
              paddingV: 4,
              marginV: 12,
              marginH: Get.width / 9,
              func: () {
                Get.toNamed(Routes.ORIENTATION_REGISTER);
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
