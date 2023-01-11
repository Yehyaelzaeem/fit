import 'package:app/app/modules/notification_api.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainUnAuth extends StatefulWidget {
  const MainUnAuth({Key? key}) : super(key: key);

  @override
  _MainUnAuthState createState() => _MainUnAuthState();
}

class _MainUnAuthState extends State<MainUnAuth> {
  void listenNotifications()=>NotificationApi.onNotifications.stream.listen(onClickedNotification);
  void onClickedNotification(String? payLoad)=>print("NotificationApi Function TODO Navigate to another screen and take payload to display");
  @override
  void initState() {
    super.initState();
    NotificationApi.init(isScheduled:true);
    listenNotifications();
/*    NotificationApi.showScheduledNotification(
      scheduleDate: DateTime.now().add(Duration(seconds: 10)),
      title: "Dinner",
      body: "Do not forget Dinner",
      payLoad: "Hussam.abs", ///<< to be displayed in new page
    );*/
  }
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
              width:150,
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
                NotificationApi.showNotification(
                  title: "Test Notification",
                  body: "Hey Im Notification",
                  payLoad: "Hussam.abs" ///<< to be displayed in new page
                );
            //  Get.toNamed(Routes.LOGIN);
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
                NotificationApi.showScheduledNotification(
                  scheduleDate: DateTime.now().add(Duration(seconds: 10)),
                  title: "Dinner",
                    body: "Do not forget Dinner",
                    payLoad: "Hussam.abs", ///<< to be displayed in new page
                );
                final snackBar = SnackBar(content: kTextHeader("showScheduledNotification 10 seconds"),backgroundColor: Colors.red,);
                ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(snackBar);
                //Get.toNamed(Routes.REGISTER);
              },
            ),
          ),
        ],
      ),
    );
  }
}
