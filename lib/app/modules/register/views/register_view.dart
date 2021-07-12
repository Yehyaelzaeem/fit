import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/password_edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 27 * kPixelFactor),
              Image.asset(kLogoRow, height: 54 * kPixelFactor),
              SizedBox(height: 27 * kPixelFactor),
              Container(
                height: 45 * kPixelFactor,
                width: double.infinity,
                color: kColorAccent,
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.cairo(
                      fontSize: 27.0 * kTextPixelFactor,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18 * kPixelFactor),
                    //id
                    kTextbody('ID', size: 18),
                    EditText(
                      value: '',
                      hint: '',
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.number,
                    ),
                    SizedBox(height: 12),

                    //User name
                    kTextbody('User name', size: 18),
                    EditText(
                      value: '',
                      hint: '',
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.text,
                    ),
                    SizedBox(height: 12),

                    //User name
                    kTextbody('Email', size: 18),
                    EditText(
                      value: '',
                      hint: '',
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12),

                    //Mobile Number
                    kTextbody('Mobile Number', size: 18),
                    EditText(
                      value: '',
                      hint: '',
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.phone,
                    ),
                    SizedBox(height: 12),

                    //Birth date
                    kTextbody('Birth date', size: 18),
                    GestureDetector(
                        onTap: () async {
                          await controller.selectDate();
                        },
                        child: Container(
                            child: Obx(
                          () => Container(
                            key: Key('birthdate_${controller.birthDate.value}'),
                            child: EditText(
                              value: '${controller.birthDate.value}',
                              suffixIconData: Icons.date_range,
                              hint: '',
                              type: TextInputType.text,
                              enable: false,
                            ),
                          ),
                        ))),
                    SizedBox(height: 12),
                    //Gender
                    kTextbody('Gender', size: 18),
                    Row(
                      children: [
                        SizedBox(width: 4),
                        Container(
                          width: Get.width/3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(64),
                          ),
                          child: Row(
                            children: [
                              Radio(
                                value: '',
                                groupValue: '1',
                                onChanged: (value) {},
                              ),
                              kTextbody('Male', size: 16),
                              SizedBox(width: 16),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 8,
                        ),
                        Container(
                          width: Get.width/3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(64),
                          ),
                          child: Row(
                            children: [
                              Radio(
                                value: '',
                                groupValue: '1',
                                onChanged: (value) {},
                              ),
                              kTextbody('Female', size: 16),
                              SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    //Password
                    kTextbody('Password', size: 18),
                    EditTextPassword(
                      value: '',
                      hint: '',
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                    ),
                    SizedBox(height: 12),

                    //Password
                    kTextbody('Confirm password', size: 18),
                    EditTextPassword(
                      value: '',
                      hint: '',
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                    ),
                    SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: Get.width / 14),
                          kButtonDefault('  Sign Up  ', marginH: Get.width / 7, paddingV: 0, func: () {
                            Get.toNamed(Routes.HOME);
                          }, paddingH: 20,shadow: true),
                          SizedBox(height: Get.width / 14),
                          GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: kTextHeader('Sign in', color: kColorAccent)),
                          SizedBox(height: Get.width / 14),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
