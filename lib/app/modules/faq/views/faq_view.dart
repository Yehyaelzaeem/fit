import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  @override
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            HomeAppbar(),
            SizedBox(height: 12),
            Container(
              alignment: Alignment(0.01, -1.0),
              width: Get.width / 2.4,
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(15.0),
                ),
                color: const Color(0xFF414042),
              ),
              child: Center(
                child: Text(
                  'FAQ',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            //* 1
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                controller.showFaq.value = !controller.showFaq.value;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xffF1F1F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    kTextHeader(
                      'Why should I join fit over fat?',
                      align: TextAlign.start,
                      color: Color(0xff7FC902),
                      bold: true,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(controller.showFaq.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.showFaq.value)
              Container(
                width: double.infinity,
                child: kTextbody('FitoverfaT is the first Medical Center in Egypt using Indirect Calorimeter to assessthe actual real basal', color: Colors.black, align: TextAlign.start, paddingH: 18),
              ),

            SizedBox(height: Get.width / 14),
          ],
        ),
      )),
    );
  }
}
