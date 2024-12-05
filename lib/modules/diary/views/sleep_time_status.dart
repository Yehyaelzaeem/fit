
import 'package:analog_clock/analog_clock.dart';
import 'package:app/core/utils/alerts.dart';
import 'package:app/core/view/views.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../../core/resources/app_assets.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/app_values.dart';
import '../../../core/resources/font_manager.dart';
import '../../timeSleep/cubits/time_sleep_cubit.dart';
import '../cubits/diary_cubit.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart' as timeT;


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
                                    showTimePickerDialog(context);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => TimePickerScreen()),
                                    // );
                                    // TimeRangePicker.show(
                                    //   context: context,
                                    //   onSubmitted: (TimeRangeValue value) {
                                    //     print("${value.startTime} - ${value.endTime}");
                                    //
                                    //     BlocProvider.of<TimeSleepCubit>(context).addSleepTime(
                                    //         sleepTimeFrom: value.startTime!.format(context),
                                    //         sleepTimeTo:value.endTime!.format(context),
                                    //         isToday: true,
                                    //         diaryCubit: BlocProvider.of<DiaryCubit>(context)
                                    //     ).then((value) {
                                    //       setState(() {
                                    //
                                    //       });
                                    //     });
                                    //   },
                                    // );
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


  void showTimePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: TimePickerScreen(
            fromTime: diaryCubit.dayDetailsResponse?.data
                ?.sleepingTime?.sleepingFrom??'12:00 AM',
            toTime: diaryCubit.dayDetailsResponse?.data
                ?.sleepingTime?.sleepingTo??'08:00 AM',
          ),
        );
      },
    );
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



class TimePickerScreen extends StatefulWidget {
  final String fromTime;
  final String toTime;

  const TimePickerScreen({super.key, required this.fromTime, required this.toTime});
  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}
class _TimePickerScreenState extends State<TimePickerScreen> {
  timeT.Time _startTime = timeT.Time(hour: 0, minute: 0); // Initial start time
  timeT.Time _endTime = timeT.Time(hour: 8, minute: 0);   // Initial end time

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.oneMin;



  @override
  void initState() {
    super.initState();
    _startTime = _parseTime(widget.fromTime);
    _endTime = _parseTime(widget.toTime);

    _startController.text = _formatTime(_startTime);
    _endController.text = _formatTime(_endTime);
  }

  /// Helper to parse a time string with AM/PM into timeT.Time
  timeT.Time _parseTime(String timeString) {
    final parts = timeString.split(' '); // Split time and AM/PM
    if (parts.length < 2) return timeT.Time(hour: 0, minute: 0);

    final timeParts = parts[0].split(':'); // Split hours and minutes
    final isPM = parts[1].toUpperCase() == 'PM';

    int hour = int.tryParse(timeParts[0]) ?? 0;
    int minute = int.tryParse(timeParts[1]) ?? 0;

    // Convert to 24-hour format if PM and not 12 PM
    if (isPM && hour != 12) hour += 12;

    // Handle midnight (12 AM)
    if (!isPM && hour == 12) hour = 0;

    return timeT.Time(hour: hour, minute: minute);
  }

