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
    print(controller.isToday);
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
                  child: GetBuilder<TimeSleepController>(
                      builder: (_) => Column(
                            children: [
                              //App bar
                              HomeAppbar(),
                              SizedBox(height: 12),
                              PageLable(name: "Sleep Time"),
                              SizedBox(height: Get.height * 0.02),
                              Container(
                                height: MediaQuery.of(context).size.height *0.33,
                                width: MediaQuery.of(context).size.width,
                                child: simpleClock,
                              ),
                              SizedBox(height: Get.height * 0.1),
                              myTileRadioButton(
                                btnIndex: 0,
                                context: context,
                                title: "From",
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
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
                                      kTextHeader(
                                          controller.selectedTimeFrom
                                              .format(context)
                                              .split(" ")
                                              .first,
                                          size: 24,
                                          bold: true),
                                      SizedBox(width: 20),
                                      buildTimeFromAMorPM(context),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                                onTap: () => controller.selectTimeFrom(context),
                              ),
                              SizedBox(height: 12),
                              myTileRadioButton(
                                context: context,
                                title: "To    ",
                                btnIndex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
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
                                      kTextHeader(
                                        controller.selectedTimeTo
                                            .format(context)
                                            .split(" ")
                                            .first,
                                        size: 24,
                                        bold: true,
                                      ),
                                      SizedBox(width: 20),
                                      buildTimeToAMorPM(context),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                                onTap: () => controller.selectTimeTo(context),
                              ),
                              SizedBox(height: 20),
                              kButtonDefault("Submit",
                                  color: kColorPrimary,
                                  textColor: Colors.white,
                                  border: Border.all(
                                    color: Color(0xffF1F1F1),
                                    width: 1,
                                  ), func: () {
                                     controller.addSleepTime(
                                  sleepTimeFrom:
                                  controller.selectedTimeFrom.format(context),
                                  sleepTimeTo:
                                  controller.selectedTimeTo.format(context),
                                );
                              }),
                              SizedBox(height: 20),
                            ],
                          )),
                );
              },
            )),
      ),
    );
  }

  Widget buildTimeFromAMorPM(context) {
    return Container(
        color: kColorPrimary.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: EdgeInsets.all(2),
        child: kTextHeader(
            controller.selectedTimeFrom.format(context).split(" ").last,
            size: 24));
  }

  Widget buildTimeToAMorPM(context) {
    return Container(
        color: kColorPrimary.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: EdgeInsets.all(2),
        child: kTextHeader(
            controller.selectedTimeTo.format(context).split(" ").last,
            size: 24));
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
      //  key: const GlobalObjectKey(1),
      );

  Widget myTileRadioButton(
      {required int btnIndex,
      required String title,
      required BuildContext context,
      required Widget child,
      required Function()? onTap}) {
    return GetBuilder<TimeSleepController>(
      builder: (_) => InkWell(
        onTap: onTap,
        child: Container(
          child: RadioListTile(
            value: controller.dayTime[btnIndex],
            groupValue: controller.select,
            activeColor: kColorPrimary,
            onChanged: (value) {
              controller.onClickRadioButton(value);
              value == "From"
                  ? controller.selectTimeFrom(context)
                  : controller.selectTimeTo(context);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                kTextHeader(title,
                    align: TextAlign.start, paddingH: 0, size: 22),
                child,
                SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
