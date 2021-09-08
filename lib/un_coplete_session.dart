import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncompleteData extends StatelessWidget {
  const IncompleteData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: MediaQuery.of(context).size.width/3,),
          Center(
            child: Icon(Icons.info),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
                child: Text(
                  "Sorry,  \n\ Please Sign In First",
                  style: TextStyle(color: kColorPrimary, fontSize: 22),
                )),
          ),
          kButton(
            'Sign in',
            hight: 55,
            marginH: 20,
            color: kColorAccent,
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
              color: kColorPrimary,
              textSize: 20,
              bold: true,
              func: () {
                Get.toNamed(Routes.REGISTER);
              },
            ),
          ),
          GestureDetector(
              onTap: () {
                Get.toNamed(Routes.HOME);
              },
              child: kTextHeader('Go Back To Home', color: kColorPrimary, size: 20)),


          SizedBox(height: MediaQuery.of(context).size.width/4,),

        ],
      ),
    );
  }
}
