import 'package:analog_clock/analog_clock.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/time_sleep_controller.dart';

class TimeSleepView extends GetView<TimeSleepController> {
  DateTime dateTime = DateTime.now();

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
                      PageLable(name: "Sleep Time"),
                      SizedBox(height: Get.height * 0.02),
                      Container(
                        height: Get.height / 3,
                        width: Get.width,
                        child: simpleClock,
                      ),
                      SizedBox(height: Get.height * 0.1),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          myRadioButton(0, "From"),
                          SizedBox(width: 28),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
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
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Container(
                                        color: kColorPrimary.withOpacity(0.5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        margin: EdgeInsets.all(2),
                                        child: kTextHeader("AM", size: 24)),
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
                          myRadioButton(1, "To     "),
                          SizedBox(width: 28),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
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
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Container(
                                        color: kColorPrimary.withOpacity(0.5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        margin: EdgeInsets.all(2),
                                        child: kTextHeader("AM", size: 24)),
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

                      kButtonDefault("Submit",
                          color: kColorPrimary,
                          textColor: Colors.white,
                          border: Border.all(
                            color: Color(0xffF1F1F1),
                            width: 1,
                          ), func: () {
                          }),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }


  Widget get simpleClock => AnalogClock(
        decoration: BoxDecoration(
          color: clockColor,
          shape: BoxShape.circle,
        ),
        isLive: true,
        hourHandColor: ACCENT_COLOR_DARK,
        minuteHandColor: ACCENT_COLOR_DARK,
        showSecondHand: true,
        secondHandColor: PRIMART_COLOR,
        numberColor: ACCENT_COLOR_DARK,
        showNumbers: true,
        textScaleFactor: 1.4,
        showTicks: true,
        showDigitalClock: false,
        datetime: dateTime,
        key: const GlobalObjectKey(1),
      );
  Widget myRadioButton(int btnIndex, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GetBuilder<TimeSleepController>(
          builder: (_) => Radio(
              activeColor: kColorPrimary,
              value: controller.dayTime[btnIndex],
              groupValue: controller.select,
              onChanged: (value) =>
                  controller.onClickRadioButton(value)),
        ),
        kTextHeader(title,
            align: TextAlign.start, paddingH: 0, size: 22),
      ],
    );
  }
}
