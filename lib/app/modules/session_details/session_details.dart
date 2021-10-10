import 'package:app/app/models/sessions_details_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/transform/views/image_viewr.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../pdf_viewr.dart';

class SessionDetails extends StatefulWidget {
  final int? id;

  const SessionDetails({Key? key, this.id}) : super(key: key);

  @override
  _SessionDetailsState createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {
  bool isLoading = true;

  SessionDetailsResponse sessionResponse = SessionDetailsResponse();

  void getAllSessionData() async {
    await ApiProvider().getSessionDetails(widget.id).then((value) {
      if (value.success == true) {
        setState(() {
          sessionResponse = value;
          isLoading = false;
        });
      } else {
        // Fluttertoast.showToast(msg: "${sessionResponse}");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getAllSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppbar(
            type: null,
          ),
          isLoading == true
              ? CircularLoadingWidget()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal:16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(15.0),
                      ),
                      color: const Color(0xFF414042),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '         Body Composition       ',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => CustomImageViewer(
                          image: "${sessionResponse.data!.bodyComposition}")));
                      // downloadFile(sessionResponse.data!.bodyComposition!);
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      // height: double.infinity,
                      decoration: BoxDecoration(
                        // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: Image.asset(
                        "assets/img/view.png",
                        color: kColorPrimary,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "${sessionResponse.data!.date}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              infoRow("Height :", "${sessionResponse.data!.height} "),
              infoRow("Total Weight :", "${sessionResponse.data!.totalWeight}"),
              infoRow("Fat Percentage :", "${sessionResponse.data!.fats}"),
              infoRow("Muscles Percentage :", "${sessionResponse.data!.muscles}"),
              infoRow("Water Percentage :", "${sessionResponse.data!.water}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Center(
                      child: kButton("Follow up", hight: 45, func: () {
                        _launchURL(sessionResponse.data!.followUp!);
                      })),
                ],
              ),
              Container(
                  color: kColorAccent,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Date",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Proteins",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Carbs & Fats",
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Total",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sessionResponse.data!.followUpTable!.length,
                  itemBuilder: (context, index) {
                    return tableItem(sessionResponse.data!.followUpTable![index]);
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget infoRow(String? lable, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Text(
              "${lable}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "${value}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: kColorPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowItem(CarbsFatsTable item) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              kTextbody(' ${item.qty} ', color: Colors.black, bold: false, size: 14),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2.3,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[500]!)),
                  child: kTextbody('${item.quality}',
                      color: Color(int.parse("0xFF${item.color}")), bold: false, size: 12)),
              kTextbody('${item.calories} Cal', color: Colors.black, bold: false, size: 16),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget tableItem(FollowUpTable table) {
    return InkWell(
      onTap: () {
        CustomSheet(
            context: context,
            widget: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  "Water : ${table.water} ml",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(
                  "Workout : ${table.workout != null ? table.workout!.workoutType : "Not Yet"}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kColorPrimary),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${table.workout != null ? table.workout!.workoutDesc : "   "}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Divider(),
                Text(
                  "Proteins",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                table.caloriesTable!.proteinsCaloriesTable!.isEmpty
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text("No Data To Show"),
                  ),
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: table.caloriesTable!.proteinsCaloriesTable!.length,
                    itemBuilder: (context, inIndex) {
                      return rowItem(table.caloriesTable!.proteinsCaloriesTable![inIndex]);
                    }),
                Divider(),
                Text(
                  "Carbs & Fats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                table.caloriesTable!.carbsFatsTable!.isEmpty
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text("No Data To Show"),
                  ),
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: table.caloriesTable!.carbsFatsTable!.length,
                    itemBuilder: (context, inIndex) {
                      return rowItem(table.caloriesTable!.carbsFatsTable![inIndex]);
                    }),
              ],
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
            color: Colors.grey[300],
            child: Row(
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      table.caloriesTable!.carbsFatsTable!.isNotEmpty ||
                          table.caloriesTable!.proteinsCaloriesTable!.isNotEmpty
                          ? Icon(Icons.keyboard_arrow_down_outlined)
                          : SizedBox(),
                      Text(
                        "${table.date}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.black87,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        "${table.proteinsCalories!.taken}/${table.proteinsCalories!.imposed}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.black87,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        "${table.carbsFatsCalories!.taken}/${table.carbsFatsCalories!.imposed}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.black87,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(),
                      Text(
                        "${table.total!.taken!} / ${table.total!.imposed}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void onClick() async {
    Permission permission = Permission.storage;
    bool status = await permission.status.isGranted;
    if (status) {
      downloadFile('${sessionResponse.data!.bodyComposition}');
    } else {
      print('Permission is granted: $status');
      final requestStatus = permission.request();
      print('Request Status: ${await requestStatus.isGranted}');
    }
  }

  void downloadFile(String url) async {
    // try {
    // Dio dio = Dio();
    // List<Directory>? directories = await getExternalStorageDirectories();
    // directories!.forEach((element) {
    //   print(element.path);
    // });
    // String filePath = '/sdcard/download/${url.split("/").last}.jpeg';
    // print(filePath);
    // await dio.download(url, filePath, onReceiveProgress: (received, total) {
    //   String progress = ((received / total) * 100).toStringAsFixed(0) + "%";
    //   print('Progress: $progress');
    //   _showProgressNotification();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PDFPreview(res: "$url", name: "Body Composition")));

    // });
    // } catch (e) {
    //   if (e.hashCode == 17) {
    //     print("Exist");
    //   } else {
    //     print(e);
    //   }
    // }
  }

  void _launchURL(_url) async => await launch(_url);

// Future<void> _showProgressNotification() async {
//   const int maxProgress = 5;
//   for (int i = 0; i <= maxProgress; i++) {
//     await Future<void>.delayed(const Duration(seconds: 1), () async {
//       final AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails(
//               'progress channel', 'progress channel', 'progress channel description',
//               channelShowBadge: false,
//               importance: Importance.defaultImportance,
//               priority: Priority.defaultPriority,
//               showProgress: false,
//               onlyAlertOnce: true,
//               maxProgress: maxProgress,
//               progress: i);
//       final NotificationDetails platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);
//       await FlutterLocalNotificationsPlugin().show(
//         0,
//         'Body Composition',
//         'Image Downloaded',
//         platformChannelSpecifics,
//         payload: 'item x',
//       );
//     });
//   }
// }
}
