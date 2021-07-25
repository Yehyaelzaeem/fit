import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          HomeAppbar(),
          SizedBox(height: 10),
          Container(
            alignment: Alignment(0.01, -1.0),
            width: 150.0,
            height: 36.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(15.0),
              ),
              color: const Color(0xFF414042),
            ),
            child: Center(
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
          ...controller.list.map((element) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 6),
                              kTextHeader('Subject:', paddingV: 12, color: kColorPrimary, align: TextAlign.start),
                              kTextHeader('${element.title}', paddingV: 12, color: Colors.black, align: TextAlign.start),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: kTextbody(element.desc, paddingH: 12, paddingV: 12, align: TextAlign.start),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: kTextfooter(element.date, paddingH: 0, paddingV: 0, align: TextAlign.end, color: kColorPrimary),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ));
  }
}
