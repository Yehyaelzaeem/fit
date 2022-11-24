import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepTimeStatus extends GetView<DiaryController> {
  @override
  final controller = Get.find(tag: 'diary');

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
                align: TextAlign.start,
              ),
              controller.response.value.data?.sleepingTime == null
                  ? Container(
                      child: kTextbody("Please, Insert your sleeping time",
                          maxLines: 2))
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Get.toNamed(Routes.TIME_SLEEP);
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
                  ? kTextbody("No time selected")
                  : kTextHeader(
                      controller.response.value.data?.sleepingTime
                              ?.sleepingDuration ??
                          "",
                      align: TextAlign.start,
                      size: 18),
            ],
          )
        ],
      ),
    );
  }
}
