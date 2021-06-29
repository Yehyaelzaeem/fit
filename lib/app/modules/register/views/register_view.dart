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

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Obx(
            () => Container(
              color: Colors.white,
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      kImgLogoWhiteNoBk,
                      width: Get.width / 2,
                    ),
                    Container(
                        width: double.infinity, child: kTextHeader(Strings().register, size: 24, align: TextAlign.start)),
                   SizedBox(height: 12),
                    EditText(value: '', hint: 'ID', type: TextInputType.number),
                    SizedBox(height: 12),
                    EditText(value: '', hint: Strings().name, type: TextInputType.name),
                    SizedBox(height: 12),
                    EditText(value: '', hint: Strings().email, type: TextInputType.emailAddress),
                    SizedBox(height: 12),
                    EditText(value: '', hint: Strings().phone, type: TextInputType.phone),
                    SizedBox(height: 12),
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
                              hint: Strings().birthdate,
                              type: TextInputType.text,
                              enable: false,
                            ),
                          ),
                        ))),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.genderIsMale.value = true;
                          },
                          child: Chip(
                            label: kTextbody(Strings().male, color: Colors.white, bold: controller.genderIsMale.value),
                            backgroundColor: controller.genderIsMale.value ? kColorPrimary : kColorAccent,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.genderIsMale.value = false;
                          },
                          child: Chip(
                            label: kTextbody(Strings().female, color: Colors.white, bold: !controller.genderIsMale.value),
                            backgroundColor: !controller.genderIsMale.value ? kColorPrimary : kColorAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    EditTextPassword(value: '', hint: Strings().password),
                    SizedBox(height: 4),
                    EditTextPassword(value: '', hint: Strings().confitmPassword),
                    kButtonDefault(
                      Strings().register,
                      marginH: Get.width / 10,
                      func: () {
                        Get.offAllNamed(Routes.HOME);
                      },
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        kTextfooter(Strings().alreadyHaveAccount),
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            child: kTextfooter(Strings().login,
                                size: 14, bold: true, color: kColorPrimary, paddingH: 4, paddingV: 4)),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
