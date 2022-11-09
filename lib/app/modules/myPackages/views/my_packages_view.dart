import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/myPackages/controllers/my_packages_controller.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPackagesView extends GetView<MyPackagesController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(
              () {
                if (controller.loading.value)
                  return Center(child: CircularLoadingWidget());

                if (controller.error.value.isNotEmpty)
                  return errorHandler(controller.error.value, controller);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      //App bar
                      HomeAppbar(),
                      SizedBox(height: 12),
                      PageLable(name: " My Packages"),
                      SizedBox(height: 12),
                      Container(
                        color: Color(0xffF1F1F1),
                        child: Column(
                          children: [
                            SizedBox(height: 18),
                            Row(
                              children: [
                                kTextHeader('Physiotherapy',
                                    color: kColorPrimary,
                                    bold: true,
                                    paddingH: 12,
                                    size: 20),
                                Spacer(),
                                kTextHeader('150 L.E',
                                    color: Colors.black,
                                    bold: true,
                                    paddingH: 12,
                                    size: 20),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                kTextHeader('03/06/2022', paddingH: 12),
                                Spacer(),
                                kTextHeader('1 Month',
                                    color: Colors.black, paddingH: 12),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: kColorPrimary),
                                kTextHeader("Completed payment",
                                    color: kColorPrimary),
                              ],
                            ),
                            SizedBox(height: 18),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        color: Color(0xffF1F1F1),
                        child: Column(
                          children: [
                            SizedBox(height: 18),
                            Row(
                              children: [
                                kTextHeader('Physiotherapy',
                                    color: kColorPrimary,
                                    bold: true,
                                    paddingH: 12,
                                    size: 20),
                                Spacer(),
                                kTextHeader('150 L.E',
                                    color: Colors.black,
                                    bold: true,
                                    paddingH: 12,
                                    size: 20),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                kTextHeader('03/06/2022', paddingH: 12),
                                Spacer(),
                                kTextHeader('1 Month',
                                    color: Colors.black, paddingH: 12),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: kColorPrimary),
                                kTextHeader("Completed payment",
                                    color: kColorPrimary),
                              ],
                            ),
                            SizedBox(height: 18),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.SUBSCRIBE, arguments: null);
                        },
                        child: Center(
                          child: Container(
                            width: Get.width / 1.4,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Color(0xffFFB62B),
                              borderRadius: BorderRadius.circular(64),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/img/premium.png',
                                  width: 30,
                                  height: 30,
                                ),
                                kTextHeader('Subscribe new package',
                                    size: 16,
                                    color: Colors.white,
                                    bold: true,
                                    paddingH: 16,
                                    paddingV: 4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
