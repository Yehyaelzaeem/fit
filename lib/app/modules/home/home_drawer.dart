import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeDrawer extends GetView<HomeController> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return itemBuilder();
  }

  Widget itemBuilder() {
    SharedHelper prefs = SharedHelper();

    return Container(
      width: Get.width / 1.5,
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // if (prefs.getUserId() != null)
            controller.isLogggd == false
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
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: prefs.readString(CachingKey.AVATAR) != null
                                  ? CachedNetworkImage(
                                      imageUrl: controller.avatar.value,
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 80,
                                      placeholder: (ctx, url) {
                                        return profileImageHolder();
                                      },
                                      errorWidget: (context, url, error) {
                                        return profileImageHolder();
                                      },
                                    )
                                  : profileImageHolder());
                        })
                        // if (prefs.getName() != null && prefs.getName()!.isNotEmpty)
                        // Text(prefs.getName()!)
                        ,
                        Obx(() {
                          return kTextHeader('${controller.name.value}', size: 18);
                        }),
                        kTextfooter('ID :  ${controller.id.value}',
                            size: 14, color: Colors.black87, paddingV: 0),
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
            singleDrawerItem(
                title: 'Home',
                image: 'assets/img/ic_menu_home.png',
                action: () {
                  Get.back();
                  controller.currentIndex.value = 0;
                }),

            //Diary
            singleDrawerItem(
                title: 'Diary',
                image: 'assets/img/ic_diary_primary.png',
                action: () {
                  Get.back();
                  controller.currentIndex.value = 1;
                }),

            //Doctor
            singleDrawerItem(
                title: 'Sessions',
                image: 'assets/img/ic_menu_doctor.png',
                action: () {
                  Get.back();
                  controller.currentIndex.value = 2;
                }),

            //Profile
            controller.isLogggd == false
                ? SizedBox()
                : singleDrawerItem(
                    title: Strings().profile,
                    image: 'assets/img/ic_menu_person.png',
                    action: () {
                      Get.toNamed(Routes.PROFILE);
                    }),

            //Messages
            controller.isLogggd == false
                ? SizedBox()
                : singleDrawerItem(
                    title: 'Messages', //todo transulate
                    image: 'assets/img/ic_menu_messages.png',
                    action: () {
                      Get.toNamed(Routes.NOTIFICATIONS);
                    }),
            //Messages
            singleDrawerItem(
                title: 'FAQ', //todo transulate
                image: 'assets/img/ic_menu_faq.png',
                action: () {
                  Get.toNamed(Routes.FAQ);
                }),

            //Transformation
             singleDrawerItem(
                    title: 'Transformations', //todo transulate
                    image: 'assets/img/ic_menu_images.png',
                    action: () {
                      Get.toNamed(Routes.TRANSFORM);
                    }),

            //Contact
            singleDrawerItem(
                title: Strings().contactUs,
                image: 'assets/img/ic_menu_contact.png',
                action: () {
                  Get.toNamed(Routes.CONTACT_US);
                }),
            //About
            singleDrawerItem(
                title: Strings().about,
                image: 'assets/img/ic_menu_information.png',
                action: () {
                  Get.toNamed(Routes.ABOUT);
                }),
            //Setting
            // singleDrawerItem(
            //     title: 'Settings',
            //     image: 'assets/img/ic_menu_setting.png',
            //     action: () {
            //       SharedHelper helper = SharedHelper();
            //       helper.logout();
            //
            //       Get.toNamed(Routes.SPLASH);
            //     }),

            // //Change_language
            // singleDrawerItem(
            //     title: Strings().changeLanguage,
            //     icon: Icons.language,
            //     action: () {
            //       String? lang = prefs.getLanguage();
            //       if (lang == null || lang.contains('ar')) {
            //         prefs.setLanguage('en');
            //         Get.updateLocale(Locale('en'));
            //       } else {
            //         prefs.setLanguage('ar');
            //         Get.updateLocale(Locale('ar'));
            //       }
            //     }),

            //LogOut
            controller.isLogggd == false
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
                      Get.defaultDialog(
                        title: "Log Out",
                        middleText: Strings().logoutMessageConfirm,
                        confirm: GestureDetector(
                          onTap: () {
                            prefs.logout();
                            Get.offAllNamed(Routes.SPLASH);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        cancel: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("No"),
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
    ;
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
}
