import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: kTextHeader(
                'Sleep time status',
                size: 18,
                bold: true,
                align: TextAlign.start,
              )),
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
                      kTextbody('Sit Sleep Time', color: Colors.white),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Image.asset(
                    'assets/img/smile.png',
                    width: 36,
                    height: 36,
                  ),
                  SizedBox(width: 8),
                  kTextHeader('Good', align: TextAlign.start, size: 18),
                ],
              )),
              kTextHeader('8H  15M  ', align: TextAlign.start, size: 18),
            ],
          )
        ],
      ),
    );
  }
}
