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

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
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
                        'Sign In',
                        style:TextStyle(
                          fontSize: 27.0 * kTextPixelFactor,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        //id
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: kTextbody('ID', size: 18),
                        ),
                        EditText(
                          value: '',
                          hint: '',
                          updateFunc: (text) {},
                          validateFunc: (text) {},
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 12),

                        //Password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: kTextbody('Password', size: 18),
                        ),
                        EditTextPassword(
                          value: '',
                          hint: '',
                          updateFunc: (text) {},
                          validateFunc: (text) {},
                        ),

                        //Forget password
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.FORGET_PASSWORD);
                          },
                          child: Container(
                            width: double.infinity,
                            child: kTextfooter(
                              'Forget password ?',
                              size: 12,
                              align: TextAlign.end,
                              paddingH: 8,
                              paddingV: 2,
                            ),
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.width / 14),
                              kButtonDefault(
                                '  Sign in  ',
                                marginH: Get.width / 4.5,
                                paddingV: 0,
                                func: () {
                                  Get.toNamed(Routes.HOME);
                                },
                                shadow: true,
                                paddingH: 30,
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  kTextbody('Remeber Me', size: 16),
                                  Checkbox(
                                    value: true,
                                    activeColor: kColorPrimary,
                                    onChanged: (value) {},
                                  )
                                ],
                              ),
                              SizedBox(height: Get.width / 14),
                              GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.REGISTER);
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: kTextHeader('Sign Up', color: kColorAccent),
                                      ),
                                      Positioned(
                                          bottom: 8,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black87,
                                          ))
                                    ],
                                  )),
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
