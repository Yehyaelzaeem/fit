
import 'package:app/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/navigation/navigation_services.dart';
import '../config/navigation/routes.dart';
import '../core/view/widgets/default/app_buttons.dart';
import '../core/view/widgets/default/text.dart';

class UnAuthView extends StatelessWidget {
  const UnAuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width / 3,
          ),
          Center(
            child: Image.asset(
              "assets/img/block-user.png",
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              color: kColorPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
                child: Text(
              "Sorry, Illegal Access \n\ Please Sign In First",
              style: TextStyle(color: kColorPrimary, fontSize: 22),
            )),
          ),
          kButton(
            'Sign in',
            hight: 55,
            marginH: 20,
            color: AppColors.ACCENT_COLOR,
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
              color: kColorPrimary,
              textSize: 20,
              bold: true,
              func: () {
                NavigationService.push(context,Routes.signupScreen);
              },
            ),
          ),
          GestureDetector(
              onTap: () {
                NavigationService.push(context,Routes.homeScreen);
              },
              child: kTextHeader('Go Back To Home',
                  color: kColorPrimary, size: 20)),
          SizedBox(
            height: MediaQuery.of(context).size.width / 4,
          ),
        ],
      ),
    );
  }
}
