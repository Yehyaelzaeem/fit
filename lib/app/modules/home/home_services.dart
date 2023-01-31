import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeServices extends GetView<HomeController> {
  var sellectedIndex = 0.obs;

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
                        sellectedIndex.value = i;
                      },
                      child: Container(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 12),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: controller.selectedService.value == i
                                      ? kColorPrimary
                                      : Colors.black87,
                                  width: controller.selectedService.value == i
                                      ? 1
                                      : 0.02,
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
                                      color: const Color(0xFF414042)
                                          .withOpacity(0.35),
                                      offset: Offset(0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                ],
                              ),
                              child: Image.network(
                                "${controller.servicesList[i]}",
                                width: 50,
                                height: 40,
                              ),
                            ),
                            Expanded(
                              child: kTextbody(
                                controller.servicesList[i].title ?? "",
                                color: controller.selectedService.value == i
                                    ? kColorPrimary
                                    : Colors.black87,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment(-0.14, -1.0),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  width: Get.width / 2.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(64.0),
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
                      '${controller.servicesList[sellectedIndex.value].title}',
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
                  child: kTextbody(
                      '${controller.servicesList[sellectedIndex.value].title}',
                      align: TextAlign.start),
                ),
                Container(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl:
                        "${controller.servicesList[sellectedIndex.value].items![0].cover!.content}",
                    fadeInDuration: Duration(seconds: 2),
                    // errorWidget: (vtx, url, obj) {
                    //   return Image.network(
                    //     "https://img.pikbest.com/png-images/qianku/404-error-model_2369179.png",
                    //     width: double.infinity,
                    //     height: Get.height / 4,
                    //     fit: BoxFit.fitWidth,
                    //   );
                    // },
                    placeholder: (ctx, url) {
                      return CircularLoadingWidget();
                    },
                    fit: BoxFit.contain,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.ORIENTATION_REGISTER);
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                          color: kColorPrimary,
                          borderRadius: BorderRadius.circular(64),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ]),
                      child: kTextHeader('Orientation Registration',
                          size: 16,
                          color: Colors.white,
                          bold: true,
                          paddingH: 16,
                          paddingV: 4),
                    ),
                  ),
                ),
              ],
            ),

            // kButton(
            //   'Orientation Registration',
            //   textColor: Colors.white,
            //   color: kColorPrimary,
            //   paddingH: 4,
            //   paddingV: 4,
            //   marginV: 12,
            //   marginH: Get.width / 9,
            //   func: () {
            //     Get.toNamed(Routes.ORIENTATION_REGISTER);
            //   },
            // ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
