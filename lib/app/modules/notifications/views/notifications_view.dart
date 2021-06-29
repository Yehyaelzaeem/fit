import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          title: Text('Messages'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...controller.list.map((element) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: kTextHeader('Subject:${element.title}',
                            paddingH: 12, paddingV: 12, color: kColorPrimary, align: TextAlign.start),
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
                        child: kTextfooter(element.date, paddingH: 0, paddingV: 0, align: TextAlign.end),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ));
  }
}
