import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
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
            'Contact us',
            style: TextStyle(
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
            kTextHeader('Phone', align: TextAlign.start, color: Color(0xff7FC902), bold: true),
            kTextbody('(+2)0101 545 1616', align: TextAlign.start, color: Colors.black, bold: true),
          ],
        ),
      ),

      //* email
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Color(0xffF1F1F1),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kTextHeader('Email Address', align: TextAlign.start, color: Color(0xff7FC902), bold: true),
            kTextbody('clinicfof@gmail.com', align: TextAlign.start, color: Colors.black, bold: true),
          ],
        ),
      ),

      // * location
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Color(0xffF1F1F1),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kTextHeader('Our Location', align: TextAlign.start, color: Color(0xff7FC902), bold: true),
            kTextbody('140 El-Saaqah St. Intersection with EL-Autostrad, El-Moltaka EL-Arabi, Sheraton Heliopolis, Near City Center Almaza, Cairo', align: TextAlign.start, color: Colors.black, bold: true),
          ],
        ),
      ),

      //* Working hours
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Color(0xffF1F1F1),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kTextHeader('Working Hours', align: TextAlign.start, color: Color(0xff7FC902), bold: true),
            kTextbody('Mondays-Tuesdays-Thursdays-Fridays ( 3-6 p.m )', align: TextAlign.start, color: Colors.black, bold: true),
          ],
        ),
      ),

      //* title text
      SizedBox(height: 12),
      Container(
        alignment: Alignment(0.01, -1.0),
        width: Get.width / 1.6,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(15.0),
          ),
          color: const Color(0xFF414042),
        ),
        child: Center(
          child: Text(
            'Kindly leave your message',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      //* User name
      Container(
        color: Colors.white,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //First name
                  kTextbody('User name', size: 18, bold: true),
                  Container(
                    color: Color(0xffeeeeee),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: EditText(
                      value: '',
                      hint: '',
                      radius: 4,
                      noBorder: true,
                      background: Color(0xffeeeeee),
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      //* Email
      Container(
        color: Colors.white,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //First name
                  kTextbody('Email', size: 18, bold: true),
                  Container(
                    color: Color(0xffeeeeee),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: EditText(
                      value: '',
                      hint: '',
                      radius: 4,
                      noBorder: true,
                      background: Color(0xffeeeeee),
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      //* Mobile Number
      Container(
        color: Colors.white,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //First name
                  kTextbody('Mobile Numder', size: 18, bold: true),
                  Container(
                    color: Color(0xffeeeeee),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: EditText(
                      value: '',
                      hint: '',
                      radius: 4,
                      noBorder: true,
                      background: Color(0xffeeeeee),
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      //* Subhect
      Container(
        color: Colors.white,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //First name
                  kTextbody('Subject', size: 18, bold: true),
                  Container(
                    color: Color(0xffeeeeee),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: EditText(
                      value: '',
                      hint: '',
                      radius: 4,
                      noBorder: true,
                      background: Color(0xffeeeeee),
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      //* Description
      Container(
        color: Colors.white,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //First name
                  kTextbody('Description', size: 18, bold: true),
                  Container(
                    color: Color(0xffeeeeee),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: EditText(
                      value: '',
                      hint: '',
                      radius: 4,
                      lines: 3,
                      noBorder: true,
                      background: Color(0xffeeeeee),
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      //* Send Button
      Center(child: kButtonDefault('Send', paddingV: 0, func: () {}, shadow: true, paddingH: 50)),

      Center(child: kTextbody('Our Social media links', size: 14)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.facebook, size: 50, color: Colors.blueAccent),
          SizedBox(width: 8),
          Icon(Icons.facebook, size: 50, color: Colors.blueAccent),
          SizedBox(width: 8),
          Icon(Icons.facebook, size: 50, color: Colors.blueAccent),
        ],
      ),
      SizedBox(height: Get.width / 14),
    ])));
  }
}
