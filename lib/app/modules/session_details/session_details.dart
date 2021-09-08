import 'dart:io';

import 'package:app/app/models/sessions_details_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

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
                        PageLable(name: "Body Composition"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                downloadFile(sessionResponse.data!.bodyComposition!);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Icon(
                                  Icons.download_sharp,
                                  color: kColorPrimary,
                                  size: 30,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
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
                            child: kButton("Follow Up", hight: 45, func: () {
                          downloadFile(sessionResponse.data!.followUp!);
                        })),
                      ],
                    ),
                    Container(
                        color: kColorAccent,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
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
                              width: MediaQuery.of(context).size.width / 4.5,
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
                              width: MediaQuery.of(context).size.width / 4.5,
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
                              width: MediaQuery.of(context).size.width / 4.5,
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
                          return InkWell(
                            onTap: () {
                              CustomSheet(
                                  context: context,
                                  widget: ListView(
                                    padding: EdgeInsets.all(16),
                                    children: [
                                      Text(
                                        "Water : ${sessionResponse.data!.followUpTable![index].water}",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Divider(),
                                      Text(
                                        "Workout : ${sessionResponse.data!.followUpTable![index].workout!.workoutType!}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: kColorPrimary),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        " ${sessionResponse.data!.followUpTable![index].workout!.workoutDesc!}",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      Divider(),
                                      Text(
                                        "Proteins",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      sessionResponse.data!.followUpTable![index].caloriesTable!
                                              .proteinsCaloriesTable!.isEmpty
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(vertical: 50),
                                              child: Center(
                                                child: Text("No Data To Show"),
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: sessionResponse.data!.followUpTable![index]
                                                  .caloriesTable!.proteinsCaloriesTable!.length,
                                              itemBuilder: (context, inIndex) {
                                                return rowItem(sessionResponse
                                                    .data!
                                                    .followUpTable![index]
                                                    .caloriesTable!
                                                    .proteinsCaloriesTable![inIndex]);
                                              }),
                                      Divider(),
                                      Text(
                                        "Carbs & Fats",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      sessionResponse.data!.followUpTable![index].caloriesTable!
                                              .proteinsCaloriesTable!.isEmpty
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(vertical: 50),
                                              child: Center(
                                                child: Text("No Data To Show"),
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: sessionResponse.data!.followUpTable![index]
                                                  .caloriesTable!.carbsFatsTable!.length,
                                              itemBuilder: (context, inIndex) {
                                                return rowItem(sessionResponse
                                                    .data!
                                                    .followUpTable![index]
                                                    .caloriesTable!
                                                    .carbsFatsTable![inIndex]);
                                              }),
                                    ],
                                  ));
                            },
                            child: tableItem(sessionResponse.data!.followUpTable![index]),
                          );
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
              kTextbody(' ${item.qty} ',
                  color: Color(int.parse("0xFF${item.color}")), bold: false, size: 14),
              Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[500]!)),
                  child: kTextbody('${item.quality}', color: Colors.black, bold: false, size: 12)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
          color: Colors.grey[300],
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.date}",
                      style: TextStyle(color: Colors.black, fontSize: 15),
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
                width: MediaQuery.of(context).size.width / 4.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.proteinsCalories!.taken}/${table.proteinsCalories!.imposed}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
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
                width: MediaQuery.of(context).size.width / 4.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.carbsFatsCalories!.taken}/${table.carbsFatsCalories!.imposed}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
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
                width: MediaQuery.of(context).size.width / 4.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.proteinsCalories!.taken! + table.carbsFatsCalories!.taken!}/"
                      "${table.proteinsCalories!.imposed! + table.carbsFatsCalories!.imposed!}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void downloadFile(String file) async {
    print("Downloading File ====>${file}");
    if (file == "") {
      Fluttertoast.showToast(msg: "No File Exists To Download");
    } else {
      Dio dio = Dio();
      var tempDir = await getTemporaryDirectory();
      String fullPath = tempDir.path + "/File.pdf'";
      print('full path ${fullPath}');
      download2(dio, file, fullPath);
      Fluttertoast.showToast(msg: "File downloaded At ${fullPath} ");
    }
  }
}