  void _showTimePicker({required bool isStart}) {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: isStart ? _startTime : _endTime,
        onChange: (selectedTime) {
          setState(() {
            if (isStart) {
              _startTime = selectedTime;
              _startController.text = _formatTime(_startTime);
            } else {
              _endTime = selectedTime;
              _endController.text = _formatTime(_endTime);
            }
          });
        },
        is24HrFormat: false, // Use 12-hour format with AM/PM
      ),
    );
  }

  String _formatTime(timeT.Time time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  PickedTime _convertToPickedTime(timeT.Time time) {
    return PickedTime(h: time.hour, m: time.minute);
  }

  timeT.Time _convertToTimeT(PickedTime pickedTime) {
    return timeT.Time(hour: pickedTime.h, minute: pickedTime.m);
  }

  String _formatTimeToAmPm(int hour, int minute) {
    final int adjustedHour = hour % 12 == 0 ? 12 : hour % 12; // Adjust for 12-hour clock
    final String period = hour < 12 ? "AM" : "PM"; // Determine AM/PM
    final String formattedMinute = minute.toString().padLeft(2, '0'); // Pad minutes with 0 if necessary

    return "$adjustedHour:$formattedMinute $period";
  }

  @override
  Widget build(BuildContext context) {
        return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerticalSpace(AppSize.s16),
            CustomText('Sleep Time', fontSize: AppSize.s20),
            VerticalSpace(AppSize.s32),
            TimePicker(
              width: AppSize.s250,
              height: AppSize.s250,
              initTime: _convertToPickedTime(_startTime), // Convert here
              endTime: _convertToPickedTime(_endTime),
              onSelectionChange: (start, end, isDisableRange) {
                setState(() {
                  _startTime = _convertToTimeT(start);
                  _endTime = _convertToTimeT(end);
                  // _startController.text = "${start.h.toString().padLeft(2, '0')}:${start.m.toString().padLeft(2, '0')}";
                  // _endController.text = "${end.h.toString().padLeft(2, '0')}:${end.m.toString().padLeft(2, '0')}";
                  _startController.text = _formatTimeToAmPm(start.h, start.m);
                  _endController.text = _formatTimeToAmPm(end.h, end.m);
                });
              },
              // decoration: TimePickerDecoration(
              //   baseColor: AppColors.customBlack,
              //   pickerBaseCirclePadding: 15.0,
              //   sweepDecoration: TimePickerSweepDecoration(
              //     pickerStrokeWidth: 30.0,
              //     pickerColor: AppColors.primary,
              //     showConnector: true,
              //   ),
              //
              //   // Other decorations...
              // ),
                          decoration: TimePickerDecoration(
                baseColor: AppColors.customBlack,
                pickerBaseCirclePadding: 15.0,
                sweepDecoration: TimePickerSweepDecoration(
                  pickerStrokeWidth: 30.0,
                  pickerColor:  AppColors.primary,
                  showConnector: true,
                ),
                initHandlerDecoration: TimePickerHandlerDecoration(
                  color: AppColors.customBlack,
                  shape: BoxShape.circle,
                  radius: 12.0,
                  icon: Icon(
                    Icons.power_settings_new_outlined,
                    size: 20.0,
                    color: AppColors.white,

                  ),
                ),
                endHandlerDecoration: TimePickerHandlerDecoration(
                  color: AppColors.customBlack,
                  shape: BoxShape.circle,
                  radius: 12.0,
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    size: 20.0,
                    color: AppColors.white,
                  ),

                ),
                primarySectorsDecoration: TimePickerSectorDecoration(
                  color: AppColors.primary,
                  width: 1.0,
                  size: 4.0,
                  radiusPadding: 1.0,
                ),
                secondarySectorsDecoration: TimePickerSectorDecoration(
                  color: AppColors.primary,
                  width: 1.0,
                  size: 2.0,
                  radiusPadding: 1.0,
                ),
                clockNumberDecoration: TimePickerClockNumberDecoration(
                  defaultTextColor: AppColors.primary,
                  defaultFontSize: 12.0,
                  scaleFactor: 1.5,
                  showNumberIndicators: true,
                    positionFactor:0.58,
                  clockTimeFormat: _clockTimeFormat,

                  clockIncrementTimeFormat: _clockIncrementTimeFormat,
                  clockIncrementHourFormat: ClockIncrementHourFormat.one
                ),
              ),
                          onSelectionEnd: (start, end, isDisableRange) {
                print(
                  'onSelectionEnd => init: ${start.h}:${start.m}, end: ${end.h}:${end.m}, isDisableRange: $isDisableRange',
                );
              },
            ),
            SizedBox(height: AppSize.s48),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

          InkWell(
            onTap: () => _showTimePicker(isStart: true),
            child: Container(
              width: AppSize.s125,
              height: AppSize.s132,
              padding: EdgeInsets.all(AppSize.s8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "${_startController.text}",
                    fontSize: FontSize.s20,
                    fontWeight: FontWeightManager.medium,
            
                  ),
                  VerticalSpace(AppSize.s12),
                  CustomText(
                    "BedTime",
                    fontSize: FontSize.s20,
                    color: AppColors.primary,
                    fontWeight: FontWeightManager.medium,
                  
                  ),
                  VerticalSpace(AppSize.s12),
            
                  Icon(Icons.power_settings_new,color: AppColors.primary,)
            
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showTimePicker(isStart: false),
            child: Container(
              width: AppSize.s125,
              height: AppSize.s132,
              padding: EdgeInsets.all(AppSize.s8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "${_endController.text}",
                    fontSize: FontSize.s20,
                    fontWeight: FontWeightManager.medium,
            
                  ),
                  VerticalSpace(AppSize.s12),
                  CustomText(
                    "WakeUp",
                    fontSize: FontSize.s20,
                    color: AppColors.primary,
                    fontWeight: FontWeightManager.medium,
            
                  ),
                  VerticalSpace(AppSize.s12),
            
                  Icon(Icons.notifications_active_outlined,color: AppColors.primary,)
            
                ],
              ),
            ),
          ),
            ],),
            const SizedBox(height: AppSize.s32),
            CustomButton(
              onPressed: () async {
                // Use _startTime and _endTime directly
                await BlocProvider.of<TimeSleepCubit>(context).addSleepTime(
                  sleepTimeFrom: _startTime.format(context),
                  sleepTimeTo: _endTime.format(context),
                  isToday: true,
                  diaryCubit: BlocProvider.of<DiaryCubit>(context),
                );
                Navigator.pop(context);
              },
              text: "Submit",
              width: AppSize.s150,
              height: AppSize.s40,
              borderRadius: FontSize.s24,
            ),
            const SizedBox(height: AppSize.s16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }
}

