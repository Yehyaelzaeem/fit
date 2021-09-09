import 'dart:io';

import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/modules/diary/add_new_food.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../un_auth_view.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({Key? key}) : super(key: key);

  @override
  _DiaryViewState createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  GlobalKey<FormState> key = GlobalKey();
  bool isLoading = true;

  late String date;

  late String WorkOutData;
  DayDetailsResponse response = DayDetailsResponse();
  late String qtyProtine, foodProtine;
  late int length;
  bool ShowLoader = false;
  int? workOut;
  late String workDesc;
  late bool isToday;
  bool noSessions = false;

  List<SingleImageItem> list = [];

  String? apiDate;

  void getDiaryData(String _date) async {
    setState(() {
      isLoading = true;
    });
    print("====> Gittng Day $_date Info ");

    await ApiProvider().getDiaryView(_date).then((value) {
      if (value.success == false && value.data == null) {
        setState(() {
          isLoading = false;
          noSessions = true;
        });
      } else {
        if (value.data != null) {
          setState(() {
            response = value;
            isLoading = false;
            ShowLoader = false;
            length = response.data!.water! + 3;
            workOut = response.data!.workouts![0].id;
            workDesc = response.data!.dayWorkouts == null
                ? " "
                : response.data!.dayWorkouts!.workoutDesc!;
            WorkOutData = response.data!.dayWorkouts == null
                ? " "
                : response.data!.dayWorkouts!.workoutType!;
            list.clear();
          });

          if (response.data!.days![0].active == true) {
            setState(() {
              isToday = true;
            });
          } else {
            setState(() {
              isToday = false;
            });
          }
          for (int i = 0; i < response.data!.days!.length; i++) {
            if (response.data!.days![i].active == true) {
              setState(() {
                date = response.data!.days![i].dateFormat!;
                apiDate = response.data!.days![i].date;
              });
            } else {}
          }

          for (int i = 1; i <= length; i++) {
            if (i <= response.data!.water!) {
              setState(() {
                list.add(
                  SingleImageItem(id: i, imagePath: 'assets/img/im_holder1.png', selected: true),
                );
              });
            } else {
              setState(() {
                list.add(
                  SingleImageItem(id: i, imagePath: 'assets/img/im_holder1.png', selected: false),
                );
              });
            }
          }
          print(
              "Percentage ${response.data!.proteins!.caloriesTotal!.progress!.percentage!.toDouble()} For ${response.data!.proteins!.caloriesTotal!.taken} / ${response.data!.proteins!.caloriesTotal!.imposed}");
        } else {
          getDiaryData(DateTime.now().toString().substring(0, 10));
          setState(() {
            response = value;
            isLoading = false;
            ShowLoader = false;
            date = _date;
          });
          print("error");
        }
      }
    });
  }

  void deleteItem(int id, String _date) async {
    await ApiProvider().deleteCalorie("delete_calories_details", id).then((value) {
      if (value.success == true) {
        setState(() {
          isLoading = false;
        });
        getDiaryData(apiDate!);
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        setState(() {
          isLoading = false;
        });
        print("error");
      }
    });
  }

  void updateWaterData(String water) async {
    print("Water ==== > $water / $length");
    print("Water ==== > ${list.length}");
    setState(() {
      ShowLoader = true;
    });
    await ApiProvider().updateDiaryData(water: water, date: apiDate!).then((value) {
      if (value.success == true) {
        setState(() {
          ShowLoader = false;
        });
        getDiaryData(apiDate!);
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        // Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void updateWork() async {
    setState(() {
      ShowLoader = true;
    });

    await ApiProvider()
        .updateDiaryData(workOut: workOut, workout_desc: workDesc, date: apiDate!)
        .then((value) {
      if (value.success == true) {
        setState(() {
          ShowLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        setState(() {
          ShowLoader = false;
        });
        Fluttertoast.showToast(msg: "Server Error");
        print("error");
      }
    });
  }

  void getFromCash() async {
    bool IsLogggd = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    if (IsLogggd != true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UnAuthView(),
          ),
          (Route<dynamic> route) => false);
    } else {
      getDiaryData(DateTime.now().toString().substring(0, 10));
    }
  }

  @override
  void initState() {
    getFromCash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                alignment: Alignment(0.01, -1.0),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF414042),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Calories Calculator',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Image.asset('assets/img/ic_pdf.png'),
                          kTextHeader('PDF', color: Colors.white)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        downloadFile(response.data!.pdf!);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: kColorPrimary,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              isLoading == true
                  ? CircularLoadingWidget()
                  : isLoading == false && noSessions == true
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 200),
                          child: Center(
                            child: Text(
                              "Book Your Next Session",
                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            isToday == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          print(response.data!.days![1].date!);
                                          getDiaryData(response.data!.days![1].date!);
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            height: 50,
                                            margin:
                                                EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                            decoration: BoxDecoration(
                                                color: kColorPrimary,
                                                borderRadius: BorderRadius.circular(5)),
                                            child: Center(
                                                child: kTextHeader('Yesterday',
                                                    color: Colors.white, bold: true, size: 14))),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context).size.width / 1.5,
                                          height: 50,
                                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(5)),
                                          child: Center(
                                              child: kTextHeader('${date}',
                                                  color: Colors.black87, bold: true, size: 14))),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width / 1.5,
                                          height: 50,
                                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(5)),
                                          child: Center(
                                              child: kTextHeader('${date}',
                                                  color: Colors.black87, bold: true, size: 14))),
                                      InkWell(
                                        onTap: () {
                                          print(response.data!.days![0].date!);
                                          getDiaryData(response.data!.days![0].date!);
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            height: 50,
                                            margin:
                                                EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                            decoration: BoxDecoration(
                                                color: kColorPrimary,
                                                borderRadius: BorderRadius.circular(5)),
                                            child: Center(
                                                child: kTextHeader('Today',
                                                    color: Colors.white, bold: true, size: 14))),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Water : ${response.data!.water ?? "0"}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  // SizedBox(),
                                  Icon(
                                    Icons.swap_vert,
                                    size: 25,
                                    color: kColorPrimary,
                                  )
                                ],
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height / 3,
                                child: GridView.builder(
                                  itemCount: length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0),
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                          updateWaterData("${index + 1}");
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(list[index].imagePath),
                                                      fit: BoxFit.cover)),
                                            ),
                                            list[index].selected == false
                                                ? SizedBox()
                                                : Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 5, left: 5, bottom: 8, top: 3),
                                                    child: Container(
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.check_circle,
                                                          size: 50,
                                                          color: kColorPrimary,
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.5)),
                                                    ),
                                                  ),
                                          ],
                                        ));
                                  },
                                )),
                            Divider(
                              thickness: 2,
                            ),
                            rowWithProgressBar("Proteins", response.data!.proteins),
                            staticBar(1),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: response.data!.proteins!.caloriesDetails!.length,
                                itemBuilder: (context, indedx) {
                                  return rowItem(response.data!.proteins!.caloriesDetails![indedx]);
                                }),
                            SizedBox(height: 24),
                            rowWithProgressBar("Carbs & Fats", response.data!.carbsFats),
                            staticBar(2),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: response.data!.carbsFats!.caloriesDetails!.length,
                                itemBuilder: (context, indedx) {
                                  return rowItem(
                                      response.data!.carbsFats!.caloriesDetails![indedx]);
                                }),
                            SizedBox(height: 12),
                            Divider(),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => MyOtherCalories()));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: Color(0xffF1F9E3),
                                ),
                                child: kButtonDefault('My other calories',
                                    marginH: MediaQuery.of(context).size.width / 6,
                                    paddingV: 0,
                                    shadow: true,
                                    paddingH: 12),
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                if (response.data!.workoutDetailsType == "") {
                                  Fluttertoast.showToast(msg: "Nthing To Show ");
                                } else if (response.data!.workoutDetailsType == "link") {
                                  _launchURL(response.data!.workoutDetails);
                                } else {
                                  showPobUp(response.data!.workoutDetails!);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 16,),
                                    Text(
                                      "Workout Details",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Icon(
                                        Icons.upload_sharp,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                height: 45,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 72,
                                ),
                                decoration: BoxDecoration(
                                    color: kColorPrimary, borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width / 14),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Text(
                                    "Workout",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                CustomSheet(
                                    context: context,
                                    widget: Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: ListView.builder(
                                          itemCount: response.data!.workouts!.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  WorkOutData =
                                                      response.data!.workouts![index].title!;
                                                  workOut = response.data!.workouts![index].id!;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 16),
                                                    child: Text(
                                                      "${response.data!.workouts![index].title}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                            );
                                          }),
                                    ));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 5),
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${WorkOutData}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black)),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),
SizedBox(height: 20,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        kTextbody('Workout Description', size: 20, bold: true),
                                        EditText(
                                          radius: 12,
                                          lines: 5,
                                          value: '',
                                          hint: '${workDesc}',
                                          updateFunc: (text) {
                                            setState(() {
                                              workDesc = text;
                                            });
                                          },
                                          validateFunc: (text) {},
                                        ),
                                        SizedBox(height: 8),
                                        Center(
                                          child: kButtonDefault('Save',
                                              marginH: MediaQuery.of(context).size.width / 5,
                                              paddingV: 0, func: () {
                                            if (workDesc == null || workOut == null) {
                                              Fluttertoast.showToast(msg: "Please Complete Data");
                                            } else {
                                              updateWork();
                                            }
                                          }, shadow: true, paddingH: 50),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
            ],
          ),
          ShowLoader == false
              ? SizedBox()
              : Container(
                  child: Center(
                    child: CircularLoadingWidget(),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(.9),
                )
        ],
      ),
    );
  }

  Widget rowItem(CaloriesDetails item) {
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
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black87)),
                      child: kTextbody('${item.qty}', color: Colors.black, bold: false, size: 14),
                    ),
                    kTextbody('x', color: Colors.black, bold: false, size: 10),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black87)),
                      child: kTextbody('${item.unit}', color: Colors.black, bold: false, size: 14),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[500]!)),
                  child: kTextbody('${item.quality}',
                      color: Color(int.parse("0xFF${item.color}")), bold: false, size: 12)),
              Row(
                children: [
                  kTextbody('${item.calories}',
                      color: Color(int.parse("0xFF${item.color}")), bold: false, size: 16),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      deleteItem(item.id!, date);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 2,
          color: Colors.grey[500],
        ),
      ],
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

  Widget rowWithProgressBar(String Title, Proteins? item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '${Title}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => AddNewFood(
                  //                   list: response.data!.proteins!.food,
                  //                 )));
                  //   },
                  //   child: Container(
                  //       decoration: BoxDecoration(color: kColorPrimary),
                  //       child: Icon(
                  //         Icons.add,
                  //         color: Color(0xFF414042),
                  //       )),
                  // ),
                ],
              ),
              kTextHeader('${item!.caloriesTotal!.taken} / ${item.caloriesTotal!.imposed}',
                  bold: false, size: 20, color: Colors.black),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Stack(
            children: [
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width *
                    (item.caloriesTotal!.progress!.percentage!.toDouble() / 100),
                decoration: BoxDecoration(
                  color: Color(int.parse("0xFF${item.caloriesTotal!.progress!.bg}")),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget staticBar(int type) {
    return Container(
      color: Color(0xFF414042),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              child:
                  Center(child: kTextbody('Quantity', color: Colors.white, bold: true, size: 16)),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 2.2,
                child:
                    Center(child: kTextbody('Quality', color: Colors.white, bold: true, size: 16))),
            Container(
              width: MediaQuery.of(context).size.width / 4.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  kTextbody('Cal.', color: Colors.white, bold: true, size: 16),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (type == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewFood(
                                      date: apiDate!,
                                      list: response.data!.proteins!.food,
                                    )));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewFood(
                                      date: apiDate!,
                                      list: response.data!.carbsFats!.food,
                                    )));
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(color: kColorPrimary),
                        child: Icon(
                          Icons.add,
                          color: Colors.black87,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPobUp(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(8),
            child: Center(
              child: Text(
                "${text}",
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
          );
        });
  }

  void _launchURL(_url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}
