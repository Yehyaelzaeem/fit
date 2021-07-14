import 'package:app/app/modules/home/home_appbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/transform_controller.dart';

class TransformView extends GetView<TransformController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
              'Transformations',
              style: GoogleFonts.cairo(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 8,
            childAspectRatio: 2,
            children: [
              Image.asset('assets/img/im_transformation1.png'),
              Image.asset('assets/img/im_transformation2.png'),
            ],
          ),
        ),
      ],
    ));
  }
}
