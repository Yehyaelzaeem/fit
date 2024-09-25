import 'package:analog_clock/analog_clock.dart';
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_values.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../cubits/time_sleep_cubit.dart';

class TimeSleepView extends StatefulWidget {
  TimeSleepView({required this.isToday});

  final isToday;


  @override
  State<TimeSleepView> createState() => _TimeSleepViewState();
}

class _TimeSleepViewState extends State<TimeSleepView> {

  late final TimeSleepCubit timeSleepCubit;


  @override
  void initState() {
    super.initState();
    timeSleepCubit = BlocProvider.of<TimeSleepCubit>(context);
    timeSleepCubit.onInit( BlocProvider.of<DiaryCubit>(context));
  }
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
                if (timeSleepCubit.loading.value)
                  return Center(child: CircularLoadingWidget());
                if (timeSleepCubit.error.value.isNotEmpty)
                  return errorHandler(timeSleepCubit.error.value, timeSleepCubit);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          //App bar
                          HomeAppbar(),
                          SizedBox(height: 12),
                          PageLable(name: "Sleep Time"),
                          SizedBox(height: deviceHeight * 0.02),
                          Container(
                            height:
                            MediaQuery.of(context).size.height * 0.33,
                            width: MediaQuery.of(context).size.width,
                            child: simpleClock,
                          ),
                          SizedBox(height: deviceHeight * 0.1),
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
                                      timeSleepCubit.selectedTimeFrom
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
                            onTap: () => timeSleepCubit.selectTimeFrom(context).then((value){
                              setState(() {

                              });
                            }),
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
                                    timeSleepCubit.selectedTimeTo
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
                            onTap: () => timeSleepCubit.selectTimeTo(context).then((value) {
                              setState(() {

                              });
                            }),
                          ),
                          SizedBox(height: 20),],
                      ),
                      kButton(" Submit ",
                          color: kColorPrimary,
                          textColor: Colors.white,
                          loading:timeSleepCubit.loadingButton.value ,
                          func: () {
                            timeSleepCubit.addSleepTime(
                              sleepTimeFrom: timeSleepCubit.selectedTimeFrom
                                  .format(context),
                              sleepTimeTo:
                              timeSleepCubit.selectedTimeTo.format(context),
                              isToday: true,
                              diaryCubit: BlocProvider.of<DiaryCubit>(context)
                            ).then((value) {
                              NavigationService.goBack(context);
                            });
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

  Widget buildTimeFromAMorPM(context) {
    return Container(
        color: kColorPrimary.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: EdgeInsets.all(2),
        child: kTextHeader(
            timeSleepCubit.selectedTimeFrom.format(context).split(" ").last,
            size: 24));
  }

  Widget buildTimeToAMorPM(context) {
    return Container(
        color: kColorPrimary.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: EdgeInsets.all(2),
        child: kTextHeader(
            timeSleepCubit.selectedTimeTo.format(context).split(" ").last,
            size: 24));
  }

  Widget get simpleClock => AnalogClock(
        decoration: BoxDecoration(
          color: AppColors.clockColor,
          shape: BoxShape.circle,
        ),
        isLive: true,
        hourHandColor: AppColors.ACCENT_COLOR_DARK,
        minuteHandColor: AppColors.ACCENT_COLOR_DARK,
        showSecondHand: true,
        secondHandColor: AppColors.PRIMART_COLOR,
        numberColor: AppColors.ACCENT_COLOR_DARK,
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
    return InkWell(
      onTap: onTap,
      child: Container(
        child: RadioListTile(
          value: timeSleepCubit.dayTime[btnIndex],
          groupValue: timeSleepCubit.select,
          activeColor: kColorPrimary,
          onChanged: (value) {
            timeSleepCubit.onClickRadioButton(value);
            value == "From"
                ? timeSleepCubit.selectTimeFrom(context).then((value) {setState(() {

                });})
                : timeSleepCubit.selectTimeTo(context).then((value) {setState(() {

            });});
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
    );
  }
}
