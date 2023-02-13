import 'package:app/app/models/sessions_details_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/transform/views/image_viewr.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        Fluttertoast.showToast(msg: "Server Error");
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
          HomeAppbar(type: null),
          isLoading == true
              ? CircularLoadingWidget()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
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
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomImageViewer(
                                    image:
                                    "${sessionResponse.data!.bodyComposition}",
                                    tite: "Body Composition",
                                  )));
                      // downloadFile(sessionResponse.data!.bodyComposition!);
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      margin: EdgeInsets.symmetric(
                          horizontal: 18, vertical: 4),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              infoRow("Height :", "${sessionResponse.data!.height} "),
              infoRow("Total Weight :",
                  "${sessionResponse.data!.totalWeight}"),
              infoRow(
                  "Fats Percentage :", "${sessionResponse.data!.fats}"),
              infoRow("Muscles Percentage :",
                  "${sessionResponse.data!.muscles}"),
              infoRow(
                  "Water Percentage :", "${sessionResponse.data!.water}"),
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
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Day-to-Day Details",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
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
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sessionResponse.data!.followUpTable!.length,
                  itemBuilder: (context, index) {
                    return tableItem(
                        sessionResponse.data!.followUpTable![index]);
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
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: kColorPrimary),
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
              kTextbody(' ${item.qty} ',
                  color: Colors.black, bold: false, size: 14),
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
                      color: Color(int.parse("0xFF${item.color}")),
                      bold: false,
                      size: 12)),
              kTextbody('${item.calories} Cal',
                  color: Colors.black, bold: false, size: 16),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ExpandableNotifier(
          initialExpanded:false,
          child: ScrollOnExpand(
            scrollOnExpand: false,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme:
              const ExpandableThemeData(
                headerAlignment:
                ExpandablePanelHeaderAlignment
                    .center,
                tapBodyToCollapse: false,
              ),
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kTextbody("  Date  ", bold: true),
                  SizedBox(width: 14,),
                  kTextbody("${table.date}", bold: true),
                  Spacer(),
                  table.caloriesTable!.carbsFatsTable!.isNotEmpty ||
                      table.caloriesTable!.proteinsCaloriesTable!.isNotEmpty
                      ? Image.asset(
                    'assets/big_logo.png',
                    scale: 20,
                  )
                      : SizedBox(),
                ],
              ),
              expanded: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kTextbody('  Proteins  '),
                      kTextbody('  Carbs  '),
                      kTextbody('  Fats  '),
                      kTextbody('  Total  '),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kTextbody(
                        "${table.proteinsCalories?.taken} / ${table
                            .proteinsCalories?.imposed}",
                      ),
                      kTextbody(
                        "${table.carbsFatsCalories?.taken} / ${table
                            .carbsFatsCalories?.imposed}",
                      ),
                      kTextbody(
                        "${table.fatsCalories?.taken} / ${table.fatsCalories
                            ?.imposed}",
                      ),
                      kTextbody(
                        "${table.total?.taken} / ${table.total?.imposed}",
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  Center(
                      child: kButton("  Details  ", hight: 26, func: () {
                        CustomSheet(
                          hight: MediaQuery.of(context).size.height*0.4,
                            context: context,
                            widget: Padding(
                              padding: const EdgeInsets.only(left:12.0,right:12.0,top:20.0,),
                              child: Scrollbar(
                                isAlwaysShown: true,
                                child: ListView(
                                  children: [
                                    VerticalSpace(),
                                    Text(
                                      "Water : ${table.water} ml",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    VerticalSpace(),
                                    Divider(),
                                    Text(
                                      "Workout : ${table.workout != null ? table
                                          .workout!.workoutType : "Not Yet"}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: kColorPrimary),
                                    ),
                                    Text(
                                      "${table.workout != null ? table.workout!
                                          .workoutDesc : "   "}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    VerticalSpace(),
                                    Divider(),
                                    Text(
                                      "Sleep time : ${table.sleepingTime != null
                                          ? table.sleepingTime?.sleepingDuration
                                          : "Not Yet"}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: kColorPrimary),
                                    ),
                                    Text(
                                      "${table.sleepingTime != null
                                          ? table.sleepingTime?.sleepingStatus?.name
                                          : "   "}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    VerticalSpace(),
                                    Divider(),
                                    Text(
                                      "Proteins",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    table.caloriesTable!.proteinsCaloriesTable!
                                        .isEmpty
                                        ? Padding(
                                      padding: EdgeInsets.symmetric(vertical: 50),
                                      child: Center(
                                        child: Text("No Data To Show"),
                                      ),
                                    )
                                        : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: table.caloriesTable!
                                            .proteinsCaloriesTable!.length,
                                        itemBuilder: (context, inIndex) {
                                          return rowItem(table.caloriesTable!
                                              .proteinsCaloriesTable![inIndex]);
                                        }),
                                    VerticalSpace(),
                                    Divider(),
                                    Text(
                                      "Carbs",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                                        itemCount: table
                                            .caloriesTable!.carbsFatsTable!.length,
                                        itemBuilder: (context, inIndex) {
                                          return rowItem(table.caloriesTable!
                                              .carbsFatsTable![inIndex]);
                                        }),
                                    VerticalSpace(),
                                    Divider(),
                                    Text(
                                      "Fats",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // table.caloriesTable!.fatsTable!.isEmpty
                                    table.caloriesTable!.fatsTable!.isEmpty
                                        ? Padding(
                                      padding: EdgeInsets.symmetric(vertical: 50),
                                      child: Center(
                                        child: Text("No Data To Show"),
                                      ),
                                    )
                                        : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                        table.caloriesTable!.fatsTable!.length,
                                        itemBuilder: (context, inIndex) {
                                          return rowItem(table
                                              .caloriesTable!.fatsTable![inIndex]);
                                        }),
                                    VerticalSpace(),
                                  ],
                                ),
                              ),
                            ));
                      })),
                ],
              ),
              collapsed: const SizedBox(),
              builder: (_, collapsed,
                  expanded) {
                return Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme:
                  const ExpandableThemeData(
                      crossFadePoint:
                      0),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
Widget VerticalSpace(){
    return SizedBox(
      height: 6,
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PDFPreview(res: "$url", name: "Body Composition")));

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
