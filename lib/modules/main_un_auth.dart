
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/resources/resources.dart';
import 'package:app/modules/subscribe/views/non_user_subscribe_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/navigation/navigation_services.dart';
import '../config/navigation/routes.dart';
import '../core/resources/app_colors.dart';
import '../core/utils/shared_helper.dart';
import '../core/view/widgets/default/app_buttons.dart';
import '../core/view/widgets/default/text.dart';
import '../core/view/widgets/page_lable.dart';
import 'home/view/widgets/home_appbar.dart';


class MainUnAuth extends StatelessWidget {
  MainUnAuth({this.isGuest, this.paymentStatus});

  bool? isGuest;
  bool? paymentStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isGuest != null && isGuest == true)
          ?  paymentStatus == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeAppbar(
                  onBack: () => Navigator.pop(context),
                ),
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
                        "Sorry, No packages available,\n\Please subscribe first",
                        style: TextStyle(color: kColorPrimary, fontSize: 22),
                      )),
                    ),
                   Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: kButton(
                              '',
                              hight: 55,
                              color: Color(0xffFFB62B),
                              textSize: 20,
                              bold: true,
                              func: () {
                                NavigationService.push(context,Routes.subscribeView, arguments: null);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/premium.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  kTextHeader('Subscribe',
                                      size: 20,
                                      color: Colors.white,
                                      bold: true,
                                      paddingH: 16,
                                      paddingV: 4),
                                ],
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: kButton(
                        'Get old packages',
                        hight: 55,
                        color: AppColors.ACCENT_COLOR,
                        textSize: 20,
                        bold: true,
                        func: () async {
                          final bool isGuestSaved = await SharedHelper()
                              .readBoolean(CachingKey.IS_GUEST_SAVED);
                          if (!isGuestSaved) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NonUserSubscribeView(
                                        isGuest: true,
                                      )),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox()
              ],
            ): Column(
        children: [
          //App bar
          HomeAppbar(
            onBack: () async {
              await NavigationService.push(context,
                Routes.homeScreen,
              );
            },
          ),
          SizedBox(height: 12),
          PageLable(name: " My Packages"),
          SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: deviceHeight * 0.2),
              child: Column(
                children: [
                  Image.asset(
                    AppImages.kEmptyPackage,
                    scale: 5,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  kTextbody("  Empty!  ", size: 16),
                ],
              ),
            ),
          ),
          SizedBox(),
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
              ],
            ),
    );
  }
}
