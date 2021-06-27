import 'package:app/app/data/database/shared_pref.dart';
import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDrawer extends GetView<HomeController> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    YemenyPrefs prefs = YemenyPrefs();

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (prefs.getUserId() != null)
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(250),
                          child: prefs.getImage() != null
                              ? CachedNetworkImage(
                                  imageUrl: prefs.getImage()!,
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
                              : profileImageHolder()),
                      if (prefs.getName() != null && prefs.getName()!.isNotEmpty) Text(prefs.getName()!)
                    ],
                  )),

          
            //Contact
            singleDrawerItem(
                title: Strings().contactUs,
                icon: Icons.contact_phone,
                action: () {
                  Get.toNamed(Routes.CONTACT_US);
                }),
            //About
            singleDrawerItem(
                title: Strings().about,
                icon: Icons.info_outline,
                action: () {
                  Get.toNamed(Routes.ABOUT);
                }),
           
            //Change_language
            singleDrawerItem(
                title: Strings().changeLanguage,
                icon: Icons.language,
                action: () {
                  String? lang = prefs.getLanguage();
                  if (lang == null || lang.contains('ar')) {
                    prefs.setLanguage('en');
                    Get.updateLocale(Locale('en'));
                  } else {
                    prefs.setLanguage('ar');
                    Get.updateLocale(Locale('ar'));
                  }
                }),
            //LogOut
            singleDrawerItem(
                title: Strings().logout,
                icon: Icons.logout,
                action: () {
                  Get.defaultDialog(
                    title: Strings().notification,
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
                          Strings().confirm,
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
                        child: Text(Strings().dismiss),
                      ),
                    ),
                  );
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

  Widget singleDrawerItem({required String title,required IconData icon, var action}) {
    return GestureDetector(
      onTap: action,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(title),
            leading: Icon(icon),
          ),
          Divider(),
        ],
      ),
    );
  }
}
