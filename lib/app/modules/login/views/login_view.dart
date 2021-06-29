import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
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
                Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),
                SizedBox(height: 12),
                EditText(value: '', hint: Strings().phone, type: TextInputType.phone),
                SizedBox(height: 8),
                EditTextPassword(value: '', hint: Strings().password),
                SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.FORGET_PASSWORD);
                  },
                  child: Container(
                    width: double.infinity,
                    child: kTextfooter(
                      '${Strings().forgetPassword}?',
                      size: 12,
                      align: TextAlign.end,
                      paddingH: 8,
                      paddingV: 2,
                    ),
                  ),
                ),
                kButtonDefault(
                  Strings().login,
                  marginH: Get.width / 10,
                  func: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    kTextfooter(Strings().doNotHaveAnAccount),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: kTextfooter(
                        Strings().register,
                        size: 14,
                        bold: true,
                        color: kColorPrimary,
                        paddingH: 4,
                        paddingV: 4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.HOME);
                  },
                  child: kTextfooter(
                    Strings().skip,
                    size: 12,
                    paddingH: 4,
                    paddingV: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
