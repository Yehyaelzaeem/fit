import 'package:app/config/navigation/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/database/shared_pref.dart';
import '../../../../core/models/user_response.dart';
import '../../../../core/resources/resources.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/view/views.dart';
import '../../../../core/view/widgets/app_dialog.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../../../core/view/widgets/page_lable.dart';
import '../../../home/view/screens/home_screen.dart';
import '../../../home/view/widgets/home_appbar.dart';
import '../../cubits/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit profileCubit;
  bool isLoading = true;

  UserResponse ress = UserResponse();

  void getHomeData() async {
    await ApiProvider().getProfile().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "$value");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getHomeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppbar(type: null),
          SizedBox(height: 8),
          // profile title
          Row(
            children: [
              PageLable(name: "Profile"),
              Spacer(),
              if (!globalIsIosInReview)
                GestureDetector(
                  onTap: () {
                    NavigationService.push(context, Routes.myPackagesView);
                  },
                  child: Center(
                    child: Container(
                      width: deviceWidth / 2,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Color(0xffFFB62B), borderRadius: BorderRadius.circular(64), boxShadow: [
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
                          kTextHeader('Subscribe', size: 16, color: Colors.white, bold: true, paddingH: 16, paddingV: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(width: 26),
            ],
          ),
          SizedBox(height: 12),
          //profile card
          isLoading == true
              ? CircularLoadingWidget()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        child: CachedNetworkImage(
                          imageUrl: "${ress.data!.image}",
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                          placeholder: (ctx, url) {
                            return profileImageHolder();
                          },
                          errorWidget: (context, url, error) {
                            return profileImageHolder();
                          },
                        )),
                    kTextHeader('${ress.data!.name!}'),
                    kTextfooter('ID : ${ress.data!.patientId!}', size: 14, color: Colors.black87, paddingV: 0),
                    SizedBox(height: 14),
                  ],
                ),
              ),

              // edit your profile
              InkWell(
                onTap: () {
                  NavigationService.push(context, Routes.editProfileScreen);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileView()));
                },
                child: Container(
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
              ),

              //Next session
              ress.data!.nextSession == null
                  ? SizedBox()
                  : Container(
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
                              'Next Session',
                              color: Colors.black,
                              size: 16,
                            ),
                            kTextbody(
                              '${ress.data!.nextSession!.day}',
                              color: AppColors.PRIMART_COLOR,
                              size: 16,
                            ),
                            kTextbody(
                              '${ress.data!.nextSession!.sessionDate}',
                              color: Colors.black,
                              size: 16,
                            ),
                          ],
                        )),
                    Positioned(
                        right: 26,
                        top: 3,
                        child: kTextfooter(
                          '${ress.data!.nextSession!.status}',
                          color: kColorPrimary,
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
                    child: kTextbody('${ress.data!.packageRenewalDate}'),
                  ),
                ],
              ),
              // Target
              SizedBox(height: 18),

              ress.data!.target == null ? SizedBox() : PageLable(name: "Target"),
              SizedBox(height: 12),
              ress.data!.target == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Total Weight:', bold: true),
                    kTextbody(' ${ress.data!.target!.totalWeight}', color: kColorPrimary),
                  ],
                ),
              ),
              ress.data!.target == null
                  ? SizedBox()
                  : ress.data!.target == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Fats Percentage:', bold: true),
                    kTextbody(' ${ress.data!.target!.fats}', color: kColorPrimary),
                  ],
                ),
              ),
              ress.data!.target == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Muscles Percentage:', bold: true),
                    kTextbody(' ${ress.data!.target!.muscles}', color: kColorPrimary),
                  ],
                ),
              ),
              ress.data!.target == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Water Percentage:', bold: true),
                    kTextbody('  ${ress.data!.target!.water}', color: kColorPrimary),
                  ],
                ),
              ),
              // Last Body Composition
              SizedBox(height: 18),
              ress.data!.lastBodyComposition == null
                  ? SizedBox()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageLable(name: "Last Body Composition"),
                  ress.data!.lastBodyComposition == null ? kTextbody(' Unknown', paddingH: 36) : kTextbody(' ${ress.data!.lastBodyComposition!.date}', paddingH: 36),
                ],
              ),
              SizedBox(height: 12),
              ress.data!.lastBodyComposition == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Total Weight:', bold: true),
                    kTextbody('${ress.data!.lastBodyComposition!.totalWeight}', color: kColorPrimary),
                  ],
                ),
              ),
              ress.data!.lastBodyComposition == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Fats Percentage:', bold: true),
                    kTextbody('${ress.data!.lastBodyComposition!.fats}', color: kColorPrimary),
                  ],
                ),
              ),
              ress.data!.lastBodyComposition == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Muscles Percentage:', bold: true),
                    kTextbody('${ress.data!.lastBodyComposition!.muscles}', color: kColorPrimary),
                  ],
                ),
              ),
              ress.data!.lastBodyComposition == null
                  ? SizedBox()
                  : Container(
                width: double.infinity,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    kTextbody('Water Percentage:', bold: true),
                    kTextbody('${ress.data!.lastBodyComposition!.water}', color: kColorPrimary),
                  ],
                ),
              ),


// ElevatedButton(onPressed: ()=> NotificationApi.showScheduledNotificationAtTime(), child: Text('alarm')),

              if (ress.data!.showDeleteAccount!) SizedBox(height: 24),
              if (ress.data!.showDeleteAccount!)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      appDialog(
                        title: 'Delete Account',
                        body: 'Are you sure you want to delete your account?',
                        confirmAction: () {
                          ApiProvider().deleteAccount();
                          YemenyPrefs prefs = YemenyPrefs();
                          prefs.logout();
                          NavigationService.pushReplacementAll(context, Routes.authScreen);
                        },
                        confirmText: 'Delete',
                        cancelText: 'Cancel',
                        cancelAction: () {
                          NavigationService.goBack(context);
                        },
                        image: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.warning,
                            color: Colors.orange,
                            size: 34,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Delete account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              if (ress.data!.showDeleteAccount!) SizedBox(height: 40),
            ],
          ),
        ],
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

}