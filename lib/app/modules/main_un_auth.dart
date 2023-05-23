import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/notification_api.dart';
import 'package:app/app/modules/subscribe/views/non_user_subscribe_view.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../network_util/shared_helper.dart';
import '../widgets/default/text.dart';

class MainUnAuth extends StatelessWidget {
  MainUnAuth({this.isGuest});

  bool? isGuest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isGuest != null && isGuest == true)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeAppbar(type: null),
                Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/img/block-user.png",
                        width: 150,
                        height: 150,
                        color: kColorPrimary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                          child: Text(
                        "Sorry, No orders available,\n\please order first",
                        style: TextStyle(color: kColorPrimary, fontSize: 22),
                      )),
                    ),


/*                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SUBSCRIBE,arguments: null);
                      },
                      child: Center(
                        child: Container(
                          width: Get.width / 2,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: Color(0xffFFB62B),
                              borderRadius: BorderRadius.circular(64),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img/premium.png',
                                width: 30,
                                height: 30,
                              ),
                              kTextHeader('Make my meals',
                                  size: 16,
                                  color: Colors.white,
                                  bold: true,
                                  paddingH: 16,
                                  paddingV: 4),
                            ],
                          ),
                        ),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: kButton(
                        'Make my meals',
                        hight: 55,
                        color: Color(0xffFFB62B),
                        textSize: 20,
                        bold: true,
                        func: () {
                          Get.toNamed(Routes.SUBSCRIBE,arguments: null);
                        },
                      ),
                    ),

                    SizedBox(height:24),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: kButton(
                        'Get old orders',
                        hight: 55,
                        color: kColorAccent,
                        textSize: 20,
                        bold: true,
                        func: () async{
                          final bool isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
                          if(!isGuestSaved){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NonUserSubscribeView(isGuest: true,)),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox()
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/img/block-user.png",
                    width: 150,
                    height: 150,
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
              ],
            ),
    );
  }
}
