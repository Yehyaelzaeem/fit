import 'package:app/app/models/cheer_full_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/app_dialog.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/globale_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeDrawer extends GetView<HomeController> {
  final textEditController = Get.find<HomeController>(tag: 'home');
  final GlobalController globalController = Get.find<GlobalController>(tag: 'global');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfUserIsLogged(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        return itemBuilder(snapshot.data);
      },
    );
  }

  Widget itemBuilder(bool? data) {
    SharedHelper prefs = SharedHelper();

    return Container(
      width: Get.width / 1.5,
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // if (prefs.getUserId() != null)
            textEditController.isLogggd.value == false
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Image.asset(
                          kImgLogoWhiteNoBk,
                          width: Get.width / 3,
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Obx(() {
                          Echo('drawer itemBuilder ${textEditController.avatar.value}');
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              // ignore: unnecessary_null_comparison
                              child: CachedNetworkImage(
                                imageUrl: '${textEditController.avatar.value}',
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
                                placeholder: (ctx, url) {
                                  return profileImageHolder();
                                },
                                errorWidget: (context, url, error) {
                                  return profileImageHolder();
                                },
                              ));
                        })
                        // if (prefs.getName() != null && prefs.getName()!.isNotEmpty)
                        // Text(prefs.getName()!)
                        ,
                        Obx(() {
                          return kTextHeader('${textEditController.name.value}', size: 18);
                        }),
                        kTextfooter('ID :  ${textEditController.id.value}', size: 14, color: Colors.black87, paddingV: 0),
                        SizedBox(
                          height: 24,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Icon(Icons.circle, size: 13, color: kColorPrimary),
                        //     kTextfooter(' Active', color: kColorPrimary, size: 14, paddingV: 0),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Icon(Icons.circle, size: 13, color: kColorPrimary),
                        //     kTextfooter(' Active', color: kColorPrimary, size: 14, paddingV: 0),
                        //   ],
                        // ),
                      ],
                    )),

            SizedBox(height: 14),

            //Home
            // singleDrawerItem(
            //     title: 'Home',
            //     image: 'assets/img/ic_menu_home.png',
            //     action: () {
            //       Get.back();
            //       controller.currentIndex.value = 0;
            //     }),
            //
            // //Diary
            // singleDrawerItem(
            //     title: 'Diary',
            //     image: 'assets/img/ic_diary_primary.png',
            //     action: () {
            //       Get.back();
            //       controller.currentIndex.value = 1;
            //     }),
            //
            // //Doctor
            // singleDrawerItem(
            //     title: 'Sessions',
            //     image: 'assets/img/ic_menu_doctor.png',
            //     action: () {
            //       Get.back();
            //       controller.currentIndex.value = 2;
            //     }),
            //
            // //Profile
            textEditController.isLogggd == false
                ? SizedBox()
                : singleDrawerItem(
                    title: Strings().profile,
                    image: 'assets/img/ic_menu_person.png',
                    action: () {
                      Get.toNamed(Routes.PROFILE);
                    }),

            //Messages
            textEditController.isLogggd == false
                ? SizedBox()
                : singleDrawerItem(
                    title: 'Messages', //todo transulate
                    image: 'assets/img/ic_menu_messages.png',
                    action: () {
                      Get.toNamed(Routes.NOTIFICATIONS);
                    }),
            //Messages

            //CHEER_FULL
            FutureBuilder<bool>(
              future: getFaqStatus(),
              builder: (context, snapshot) {
                if (snapshot.hasData) if (snapshot.data!)
                  return singleDrawerItem(
                      title: 'FAQ', //todo transulate
                      image: 'assets/img/ic_menu_faq.png',
                      action: () {
                        Get.toNamed(Routes.FAQ);
                      });
                return Container();
              },
            ),

            //Transformation
            singleDrawerItem(
                title: 'Transformations', //todo transulate
                image: 'assets/img/ic_menu_images.png',
                action: () {
                  Get.toNamed(Routes.TRANSFORM);
                }),

            //CHEER_FULL
            FutureBuilder<bool>(
              future: getCheerFullStatus(),
              builder: (context, snapshot) {
                if (snapshot.hasData) if (snapshot.data!)
                  return singleDrawerItem(
                      title: "Cheer-Full",
                      image: 'assets/img/ic_meals.png',
                      action: () {
                        Get.toNamed(Routes.CHEER_FULL);
                      });
                return Container();
              },
            ),
            //Orders
            // singleDrawerItem(
            //     title: "My Orders",
            //     image: 'assets/img/ic_orders.png',
            //     action: () {
            //       Get.toNamed(Routes.ORDERS);
            //     }),
            //Contact
            singleDrawerItem(
                title: Strings().contactUs,
                image: 'assets/img/ic_menu_contact.png',
                action: () {
                  Get.toNamed(Routes.CONTACT_US);
                }),
            //About
            singleDrawerItem(
                title: "About us",
                image: 'assets/img/ic_menu_information.png',
                action: () {
                  Get.toNamed(Routes.ABOUT);
                }),
            textEditController.isLogggd.value == false
                ? singleDrawerItem(
                    title: "Login",
                    image: "assets/img/ic_menu_logout.png",
                    action: () {
                      Get.offAllNamed(Routes.AUTH);
                    })
                : singleDrawerItem(
                    title: Strings().logout,
                    image: 'assets/img/ic_menu_logout.png',
                    action: () {
                      appDialog(
                        title: "Logout",
                        image: Icon(Icons.exit_to_app, size: 50, color: Colors.red),
                        cancelAction: () {
                          Get.back();
                        },
                        cancelText: "No",
                        confirmAction: () {
                          prefs.logout();
                          Get.offAllNamed(Routes.SPLASH);
                        },
                        confirmText: "Yes",
                      );
                      // Get.defaultDialog(
                      //   title: "Logout",
                      //   middleText: Strings().logoutMessageConfirm,
                      //   confirm: GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       padding: EdgeInsets.all(4),
                      //       margin: EdgeInsets.symmetric(horizontal: 12),
                      //       child: Text(
                      //         "Yes",
                      //         style: TextStyle(color: Colors.red),
                      //       ),
                      //     ),
                      //   ),
                      //   cancel: GestureDetector(
                      //     onTap: () {
                      //       Get.back();
                      //     },
                      //     child: Container(
                      //       padding: EdgeInsets.all(4),
                      //       margin: EdgeInsets.symmetric(horizontal: 12),
                      //       child: Text("No"),
                      //     ),
                      //   ),
                      // );
                    }),
          ],
        ),
      ),
    );
  }

  Widget profileImageHolder() {
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.person, size: 40, color: Colors.grey[200]),
      ),
    );
  }

  Widget singleDrawerItem({required String title, required String image, var action}) {
    return InkWell(
      onTap: action,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 40),
              Image.asset(
                image,
                width: 24,
                color: title == "Login" ? kColorPrimary : null,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 18),
              )
            ],
          ),
          SizedBox(height: 22),
        ],
      ),
    );
  }

  Future<bool> getCheerFullStatus() async {
    try {
      if (textEditController.cheerFullStatus) return true;
      CheerFullResponse cheerFullResponse = await ApiProvider().getCheerFullStatus();
      textEditController.cheerFullStatus = kDebugMode ? true : cheerFullResponse.data!.isActive!;
      globalController.delivery_option.value = cheerFullResponse.data!.delivery_option!;
      globalController.pickup_option.value = cheerFullResponse.data!.pickup_option!;
      return textEditController.cheerFullStatus;
    } catch (e) {
      Echo('error response $e');
    }
    return true;
  }

  Future<bool> getFaqStatus() async {
    try {
      if (textEditController.faqStatus) return true;
      CheerFullResponse cheerFullResponse = await ApiProvider().getFaqStatus();
      if (cheerFullResponse.data == null) return true;
      textEditController.faqStatus = kDebugMode ? true : cheerFullResponse.data!.isFaqActive!;
      return textEditController.faqStatus;
    } catch (e) {
      Echo('error response $e');
    }
    return true;
  }

  Future<bool> checkIfUserIsLogged() async {
    bool isLogged = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    textEditController.refreshController(false);
    return isLogged;
  }
}
