
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/resources.dart';
import 'package:app/core/view/views.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';

import '../../../config/navigation/routes.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../timeSleep/cubits/time_sleep_cubit.dart';
import '../cubits/diary_cubit.dart';

class SleepTimeStatus extends  StatefulWidget {
  SleepTimeStatus({required this.isToday});

final isToday;


@override
State<SleepTimeStatus> createState() => _SleepTimeStatusState();
}

class _SleepTimeStatusState extends State<SleepTimeStatus> {

  late final DiaryCubit diaryCubit;


  @override
  void initState() {
    super.initState();
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s8),
          child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.s8)
          ),
          child: Stack(
            children: [
              SizedBox(),
              Positioned(
                right: -74,
                top: -50,
                bottom: -50,
                child: Container(
                  padding: EdgeInsets.all(AppSize.s24),
                  width: AppSize.s250,
                  height: AppSize.s250,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.15)
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(AppSize.s24),
                    width: AppSize.s250 - AppSize.s32,
                    height: AppSize.s250 - AppSize.s32,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.15)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSize.s24),
                      width: AppSize.s250 - AppSize.s64,
                      height: AppSize.s250 - AppSize.s64,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.15)
                      ),
                      child: Container(
                        padding: EdgeInsets.all(AppSize.s24),
                        width: AppSize.s250 - AppSize.s82,
                        height: AppSize.s250 - AppSize.s82,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.15)
                        ),
                      ),
                    ),
                  ),
                ),
                // child: CircleAvatar(
                //   radius: 240,
                //   backgroundColor: AppColors.primary.withOpacity(0.15),
                //   child: CircleAvatar(
                //     radius: 120,
                //     backgroundColor: AppColors.primary.withOpacity(0.2),
                //     child: CircleAvatar(
                //       radius: 90,
                //       backgroundColor: AppColors.primary.withOpacity(0.28),
                //       child: CircleAvatar(
                //         radius: 60,
                //         backgroundColor: AppColors.primary.withOpacity(0.34),
                //       ),
                //     ),
                //   ),
                // ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical:16,horizontal: 12),
                child: SizedBox(
                  height: AppSize.s100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Sleep time status',
                            fontSize: FontSize.s14,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                          ),
                          VerticalSpace(AppSize.s12),
                          SvgPicture.asset(AppIcons.sleepIcon,width: AppSize.s64,fit: BoxFit.fitWidth,),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(
                              height: 10,
                            ),
                            diaryCubit.dayDetailsResponse?.data?.sleepingTime == null
                                ? Container(
                                child: CustomText("Please, Insert your sleep time",
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppSize.s16,
                                    textAlign: TextAlign.center,
                                    maxLines: 2))
                                : Column(
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(

                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        // width: deviceWidth / 2,
                                        child: CustomText(
                                            diaryCubit.dayDetailsResponse!.data?.sleepingTime
                                                ?.sleepingStatus?.name ??
                                                "",
                                            textAlign: TextAlign.center,
                                            color: kColorPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppSize.s16),
                                      ),
                                    ),
                                        CachedNetworkImage(
                                          width: 32,
                                          height: 32,
                                          imageUrl: diaryCubit.dayDetailsResponse!.data?.sleepingTime
                                              ?.sleepingStatus?.image ??
                                              "",
                                          fadeInDuration: Duration(seconds: 2),
                                          errorWidget: (vtx, url, obj) {
                                            return Container();
                                          },
                                          // placeholder: (ctx, url) {
                                          //   return CircularLoadingWidget();
                                          // },
                                          // fit: BoxFit.c,
                                        ),

                                        // SizedBox(width: 8),
                                      ],
                                    ),

                                  ],
                                ),
                          ],
                        ),
                      ),
                      SizedBox(width: FontSize.s16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  TimeRangePicker.show(
                                    context: context,
                                    onSubmitted: (TimeRangeValue value) {
                                      print("${value.startTime} - ${value.endTime}");

                                      BlocProvider.of<TimeSleepCubit>(context).addSleepTime(
                                          sleepTimeFrom: value.startTime!.format(context),
                                          sleepTimeTo:value.endTime!.format(context),
                                          isToday: true,
                                          diaryCubit: BlocProvider.of<DiaryCubit>(context)
                                      ).then((value) {
                                        setState(() {

                                        });
                                      });
                                    },
                                  );
                                  // NavigationService.push(context,Routes.timeSleep, arguments:
                                  // {"isToday": widget.isToday},
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.customBlack,
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: AppSize.s16, vertical: AppSize.s4),
                                  child: Row(
                                    children: [
                                      // Icon(Icons.timelapse, color: Colors.white),
                                      CustomText('Set', color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                              HorizontalSpace(AppSize.s16),
                            ],
                          ),
                          SizedBox(
                            height: AppSize.s16,
                          ),
                          diaryCubit.dayDetailsResponse?.data?.sleepingTime == null
                              ? SizedBox(
                            height: AppSize.s16,
                          )
                              : Row(
                                children: [

                                  CustomTimeWidget(time: diaryCubit.dayDetailsResponse!.data?.sleepingTime
                                      ?.sleepingDuration ??
                                      "",),
                                  SizedBox(
                                    width: AppSize.s12,
                                  )
                                ],
                              ),

                          SizedBox(
                            height: AppSize.s20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical:16,horizontal: 12),
    //   color: Color(0xffEFEFEF),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Column(
    //         children: [
    //           kTextHeader(
    //             'Sleep time status',
    //             size: 18,
    //             bold: true,
    //             align: TextAlign.center,
    //           ),
    //           SizedBox(
    //             height: 8,
    //           ),
    //           diaryCubit.dayDetailsResponse!.data?.sleepingTime == null
    //               ? Container(
    //                   child: kTextbody("Please, Insert your sleep time",
    //                       maxLines: 2))
    //               : Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     CachedNetworkImage(
    //                       width: 24,
    //                       height: 24,
    //                       imageUrl: diaryCubit.dayDetailsResponse!.data?.sleepingTime
    //                               ?.sleepingStatus?.image ??
    //                           "",
    //                       fadeInDuration: Duration(seconds: 2),
    //                       errorWidget: (vtx, url, obj) {
    //                         return Container();
    //                       },
    //                       // placeholder: (ctx, url) {
    //                       //   return CircularLoadingWidget();
    //                       // },
    //                       // fit: BoxFit.c,
    //                     ),
    //                     SizedBox(width: 8),
    //                     Container(
    //                       width: deviceWidth / 2,
    //                       child: kTextHeader(
    //                           diaryCubit.dayDetailsResponse!.data?.sleepingTime
    //                                   ?.sleepingStatus?.name ??
    //                               "",
    //                           align: TextAlign.center,
    //                           color: kColorPrimary,
    //                           bold: true,
    //                           size: 14),
    //                     ),
    //                   ],
    //                 ),
    //         ],
    //       ),
    //       Column(
    //         children: [
    //           GestureDetector(
    //             onTap: () {
    //               NavigationService.push(context,Routes.timeSleep, arguments:
    //                 {"isToday": widget.isToday},
    //               );
    //             },
    //             child: Container(
    //               decoration: BoxDecoration(
    //                 color: kColorPrimary,
    //                 borderRadius: BorderRadius.circular(200),
    //               ),
    //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    //               child: Row(
    //                 children: [
    //                   Icon(Icons.timelapse, color: Colors.white),
    //                   SizedBox(width: 4),
    //                   kTextbody('Set Sleep Time', color: Colors.white),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: 8,
    //           ),
    //           diaryCubit.dayDetailsResponse!.data?.sleepingTime == null
    //               ? SizedBox()
    //               : kTextHeader(
    //                   diaryCubit.dayDetailsResponse!.data?.sleepingTime
    //                           ?.sleepingDuration ??
    //                       "",
    //                   align: TextAlign.center,
    //                   size: 18),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}


class CustomTimeWidget extends StatelessWidget {
  final String time; // This is your dynamic time variable

  CustomTimeWidget({super.key,required this.time});

  @override
  Widget build(BuildContext context) {

// Split the time into hours and minutes
    List<String> timeParts = time.split(':');
    String hours = timeParts[0]; // "05"
    String minutes = timeParts[1]; // "00"

// Convert "05" to "5" to remove leading zero
    int hoursInt = int.parse(hours);
    int minutesInt = int.parse(minutes);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$hoursInt', // Dynamic hours
            style: TextStyle(color: Colors.black, fontSize: AppSize.s32,fontWeight:FontWeight.w700),
          ),
          TextSpan(
            text: 'h ', // 'h' with different color
            style: TextStyle(color: Colors.white, fontSize: 20,
                fontFamily: 'Itim',
                fontWeight: FontWeightManager.medium),
          ),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add padding under the minutes part
              child: Text(
                '$minutesInt', // Dynamic minutes
                style: TextStyle(color: Colors.black, fontSize: FontSize.s18,fontWeight: FontWeight.w700),
              ),
            ),
          ),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add padding under the 'm' part
              child: Text(
                'm', // 'm' with different color
                style: TextStyle(color: Colors.white,
                    fontFamily: 'Mogra',
                    fontSize: FontSize.s16,fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

