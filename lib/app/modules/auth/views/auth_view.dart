import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 26),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100),
            child: Image.asset(
              kLogoColumn,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 66),
          Column(
            children: [
              kButton(
                'Sign in',
                hight: 55,
                marginH: 20,
                bold: true,
                paddingH: 0,
                textSize: 20,
                func: () {
                  Get.toNamed(Routes.LOGIN);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: kButton(
                  'Sign up',
                  hight: 55,
                  color: kColorAccent,
                  textSize: 20,
                  bold: true,
                  func: () {
                    Get.toNamed(Routes.REGISTER);
                  },
                ),
              ),
            ],
          ),
          GestureDetector(
              onTap: () async {
                await SharedHelper().writeData(CachingKey.IS_GUEST, true);
                Get.toNamed(Routes.HOME);
              },
              child: kTextHeader('Skip', color: kColorPrimary, size: 20))
        ],
      ),
    );
  }
}
