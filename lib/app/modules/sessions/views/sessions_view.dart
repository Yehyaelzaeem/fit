import 'package:app/app/modules/session_details/session_details.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sessions_controller.dart';

class SessionsView extends GetView<SessionsController> {
  final controller = Get.find(tag: 'SessionsController');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          PageLable(name: "My Sessions"),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.symmetric(vertical: 8),
            color: Color(0xffF1F1F1),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        kTextbody(
                          'Next session',
                          color: Colors.black,
                          size: 16,
                        ),
                        kTextbody('Thursday', color: kColorPrimary, size: 16, bold: true),
                        kTextbody(
                          '03/06/2021  11:50 PM',
                          color: Colors.black,
                          size: 16,
                        ),
                      ],
                    )),
                Positioned(
                    right: 26,
                    top: 3,
                    child: kTextfooter(
                      'Pending',
                      color: Colors.black87,
                    )),
              ],
            ),
          ),
          SizedBox(height: 12),
          PageLable(name: "Completed"),
          for (int i = 0; i < 3; i++)
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 12),
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                  spreadRadius: 3,
                )
              ]),
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(child: SizedBox(width: 1)),
                              Column(
                                children: [
                                  kTextbody('Thursday', color: kColorPrimary, size: 16, bold: true),
                                  kTextbody(
                                    '03/06/2021  11:50 PM',
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox(width: 1)),
                              kButton('Details', hight: 35, func: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SessionDetails()));
                              }),
                              SizedBox(width: 12),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
        ],
      ),
    ));
  }
}
