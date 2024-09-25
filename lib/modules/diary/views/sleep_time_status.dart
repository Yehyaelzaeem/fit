
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../config/navigation/routes.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/text.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(vertical:16,horizontal: 12),
      color: Color(0xffEFEFEF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              kTextHeader(
                'Sleep time status',
                size: 18,
                bold: true,
                align: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              diaryCubit.dayDetailsResponse!.data?.sleepingTime == null
                  ? Container(
                      child: kTextbody("Please, Insert your sleep time",
                          maxLines: 2))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          width: 24,
                          height: 24,
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
                        SizedBox(width: 8),
                        Container(
                          width: deviceWidth / 2,
                          child: kTextHeader(
                              diaryCubit.dayDetailsResponse!.data?.sleepingTime
                                      ?.sleepingStatus?.name ??
                                  "",
                              align: TextAlign.center,
                              color: kColorPrimary,
                              bold: true,
                              size: 14),
                        ),
                      ],
                    ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  NavigationService.push(context,Routes.timeSleep, arguments:
                    {"isToday": widget.isToday},
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kColorPrimary,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.timelapse, color: Colors.white),
                      SizedBox(width: 4),
                      kTextbody('Set Sleep Time', color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              diaryCubit.dayDetailsResponse!.data?.sleepingTime == null
                  ? SizedBox()
                  : kTextHeader(
                      diaryCubit.dayDetailsResponse!.data?.sleepingTime
                              ?.sleepingDuration ??
                          "",
                      align: TextAlign.center,
                      size: 18),
            ],
          )
        ],
      ),
    );
  }
}
