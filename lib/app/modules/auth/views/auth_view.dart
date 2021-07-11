import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/const_strings.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 26),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              kLogoColumn,
              width: double.infinity,
            ),
          ),
          Column(
            children: [
              kButton(
                'Sign in',
                marginH: 20,
                bold: true,
                paddingH: 0,
                textSize: 24,
                func: () {
                  Get.toNamed(Routes.LOGIN);
                },
              ),
              SizedBox(height: 8),
              kButton(
                'Sign up',
                color: kColorAccent,
                marginH: 20,
                paddingH: 0,
                textSize: 24,
                bold: true,
                func: () {
                  Get.toNamed(Routes.REGISTER);
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: (){Get.toNamed(Routes.HOME);},
            child: kTextHeader('Skip', color: kColorPrimary, size: 20))
        ],
      ),
    );
  }
}
