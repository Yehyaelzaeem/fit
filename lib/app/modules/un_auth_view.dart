import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnAuthView extends StatelessWidget {
  const UnAuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/img/block-user.png",
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              color: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
                child: Text(
              "Sorry  ,, Illegal Access \n\ Please Login First",
              style: TextStyle(color: Colors.red, fontSize: 22),
            )),
          ),
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
    );
  }
}
