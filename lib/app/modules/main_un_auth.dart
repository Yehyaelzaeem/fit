import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/subscribe/views/non_user_subscribe_view.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../network_util/shared_helper.dart';
import '../utils/helper/assets_path.dart';
import '../widgets/default/text.dart';
import '../widgets/page_lable.dart';

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
                                Get.toNamed(Routes.SUBSCRIBE, arguments: null);
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
                        color: kColorAccent,
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
              await Get.toNamed(
                Routes.HOME,
              );
            },
          ),
          SizedBox(height: 12),
          PageLable(name: " My Packages"),
          SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.2),
              child: Column(
                children: [
                  Image.asset(
                    kEmptyPackage,
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