// class _TimePickerScreenState extends State<TimePickerScreen> {
//   PickedTime? _startTime = PickedTime(h: 0, m: 0); // Initial start time
//   PickedTime? _endTime = PickedTime(h: 8, m: 0);   // Initial end time
//
//   final TextEditingController _startController = TextEditingController();
//   final TextEditingController _endController = TextEditingController();
//   ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
//   ClockIncrementTimeFormat _clockIncrementTimeFormat =
//       ClockIncrementTimeFormat.oneMin;
//
//   @override
//   void initState() {
//     super.initState();
//     _startController.text = "${_startTime!.h.toString().padLeft(2, '0')}:${_startTime!.m.toString().padLeft(2, '0')}";
//     _endController.text = "${_endTime!.h.toString().padLeft(2, '0')}:${_endTime!.m.toString().padLeft(2, '0')}";
//   }
//
//   // void _updateTimeFromInput() {
//   //   setState(() {
//   //     final startParts = _startController.text.split(':');
//   //     if (startParts.length == 2) {
//   //       _startTime = PickedTime(h: int.tryParse(startParts[0]) ?? 0, m: int.tryParse(startParts[1]) ?? 0);
//   //     }
//   //
//   //     final endParts = _endController.text.split(':');
//   //     if (endParts.length == 2) {
//   //       _endTime = PickedTime(h: int.tryParse(endParts[0]) ?? 0, m: int.tryParse(endParts[1]) ?? 0);
//   //     }
//   //   });
//   // }
//
//
//   void _showTimePicker({required bool isStart}) {
//     Navigator.of(context).push(
//         showPicker(
//       context: context,
//       value: isStart ? _startTime : _endTime,
//       onChange: (selectedTime) {
//         setState(() {
//           if (isStart) {
//             _startTime = selectedTime;
//             _startController.text = _formatTime(selectedTime);
//           } else {
//             _endTime = selectedTime;
//             _endController.text = _formatTime(selectedTime);
//           }
//         });
//       },
//       is24HrFormat: false, // Use 12-hour format with AM/PM
//     ));
//   }
//
//   String _formatTime(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? "AM" : "PM";
//     return "$hour:$minute $period";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: deviceWidth,
//       decoration: BoxDecoration(
//         color: AppColors.offWhite,
//         borderRadius: BorderRadius.circular(AppSize.s12),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             VerticalSpace(AppSize.s16),
//             CustomText('Sleep Time', fontSize: AppSize.s20),
//             VerticalSpace(AppSize.s32),
//             TimePicker(
//               width: AppSize.s250,
//               height: AppSize.s250,
//               initTime: _startTime!,
//               endTime: _endTime!,
//               onSelectionChange: (start, end, isDisableRange) {
//                 setState(() {
//                   _startTime = start;
//                   _endTime = end;
//                   _startController.text = "${start.h.toString().padLeft(2, '0')}:${start.m.toString().padLeft(2, '0')}";
//                   _endController.text = "${end.h.toString().padLeft(2, '0')}:${end.m.toString().padLeft(2, '0')}";
//                 });
//               },
//               // decoration: TimePickerDecoration(
//               //   baseColor: AppColors.customBlack,
//               //   pickerBaseCirclePadding: 15.0,
//               //   sweepDecoration: TimePickerSweepDecoration(
//               //     pickerStrokeWidth: 30.0,
//               //     pickerColor: AppColors.primary,
//               //     showConnector: true,
//               //   ),
//               //
//               //   // Other decorations...
//               // ),
//                           decoration: TimePickerDecoration(
//                 baseColor: AppColors.customBlack,
//                 pickerBaseCirclePadding: 15.0,
//                 sweepDecoration: TimePickerSweepDecoration(
//                   pickerStrokeWidth: 30.0,
//                   pickerColor:  AppColors.primary,
//                   showConnector: true,
//                 ),
//                 initHandlerDecoration: TimePickerHandlerDecoration(
//                   color: AppColors.customBlack,
//                   shape: BoxShape.circle,
//                   radius: 12.0,
//                   icon: Icon(
//                     Icons.power_settings_new_outlined,
//                     size: 20.0,
//                     color: AppColors.white,
//
//                   ),
//                 ),
//                 endHandlerDecoration: TimePickerHandlerDecoration(
//                   color: AppColors.customBlack,
//                   shape: BoxShape.circle,
//                   radius: 12.0,
//                   icon: Icon(
//                     Icons.notifications_active_outlined,
//                     size: 20.0,
//                     color: AppColors.white,
//                   ),
//
//                 ),
//                 primarySectorsDecoration: TimePickerSectorDecoration(
//                   color: AppColors.primary,
//                   width: 1.0,
//                   size: 4.0,
//                   radiusPadding: 1.0,
//                 ),
//                 secondarySectorsDecoration: TimePickerSectorDecoration(
//                   color: AppColors.primary,
//                   width: 1.0,
//                   size: 2.0,
//                   radiusPadding: 1.0,
//                 ),
//                 clockNumberDecoration: TimePickerClockNumberDecoration(
//                   defaultTextColor: AppColors.primary,
//                   defaultFontSize: 12.0,
//                   scaleFactor: 1.5,
//                   showNumberIndicators: true,
//                     positionFactor:0.58,
//                   clockTimeFormat: _clockTimeFormat,
//
//                   clockIncrementTimeFormat: _clockIncrementTimeFormat,
//                   clockIncrementHourFormat: ClockIncrementHourFormat.one
//                 ),
//               ),
//                           onSelectionEnd: (start, end, isDisableRange) {
//                 print(
//                   'onSelectionEnd => init: ${start.h}:${start.m}, end: ${end.h}:${end.m}, isDisableRange: $isDisableRange',
//                 );
//               },
//             ),
//             SizedBox(height: AppSize.s48),
//             Container(
//               width: AppSize.s250,
//               height: AppSize.s48,
//               child: Row(
//                 children: [
//                SizedBox(
//                   width: AppSize.s100,
//                   child: CustomText(
//                     "Start: ",
//                     fontSize: FontSize.s20,
//                     color: AppColors.primary,
//                     fontWeight: FontWeightManager.medium,
//
//                   ),
//                 ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => _showTimePicker(isStart: true),
//                   child: AbsorbPointer(
//                     child: TextFormField(
//                       controller: _startController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         hintText: "Select Start Time",
//                       ),
//                     ),
//                   ),
//                 ),),
//                 ],
//               ),
//             ),
//             SizedBox(height: AppSize.s16),
//             Container(
//               width: AppSize.s250,
//               height: AppSize.s48,
//               child: Row(
//                 children: [
//                  SizedBox(
//                   width: AppSize.s100,
//                   child: CustomText(
//                     "End: ",
//                     fontSize: FontSize.s20,
//                     color: AppColors.primary,
//                     fontWeight: FontWeightManager.medium,
//
//                   ),
//                 ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _showTimePicker(isStart: false),
//                       child: AbsorbPointer(
//                         child: TextFormField(
//                           controller: _endController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             hintText: "Select End Time",
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: AppSize.s32),
//             CustomButton(
//               onPressed: () async {
//                 final formattedStartTime = TimeOfDay(hour: _startTime!.h, minute: _startTime!.m);
//                 final formattedEndTime = TimeOfDay(hour: _endTime!.h, minute: _endTime!.m);
//                 await BlocProvider.of<TimeSleepCubit>(context).addSleepTime(
//                   sleepTimeFrom: formattedStartTime.format(context),
//                   sleepTimeTo: formattedEndTime.format(context),
//                   isToday: true,
//                   diaryCubit: BlocProvider.of<DiaryCubit>(context),
//                 );
//                 Navigator.pop(context);
//               },
//               text: "Submit",
//               width: AppSize.s150,
//               height: AppSize.s40,
//               borderRadius: FontSize.s24,
//             ),
//             VerticalSpace(AppSize.s16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _startController.dispose();
//     _endController.dispose();
//     super.dispose();
//   }
// }




