
import 'package:app/config/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../config/navigation/routes.dart';
import '../../../../core/models/message_details_response.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/page_lable.dart';
import '../../../home/view/widgets/home_appbar.dart';
import '../../../pdf_viewr.dart';

class NotificationDetailsView extends StatefulWidget {
  final int? id;

  const NotificationDetailsView({Key? key, this.id}) : super(key: key);

  @override
  _NotificationDetailsViewState createState() =>
      _NotificationDetailsViewState();
}

class _NotificationDetailsViewState extends State<NotificationDetailsView> {
  bool isLoading = true;

  MessageDetailsResponse ressponse = MessageDetailsResponse();

  void getData() async {
    await ApiProvider()
        .getMessagesDetailsData(widget.id ?? 0)
        .then((value) async {
      if (value.success == true) {
        setState(() {
          ressponse = value;
          isLoading = false;
        });
      } else {
        setState(() {
          ressponse = value;
        });
        Fluttertoast.showToast(msg: "Check Internet Connection");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    NavigationService.pushReplacement(context, Routes.homeScreen);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => HomeView()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: ListView(
          children: [
            HomeAppbar(
              type: null,
              removeNotificationsCount: true,
              onBack: () {
                Get.offAllNamed(Routes.homeScreen);
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                PageLable(name: "Messages"),
              ],
            ),
            isLoading == true
                ? CircularLoadingWidget()
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "${ressponse.data!.subject}",
                        style: TextStyle(color: kColorPrimary, fontSize: 20),
                      ),
                    ),
                  ),
            isLoading == true
                ? SizedBox()
                : Center(
                    child: Html(
                      data: """${ressponse.data!.message}""",
                    ),
                  ),
            ressponse.data?.hasPlan == true
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFPreview(
                                      res: ressponse.data?.planUrl??"",
                                      name: "Plan Details")));
                  /*    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NotificationPlan(
                                    link: ressponse.data?.planUrl ??
                                        "https://fofclinic.com/",
                                  )));*/
                    },
                    child: Image.asset(
                      "assets/messages_icon.png",
                      scale: 8,
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
