import 'package:app/app/modules/about/controllers/about_controller.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';

class AboutView extends GetView<AboutController> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            'About',
            style: GoogleFonts.cairo(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      //* phone
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Color(0xffF1F1F1),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kTextbody(Strings().longText, align: TextAlign.start, color: Colors.black, bold: false),
          ],
        ),
      ),

     
      SizedBox(height: Get.width / 14),
    ])));
  }
}
