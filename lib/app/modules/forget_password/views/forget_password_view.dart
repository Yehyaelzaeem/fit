import 'package:app/app/utils/helper/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/password_edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:get/get.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  @override
  Widget build(BuildContext context) {
      return Container(
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            width: Get.width,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  kImgLogoWhiteNoBk,
                  width: Get.width / 2,
                ),
                Container(width: double.infinity, child: kTextHeader(Strings().forgetPassword, size: 24, align: TextAlign.start)),
                SizedBox(height: 12),
                EditText(value: '', hint: Strings().email, type: TextInputType.emailAddress),
                SizedBox(height: 8),
                
                kButtonDefault(
                  Strings().send,
                  marginH: Get.width / 10,
                  func: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
