
import 'package:analog_clock/analog_clock.dart';
import 'package:app/core/resources/resources.dart';
import 'package:app/core/utils/alerts.dart';
import 'package:app/core/view/views.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
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
    return BlocConsumer<TimeSleepCubit, TimeSleepStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
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
              // SizedBox(),
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
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: AppSize.s8),
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
                          SvgPicture.asset(AppIcons.sleepIcon, width: AppSize
                              .s64, fit: BoxFit.fitWidth,),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(
                              height: 10,
                            ),
                            diaryCubit.dayDetailsResponse?.data?.sleepingTime ==
                                null
                                ? Container(
                                child: CustomText(
                                    "Please, Insert your sleep time",
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppSize.s16,
                                    textAlign: TextAlign.center,
                                    maxLines: 2))
                                : Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),

                                Container(
                                  alignment: Alignment.centerRight,
                                  // width: deviceWidth / 2,
                                  child: CustomText(
                                      diaryCubit.dayDetailsResponse!.data
                                          ?.sleepingTime
                                          ?.sleepingStatus?.name ??
                                          "",
                                      textAlign: TextAlign.center,
                                      color: kColorPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppSize.s16),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                CachedNetworkImage(
                                  width: 32,
                                  height: 32,
                                  imageUrl: diaryCubit.dayDetailsResponse!
                                      .data?.sleepingTime
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
                                Row(

                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [


                                    // SizedBox(width: 8),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: FontSize.s8),
                      SizedBox(
                        width: AppSize.s90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
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
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) => CustomTimePickerDialog(),
                                    // );
                                    // await _showCustomTimePickerDialog(context);
                                    setState(() {

                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.customBlack,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.s16,
                                        vertical: AppSize.s4),
                                    child: Row(
                                      children: [
                                        // Icon(Icons.timelapse, color: Colors.white),
                                        CustomText('Set', color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                                // HorizontalSpace(AppSize.s16),
                              ],
                            ),
                            SizedBox(
                              height: AppSize.s16,
                            ),
                            diaryCubit.dayDetailsResponse?.data?.sleepingTime ==
                                null
                                ? SizedBox(
                                   height: AppSize.s16,
                                 )
                                : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                if(diaryCubit.dayDetailsResponse?.data
                                    ?.sleepingTime
                                    ?.sleepingDuration!=null)
                                CustomTimeWidget(
                                  time: diaryCubit.dayDetailsResponse?.data
                                      ?.sleepingTime
                                      ?.sleepingDuration ??
                                      "",),
                                // SizedBox(
                                //   width: AppSize.s12,
                                // )
                              ],
                            ),

                            SizedBox(
                              height: AppSize.s20,
                            ),
                          ],
                        ),
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
  });
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

  // Custom Dialog for Time Picker
   _showCustomTimePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child:TimeTabsWidget()
        );
      },
    );
  }

}
//
// class TimePickerDialog extends StatefulWidget {
//   @override
//   _TimePickerDialogState createState() => _TimePickerDialogState();
// }
//
// class _TimePickerDialogState extends State<TimePickerDialog> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   TimeOfDay? _fromTime;
//   TimeOfDay? _toTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _fromTime = TimeOfDay.now();
//     _toTime = TimeOfDay.now();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Tab Bar for "From" and "To"
//             TabBar(
//               controller: _tabController,
//               labelColor: Theme.of(context).primaryColor,
//               unselectedLabelColor: Colors.grey,
//               tabs: const [
//                 Tab(text: 'From'),
//                 Tab(text: 'To'),
//               ],
//             ),
//             // Tab View for Time Pickers
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   // "From" Time Picker Tab
//                   Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       Text("Select Start Time"),
//                       const SizedBox(height: 8),
//                       Expanded(child: ClockTimePicker())
//                     ],
//                   ),
//                   // "To" Time Picker Tab
//                   Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       Text("Select End Time"),
//                       const SizedBox(height: 8),
//                       ClockTimePicker(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Save Button
//             ElevatedButton(
//               onPressed: () {
//                 // Handle Save logic here
//                 print("From: ${_fromTime?.format(context)}");
//                 print("To: ${_toTime?.format(context)}");
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomTimeWidget extends StatelessWidget {
  final String time; // This is your dynamic time variable

  CustomTimeWidget({super.key,required this.time});

  @override
  Widget build(BuildContext context) {

// Split the time into hours and minutes

    List<String> timeParts = time.split(':');
    String hours = time == ""?'00':timeParts[0]; // "05"
    String minutes = time == ""?'00':timeParts[1]; // "00"

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


class TimeTabsWidget extends StatefulWidget {
  const TimeTabsWidget({super.key});

  @override
  State<TimeTabsWidget> createState() => _TimeTabsWidgetState();
}

class _TimeTabsWidgetState extends State<TimeTabsWidget> {
  bool isFrom = true;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Tabs for From/To
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 110,
              height: 36,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFB8B8B8)),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap:(){
                      isFrom = true;
                      setState(() {

                      });
            },
                    child: Container(
                      width: 54,
                      height: 36,
                      decoration: ShapeDecoration(
                        color: isFrom?Color(0xFF7FC902):AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        'From',
                        color: isFrom?AppColors.white:AppColors.customBlack,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap:(){

                      isFrom = false;
                      setState(() {

                      });
                    },
                    child: Container(
                      width: 54,
                      height: 36,
                      decoration: ShapeDecoration(
                        color: !isFrom?Color(0xFF7FC902):AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        'To',
                        color: !isFrom?AppColors.white:AppColors.customBlack,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

          // From Tab
          isFrom?Column(
            children: [

              SizedBox(height: AppSize.s24),
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: AnalogClock(
                  datetime: DateTime.now().copyWith(hour: fromTime?.hour??0,minute: fromTime?.minute??0,second: 0,),
                  isLive: false,
                  height: AppSize.s175,
                  width: AppSize.s175,
                    showAllNumbers:true,
                  showTicks: false,
                    secondHandColor:AppColors.white.withOpacity(0.1),
                    minuteHandColor:AppColors.black,
                  tickColor:AppColors.black,
                    hourHandColor:AppColors.black,
                  showDigitalClock: false,
                    useMilitaryTime:true



                ),
                // ClockTimeDisplay(
                //   time: fromTime,
                //   label: 'From',
                // ),
              ),
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: Text(
                  fromTime != null
                      ? fromTime!.format(context)
                      : 'Set From Time',
                  style: TextStyle(fontSize: fromTime != null?FontSize.s22:FontSize.s16, color: AppColors.primary),
                ),
              ),
            ],
          ):
          // To Tab
          Column(
            children: [
              SizedBox(height: AppSize.s24),

              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: AnalogClock(
                    datetime: DateTime.now().copyWith(hour: toTime?.hour??0,minute: toTime?.minute??0,second: 0,),
                    isLive: false,
                    height: AppSize.s175,
                    width: AppSize.s175,
                    showAllNumbers:true,
                    showTicks: false,
                    secondHandColor:AppColors.white.withOpacity(0.1),
                    minuteHandColor:AppColors.black,
                    tickColor:AppColors.black,
                    hourHandColor:AppColors.black,
                    showDigitalClock: false,
                    useMilitaryTime:true



                ),
              ),
              SizedBox(height: AppSize.s32),
              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: Text(
                  toTime != null
                      ? toTime!.format(context)
                      : 'Set To Time',
                  style: TextStyle(fontSize: toTime != null?FontSize.s22:FontSize.s16, color: AppColors.primary),
                ),
              ),


            ],
          ),

          SizedBox(height: AppSize.s16),
          // Buttons for Cancel and OK
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: CustomText('CANCEL',color: AppColors.black,),
              ),
              TextButton(
                onPressed: () {
                  if(fromTime==null){
                    Alerts.showToast('Select from time');
                  }else if(toTime==null){
                    Alerts.showToast('Select to time');
                  }
                  BlocProvider.of<TimeSleepCubit>(context).addSleepTime(
                      sleepTimeFrom: fromTime!.format(context),
                      sleepTimeTo:toTime!.format(context),
                      isToday: true,
                      diaryCubit: BlocProvider.of<DiaryCubit>(context)
                  ).then((value) {
                    setState(() {

                    });
                    Navigator.of(context).pop();
                  });

                },
                child: CustomText('OK',color: AppColors.primary,),
              ),
            ],
          )
        ],
      ),
    );
  }

  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  // Method to show time picker
  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFrom
          ? (fromTime ?? TimeOfDay.now())
          : (toTime ?? TimeOfDay.now()),
    );
    if (picked != null) {


      setState(() {
        if (isFrom) {
          fromTime = picked;
        } else {
          toTime = picked;
        }
      });
    }
  }


}