///------------------------------------------------------------------------------
// class _TimePickerScreenState extends State<TimePickerScreen> {
//   PickedTime? _startTime = PickedTime(h: 0, m: 0); // Initial start time
//   PickedTime? _endTime = PickedTime(h: 8, m: 0);   // Initial end time
//   ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
//   ClockIncrementTimeFormat _clockIncrementTimeFormat =
//       ClockIncrementTimeFormat.oneMin;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//   }
//
//   // updateTime(){
//   //   print("sleepingTo");
//   //   if(BlocProvider.of<DiaryCubit>(context).dayDetailsResponse?.data?.sleepingTime?.sleepingTo !=null){
//   //     selectedTimeTo = convertStringToTimeOfDay(BlocProvider.of<DiaryCubit>(context).dayDetailsResponse?.data!.sleepingTime!.sleepingTo!);
//   //   }
//   //   if(controllerDiary.response.value.data?.sleepingTime?.sleepingFrom !=null){
//   //     selectedTimeFrom = convertStringToTimeOfDay(controllerDiary.response.value.data!.sleepingTime!.sleepingFrom!);
//   //   }
//   //   update();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: deviceWidth,
//       decoration: BoxDecoration(
//         color: AppColors.offWhite,
//         borderRadius: BorderRadius.circular(AppSize.s12)
//       ),
//
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // Shrink the popup to fit its contents
//         children: [
//
//           VerticalSpace(AppSize.s16),
//
//           CustomText('Sleep Time',fontSize: AppSize.s20,),
//
//           VerticalSpace(AppSize.s32),
//           // TimePicker Widget
//           TimePicker(
//             width: AppSize.s250,
//             height: AppSize.s250,
//             initTime: _startTime!,
//             endTime: _endTime!,
//             decoration: TimePickerDecoration(
//               baseColor: AppColors.customBlack,
//               pickerBaseCirclePadding: 15.0,
//               sweepDecoration: TimePickerSweepDecoration(
//                 pickerStrokeWidth: 30.0,
//                 pickerColor:  AppColors.primary,
//                 showConnector: true,
//               ),
//               initHandlerDecoration: TimePickerHandlerDecoration(
//                 color: AppColors.customBlack,
//                 shape: BoxShape.circle,
//                 radius: 12.0,
//                 icon: Icon(
//                   Icons.power_settings_new_outlined,
//                   size: 20.0,
//                   color: AppColors.white,
//
//                 ),
//               ),
//               endHandlerDecoration: TimePickerHandlerDecoration(
//                 color: AppColors.customBlack,
//                 shape: BoxShape.circle,
//                 radius: 12.0,
//                 icon: Icon(
//                   Icons.notifications_active_outlined,
//                   size: 20.0,
//                   color: AppColors.white,
//                 ),
//
//               ),
//               primarySectorsDecoration: TimePickerSectorDecoration(
//                 color: AppColors.primary,
//                 width: 1.0,
//                 size: 4.0,
//                 radiusPadding: 1.0,
//               ),
//               secondarySectorsDecoration: TimePickerSectorDecoration(
//                 color: AppColors.primary,
//                 width: 1.0,
//                 size: 2.0,
//                 radiusPadding: 1.0,
//               ),
//               clockNumberDecoration: TimePickerClockNumberDecoration(
//                 defaultTextColor: AppColors.primary,
//                 defaultFontSize: 12.0,
//                 scaleFactor: 1.5,
//                 showNumberIndicators: true,
//                   positionFactor:0.58,
//                 clockTimeFormat: _clockTimeFormat,
//
//                 clockIncrementTimeFormat: _clockIncrementTimeFormat,
//                 clockIncrementHourFormat: ClockIncrementHourFormat.one
//               ),
//             ),
//             onSelectionChange: (start, end, isDisableRange) {
//               setState(() {
//                 _startTime = start;
//                 _endTime = end;
//               });
//               print(
//                 'onSelectionChange => init: ${start.h}:${start.m}, end: ${end.h}:${end.m}, isDisableRange: $isDisableRange',
//               );
//             },
//             onSelectionEnd: (start, end, isDisableRange) {
//               print(
//                 'onSelectionEnd => init: ${start.h}:${start.m}, end: ${end.h}:${end.m}, isDisableRange: $isDisableRange',
//               );
//             },
//             child: Padding(
//               padding: EdgeInsets.all(AppSize.s72),
//             ),
//           ),
//           SizedBox(height: AppSize.s48),
//           // Display Selected Time
//
//           Container(
//             width: AppSize.s250,
//             height: AppSize.s48,
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 2,
//                     spreadRadius: 2,
//                     offset: Offset(0, 0),
//                   ),
//                 ]),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: AppSize.s100,
//                   child: CustomText(
//                     "Start: ",
//                     fontSize: FontSize.s20,
//                     color: AppColors.primary,
//                     fontWeight: FontWeightManager.medium,
//
//                   ),
//                 ),
//                 CustomText(
//                   "${_startTime!.h.toString().padLeft(2,'0')}:${_startTime!.m.toString().padLeft(2,'0')}",
//                   fontSize: FontSize.s20,
//                   fontWeight: FontWeightManager.medium,
//
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: AppSize.s16),
//
//           Container(
//             width: AppSize.s250,
//             height: AppSize.s48,
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 2,
//                     spreadRadius: 2,
//                     offset: Offset(0, 0),
//                   ),
//                 ]),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//
//               children: [
//                 SizedBox(
//                   width: AppSize.s100,
//                   child: CustomText(
//                     "End: ",
//                     fontSize: FontSize.s20,
//                     color: AppColors.primary,
//                     fontWeight: FontWeightManager.medium,
//
//                   ),
//                 ),
//                 CustomText(
//                   "${_endTime!.h.toString().padLeft(2,'0')}:${_endTime!.m.toString().padLeft(2,'0')}",
//                   fontSize: FontSize.s20,
//                   fontWeight: FontWeightManager.medium,
//
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: AppSize.s32),
//           // Submit Button
//           CustomButton(
//             onPressed: () async {
//               final formattedStartTime = TimeOfDay(hour: _startTime!.h, minute: _startTime!.m);
//               final formattedEndTime = TimeOfDay(hour: _endTime!.h, minute: _endTime!.m);
//
//               // Example: Send data to TimeSleepCubit
//               await BlocProvider.of<TimeSleepCubit>(context).addSleepTime(
//                 sleepTimeFrom: formattedStartTime.format(context),
//                 sleepTimeTo: formattedEndTime.format(context),
//                 isToday: true,
//                 diaryCubit: BlocProvider.of<DiaryCubit>(context),
//               );
//               // Update UI or perform other actions
//               setState(() {});
//               Navigator.pop(context);
//             },
//             text: "Submit",
//             width: AppSize.s150,
//             height: AppSize.s40,
//             borderRadius: FontSize.s24,
//           ),
//           VerticalSpace(AppSize.s16)
//         ],
//       ),
//     );
//   }
// }


class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Prevent input beyond 5 characters (HH:mm)
    if (newValue.text.length > 5) return oldValue;

    String input = newValue.text.replaceAll(":", ""); // Remove any existing colons
    String formatted = "";

    if (input.length >= 1) {
      formatted = input.substring(0, 1);
    }
    if (input.length >= 2) {
      formatted += input.substring(1, 2);
    }
    if (input.length >= 3) {
      formatted += ":" + input.substring(2, 3);
    }
    if (input.length >= 4) {
      formatted += input.substring(3, 4);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
