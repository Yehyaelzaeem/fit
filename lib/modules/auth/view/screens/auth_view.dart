

import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/view/widgets/default/app_buttons.dart';
import '../../../../core/view/widgets/default/text.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
              AppImages.kLogoColumn,
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
                  NavigationService.push(context,Routes.loginScreen);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: kButton(
                  'Sign up',
                  hight: 55,
                  color: AppColors.ACCENT_COLOR,
                  textSize: 20,
                  bold: true,
                  func: () {
                    NavigationService.push(context,Routes.signupScreen);

                  },
                ),
              ),
            ],
          ),
          GestureDetector(
              onTap: () async {
                // await SharedHelper().writeData(CachingKey.IS_GUEST, true);
                // DiaryController controller = Get.find<DiaryController>(tag: 'diary');
                // controller.isLogged.value = false;
                NavigationService.push(context,Routes.homeScreen);

              },
              child: kTextHeader('Skip', color: AppColors.PRIMART_COLOR, size: 20))
        ],
      ),
    );
  }
}
