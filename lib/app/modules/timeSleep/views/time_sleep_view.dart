import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/time_sleep_controller.dart';

class TimeSleepView extends GetView<TimeSleepController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(
              () {
                if (controller.loading.value) return Center(child: CircularLoadingWidget());

                if (controller.error.value.isNotEmpty) return errorHandler(controller.error.value, controller);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      //App bar
                      HomeAppbar(),
                      SizedBox(height: 12),
                      PageLable(name: "Sleep Time"),
                      Container(
                        height: Get.height / 2.4,
                        width: Get.width,
                        child: CupertinoTimerPicker(
                          onTimerDurationChanged: (value) {},
                          mode: CupertinoTimerPickerMode.hm,
                        ),
                      ),
                    
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Radio(value: 'from', groupValue: 'from', onChanged: (val) {}),
                          SizedBox(width: 4),
                          kTextHeader('From', align: TextAlign.start, paddingH: 0, size: 22),
                          SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ]),
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                kTextHeader("12:00", size: 26, bold: true),
                                SizedBox(width: 24),
                                Column(
                                  children: [
                                    Container(color: kColorPrimary.withOpacity(0.5), padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), margin: EdgeInsets.all(2), child: kTextHeader("AM", size: 24)),
                                    kTextHeader("PM", size: 24),
                                  ],
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),

                      SizedBox(height: 12),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Radio(value: 'To', groupValue: 'from', onChanged: (val) {}),
                          SizedBox(width: 4),
                          kTextHeader('To     ', align: TextAlign.start, paddingH: 0, size: 22),
                          SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ]),
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                kTextHeader("12:00", size: 26, bold: true),
                                SizedBox(width: 24),
                                Column(
                                  children: [
                                    Container(color: kColorPrimary.withOpacity(0.5), padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), margin: EdgeInsets.all(2), child: kTextHeader("AM", size: 24)),
                                    kTextHeader("PM", size: 24),
                                  ],
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
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
