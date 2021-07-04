import 'package:app/app/data/database/shared_pref.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  Widget profileImageHolder() {
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.person, size: 40, color: Colors.grey[200]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    YemenyPrefs prefs = YemenyPrefs();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            HomeAppbar(),
            SizedBox(height: 12),
            // profile title
            Container(
              alignment: Alignment(0.01, -1.0),
              height: 30.0,
              width: Get.width / 2,
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(15.0),
                ),
                color: const Color(0xFF414042),
              ),
              child: Center(
                child: Text(
                  'Profile',
                  style: GoogleFonts.cairo(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            //profile card
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 34,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  width: 0.5,
                  color: Color(0xff707070),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 14),
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
                  kTextHeader('Mostafa Mohamed'),
                  kTextfooter('ID:1682947', size: 14, color: Colors.black87, paddingV: 0),
                  SizedBox(height: 14),
                ],
              ),
            ),

            // edit your profile
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kTextbody('Edit your profile', color: kColorPrimary),
                  SizedBox(width: 6),
                  Icon(Icons.edit, size: 16, color: kColorPrimary),
                ],
              ),
            ),

            //Next session
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 12),
              padding: EdgeInsets.symmetric(vertical: 8),
              color: Color(0xffF1F1F1),
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          kTextbody(
                            'Next session',
                            color: Colors.black,
                            size: 16,
                          ),
                          kTextbody(
                            'Thursday',
                            color: kColorPrimary,
                            size: 16,
                          ),
                          kTextbody(
                            '03/06/2021  11:50 PM',
                            color: Colors.black,
                            size: 16,
                          ),
                        ],
                      )),
                  Positioned(
                      right: 26,
                      top: 3,
                      child: kTextfooter(
                        'Pending',
                        color: Colors.black87,
                      )),
                ],
              ),
            ),

            //Package renewal date
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 20, color: kColorPrimary),
                  SizedBox(width: 6),
                  kTextbody('Package Renewal Date', color: Colors.black87),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: kTextbody('Wednesday, 16 Jun 2021'),
                ),
              ],
            ),
            // Target
            SizedBox(height: 18),
            Container(
              alignment: Alignment(0.01, -1.0),
              height: 30.0,
              width: Get.width / 2,
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(15.0),
                ),
                color: const Color(0xFF414042),
              ),
              child: Center(
                child: Text(
                  'Target',
                  style: GoogleFonts.cairo(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Total Weight:', bold: true),
                  kTextbody(' 70 KG', color: kColorPrimary),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Fats Percentage:', bold: true),
                  kTextbody(' 30 %', color: kColorPrimary),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Muscles Percentage:', bold: true),
                  kTextbody(' 20 %', color: kColorPrimary),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Water Percentage:', bold: true),
                  kTextbody(' 50 %', color: kColorPrimary),
                ],
              ),
            ),

            // Last Body Composition
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment(0.01, -1.0),
                  height: 30.0,
                  width: Get.width / 1.7,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(15.0),
                    ),
                    color: const Color(0xFF414042),
                  ),
                  child: Center(
                    child: Text(
                      'Last Body Composition',
                      style: GoogleFonts.cairo(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                kTextbody('03/06/201', paddingH: 36),
              ],
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Total Weight:', bold: true),
                  kTextbody(' 70 KG', color: kColorPrimary),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Fats Percentage:', bold: true),
                  kTextbody(' 30 %', color: kColorPrimary),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Muscles Percentage:', bold: true),
                  kTextbody(' 20 %', color: kColorPrimary),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  kTextbody('Water Percentage:', bold: true),
                  kTextbody(' 50 %', color: kColorPrimary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
