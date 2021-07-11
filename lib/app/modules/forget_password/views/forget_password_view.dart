import 'package:app/app/modules/forget_password/controllers/forget_password_controller.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/password_edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(kLogoRow, height: 54),
              Container(
                margin: EdgeInsets.symmetric(vertical: 18),
                width: double.infinity,
                color: kColorAccent,
                padding: EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    'Forget password',
                    style: GoogleFonts.cairo(
                      fontSize: 24.0,
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
                    //Email
                    kTextbody('Email', size: 18),
                    EditText(
                      value: '',
                      hint: '',
                      updateFunc: (text) {},
                      validateFunc: (text) {},
                      type: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: Get.width / 14),
                          kButtonDefault('Send', marginH: Get.width / 5, paddingV: 0, func: () {
                            Get.toNamed(Routes.HOME);
                          }, shadow: true, paddingH: 50),
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
