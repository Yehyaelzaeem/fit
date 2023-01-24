import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/notification_api.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepTimeStatus extends GetView<DiaryController> {
  final isToday;

  @override
  final controller = Get.find(tag: 'diary');

  SleepTimeStatus({required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
              controller.response.value.data?.sleepingTime == null
                  ? Container(
                      child: kTextbody("Please, Insert your sleep time",
                          maxLines: 2))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          width: 24,
                          height: 24,
                          imageUrl: controller.response.value.data?.sleepingTime
                                  ?.sleepingStatus?.image ??
                              "",
                          fadeInDuration: Duration(seconds: 2),
                          errorWidget: (vtx, url, obj) {
                            return Container();
                          },
                          placeholder: (ctx, url) {
                            return CircularLoadingWidget();
                          },
                          // fit: BoxFit.c,
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: Get.width / 2,
                          child: kTextHeader(
                              controller.response.value.data?.sleepingTime
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
                  Get.toNamed(Routes.TIME_SLEEP, arguments: [
                    {"isToday": isToday},
                  ]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kColorPrimary,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
              controller.response.value.data?.sleepingTime == null
                  ? SizedBox()
                  : kTextHeader(
                      controller.response.value.data?.sleepingTime
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
