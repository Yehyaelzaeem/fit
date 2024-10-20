import 'package:app/core/view/views.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/resources/resources.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../cubits/diary_cubit.dart';

class DiaryDatesWidget extends StatefulWidget {
  const DiaryDatesWidget({super.key});

  @override
  State<DiaryDatesWidget> createState() => _DiaryDatesWidgetState();
}

class _DiaryDatesWidgetState extends State<DiaryDatesWidget> {

  late final DiaryCubit diaryCubit;


  @override
  void initState() {
    super.initState();
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
  }
  @override
  Widget build(BuildContext context) {
    // Widget dayButton = InkWell(
    //   onTap: () async{
    //     FocusScope.of(context).requestFocus(FocusNode());
    //
    //     if (!diaryCubit.isToday) {
    //       final result = await Connectivity().checkConnectivity();
    //       diaryCubit.isToday = true;
    //
    //
    //       if (result != ConnectivityResult.none) {
    //
    //         diaryCubit
    //             .getDiaryData(
    //             diaryCubit.dayDetailsResponse!.data!.days![0].date!, isSending);
    //         diaryCubit.sendSavedDiaryDataByDay();
    //
    //         diaryCubit.sendSavedSleepTimes();
    //
    //         diaryCubit.refreshDiaryDataLive(
    //             diaryCubit.dayDetailsResponse!.data!.days![0].date!);
    //       }else{
    //         diaryCubit
    //             .getDiaryData(
    //             diaryCubit.dayDetailsResponse!.data!.days![0].date!, false);
    //       }
    //     } else {
    //       diaryCubit.isToday = false;
    //       final result = await Connectivity().checkConnectivity();
    //
    //
    //       if (result != ConnectivityResult.none) {
    //
    //         print("Get Day");
    //         print(diaryCubit.dayDetailsResponse!.data!.days![1].date.toString());
    //         diaryCubit
    //             .getDiaryData(
    //             diaryCubit.dayDetailsResponse!.data!.days![1].date!, isSending);
    //         diaryCubit.sendSavedSleepTimes();
    //
    //         diaryCubit.sendSavedDiaryDataByDay();
    //         diaryCubit.refreshDiaryDataLive(
    //             diaryCubit.dayDetailsResponse!.data!.days![1].date!);
    //       }else{
    //         diaryCubit
    //             .getDiaryData(
    //             diaryCubit.dayDetailsResponse!.data!.days![1].date!, isSending);
    //       }
    //     }
    //   },
    //   child: Container(
    //     width: deviceWidth / 4,
    //     height: 50,
    //     margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    //     decoration: BoxDecoration(
    //         color: kColorPrimary, borderRadius: BorderRadius.circular(4)),
    //     child: Center(
    //       child: kTextHeader(diaryCubit.isToday ? 'Yesterday' : 'Today',
    //           color: Colors.white, bold: true, size: 14),
    //     ),
    //   ),
    // );
    // Widget dateDisplay = Container(
    //   width: deviceWidth / 1.5,
    //   height: 50,
    //   margin: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
    //   decoration: BoxDecoration(
    //       color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
    //   child: Center(
    //     child: kTextHeader('${diaryCubit.date.value}',
    //         color: Colors.black87, bold: true, size: 14),
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          DayTab(
            isSelected: diaryCubit.chosenDay=='yesterday',
            day: 'Yesterday',
            date: DateTime.now().subtract(Duration(days: 1)),
            onTap: ()async{
              diaryCubit.chosenDay='yesterday';
              final result = await Connectivity().checkConnectivity();


              if (result != ConnectivityResult.none) {

                diaryCubit
                    .getDiaryData(
                    diaryCubit.dayDetailsResponse!.data!.days![1].date!, isSending);
                diaryCubit.sendSavedSleepTimes();

                diaryCubit.sendSavedDiaryDataByDay();
                diaryCubit.refreshDiaryDataLive(
                    diaryCubit.dayDetailsResponse!.data!.days![1].date!);
              }else{
                diaryCubit
                    .getDiaryData(
                    diaryCubit.dayDetailsResponse!.data!.days![1].date!, isSending);
              }
            },

          ),
          DayTab(
            isSelected: diaryCubit.chosenDay=='today',
              day: 'Today',
              date: DateTime.now(),
            onTap:()async{
              final result = await Connectivity().checkConnectivity();
              diaryCubit.chosenDay='today';


              if (result != ConnectivityResult.none) {

                diaryCubit
                    .getDiaryData(
                    diaryCubit.dayDetailsResponse!.data!.days![0].date!, isSending);
                diaryCubit.sendSavedDiaryDataByDay();

                diaryCubit.sendSavedSleepTimes();

                diaryCubit.refreshDiaryDataLive(
                    diaryCubit.dayDetailsResponse!.data!.days![0].date!);
              }else{
                diaryCubit
                    .getDiaryData(
                    diaryCubit.dayDetailsResponse!.data!.days![0].date!, false);
              }
            }
          ),
          DayTab(
            isSelected: diaryCubit.chosenDay=='tomorrow',
            day: 'Tomorrow',
            date: DateTime.now().add(Duration(days: 1)),
            onTap: ()async{
              diaryCubit.chosenDay='tomorrow';
              final result = await Connectivity().checkConnectivity();


              if (result != ConnectivityResult.none) {

                diaryCubit
                    .getDiaryData(
                    diaryCubit.dayDetailsResponse!.data!.days![2].date!, isSending);
                diaryCubit.sendSavedSleepTimes();

                diaryCubit.sendSavedDiaryDataByDay();
                diaryCubit.refreshDiaryDataLive(
                    diaryCubit.dayDetailsResponse!.data!.days![2].date!);
              }else{
                diaryCubit
                    .getDiaryData(
                    diaryCubit.dayDetailsResponse!.data!.days![2].date!, isSending);
              }
            },
          ),


        ],
      ),
    );
  }
}


class DayTab extends StatelessWidget {
  bool isSelected;
  DateTime date;
  String day;
  VoidCallback onTap;
  DayTab({super.key,
  required this.isSelected,
  required this.date,
  required this.day,
  required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isSelected?8:3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: AppSize.s64,
          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8, vertical: AppSize.s8),
          decoration: BoxDecoration(
              color: isSelected?AppColors.primary:AppColors.white,
              borderRadius: BorderRadius.circular(isSelected?AppSize.s32:AppSize.s16),
            boxShadow: [
              BoxShadow(
                color: Color(0x1E898989),
                blurRadius: 7,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: isSelected?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(day,
                color: isSelected?AppColors.white:AppColors.black, fontWeight: FontWeight.w500, fontSize: FontSize.s18,),
              VerticalSpace(AppSize.s3),
              CustomText(DateFormat('EEEE, dd MMM').format(date),
                color: isSelected?AppColors.white:AppColors.black, fontWeight: FontWeight.w400, fontSize: FontSize.s14,),
            ],
          ):Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(DateFormat('EE').format(date),
                color: isSelected?AppColors.white:AppColors.black, fontWeight: FontWeight.w500, fontSize: FontSize.s14,),
              VerticalSpace(AppSize.s3),
              CustomText(date.day.toString(),
                color: isSelected?AppColors.white:AppColors.black, fontWeight: FontWeight.w500, fontSize: FontSize.s14,),
            ],
          ),
          // child: Center(
          //   child: kTextHeader(DateFormat('EE').format(date),
          //       color: Colors.white, bold: true, size: 14),
          // ),
        ),
      ),
    );
  }
}

