import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/modules/diary/add_new_food.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../pdf_viewr.dart';
import '../../main_un_auth.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({Key? key}) : super(key: key);

  @override
  _DiaryViewState createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  GlobalKey<FormState> key = GlobalKey();
  bool isLoading = true;

  String? lastSelectedDate;
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
  TextEditingController controller = TextEditingController();
  List<SingleImageItem> list = [];

  String? apiDate;

  void getDiaryData(String _date) async {
    lastSelectedDate = _date;
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
            workDesc = response.data!.dayWorkouts == null ? " " : response.data!.dayWorkouts!.workoutDesc!;
            controller.text = response.data!.dayWorkouts == null ? " " : response.data!.dayWorkouts!.workoutDesc!;
            WorkOutData = response.data!.dayWorkouts == null ? " " : response.data!.dayWorkouts!.workoutType!;
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
          print("Percentage ${response.data!.proteins!.caloriesTotal!.progress!.percentage!.toDouble()} For ${response.data!.proteins!.caloriesTotal!.taken} / ${response.data!.proteins!.caloriesTotal!.imposed}");
        } else {
          if (lastSelectedDate != null && lastSelectedDate!.isNotEmpty) {
            getDiaryData(lastSelectedDate!);
          } else {
            getDiaryData(DateTime.now().toString().substring(0, 10));
          }
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

    await ApiProvider().updateDiaryData(workOut: workOut, workout_desc: workDesc, date: apiDate!).then((value) {
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

  bool IsLogggd = false;
  bool getLog = true;
  void getFromCash() async {
    IsLogggd = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    setState(() {
      getLog = false;
    });
    if (IsLogggd != true) {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => UnAuthView(),
      //     ),
      //     (Route<dynamic> route) => false);
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
      body: getLog
          ? Center()
          : !IsLogggd
              ? MainUnAuth()
              : Stack(
                  children: [
                    ListView(
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
                                      '         Calories Calculator       ',
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
                                downloadFile(response.data!.pdf!);
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
                                                  child: Container(width: MediaQuery.of(context).size.width / 4, height: 50, margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0), decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(5)), child: Center(child: kTextHeader('Yesterday', color: Colors.white, bold: true, size: 14))),
                                                ),
                                                Container(width: MediaQuery.of(context).size.width / 1.5, height: 50, margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)), child: Center(child: kTextHeader('${date}', color: Colors.black87, bold: true, size: 14))),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(width: MediaQuery.of(context).size.width / 1.5, height: 50, margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)), child: Center(child: kTextHeader('${date}', color: Colors.black87, bold: true, size: 14))),
                                                InkWell(
                                                  onTap: () {
                                                    lastSelectedDate = response.data!.days![0].date!;
                                                    getDiaryData(response.data!.days![0].date!);
                                                  },
                                                  child: Container(width: MediaQuery.of(context).size.width / 4, height: 50, margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0), decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(5)), child: Center(child: kTextHeader('Today', color: Colors.white, bold: true, size: 14))),
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
                                          child: GridView.builder(
                                            itemCount: length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
                                            itemBuilder: (BuildContext context, int index) {
                                              return InkWell(
                                                  onTap: () {
                                                    updateWaterData("${index + 1}");
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(list[index].imagePath), fit: BoxFit.cover)),
                                                      ),
                                                      list[index].selected == false
                                                          ? SizedBox()
                                                          : Padding(
                                                              padding: const EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 0),
                                                              child: Container(
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.check_circle,
                                                                    size: 50,
                                                                    color: kColorPrimary,
                                                                  ),
                                                                ),
                                                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
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
                                            return rowItem(response.data!.proteins!.caloriesDetails![indedx], 1);
                                          }),
                                      Divider(thickness: 2),
                                      rowWithProgressBar("Carbs & Fats", response.data!.carbsFats),
                                      staticBar(2),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: response.data!.carbsFats!.caloriesDetails!.length,
                                          itemBuilder: (context, indedx) {
                                            return rowItem(response.data!.carbsFats!.caloriesDetails![indedx], 2);
                                          }),
                                      SizedBox(height: 12),
                                      Divider(),
                                      InkWell(
                                        onTap: () async {
                                          dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MyOtherCalories()));

                                          if (result == null) {
                                            Echo('onback result == null');
                                            ;
                                            setState(() {});
                                            if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: 16),
                                          decoration: BoxDecoration(
                                            color: Color(0xffF1F9E3),
                                          ),
                                          child: kButtonDefault(
                                            'My other calories',
                                            marginH: MediaQuery.of(context).size.width / 6,
                                            paddingV: 0,
                                            shadow: true,
                                            paddingH: 12,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      SizedBox(height: 12),
                                      InkWell(
                                        onTap: () {
                                          if (response.data!.workoutDetailsType == "") {
                                            Fluttertoast.showToast(msg: "Nothing To Show ");
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
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Text(
                                                "Workout Details",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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
                                          decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(50)),
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
                                                            WorkOutData = response.data!.workouts![index].title!;
                                                            workOut = response.data!.workouts![index].id!;
                                                          });
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                                              child: Text(
                                                                "${response.data!.workouts![index].title}",
                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black)),
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
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  kTextbody('Workout Description', size: 20, bold: true),
                                                  EditText(
                                                    // controller: controller,
                                                    radius: 12,
                                                    lines: 5,
                                                    type: TextInputType.multiline,
                                                    value: '${workDesc}',
                                                    // hint: '${workDesc}',
                                                    updateFunc: (text) {
                                                      setState(() {
                                                        workDesc = text;
                                                      });
                                                      print("$workDesc");
                                                    },
                                                    validateFunc: (text) {},
                                                  ),
                                                  SizedBox(height: 8),
                                                  Center(
                                                    child: kButtonDefault('Save', marginH: MediaQuery.of(context).size.width / 5, paddingV: 0, func: () {
                                                      if (workDesc.trim() == "" || workOut == null) {
                                                        Fluttertoast.showToast(msg: "Enter Workout Description");
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

  Widget rowItem(CaloriesDetails item, int type) {
    return GestureDetector(
      onTap: () async {
        if (type == 1) {
          //show screen dialog
          dynamic result = await showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: AddNewFood(
                    date: apiDate!,
                    list: response.data!.proteins!.food,
                    edit: true,
                    id: item.id,
                    showAsDialog: true,
                  ),
                );
              });
          if (result == null) {
            setState(() {});
            if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);
          }
          // dynamic result = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AddNewFood(date: apiDate!, list: response.data!.proteins!.food, edit: true, id: item.id),
          //   ),
          // );
          // if (result == null) {
          //   setState(() {});
          //   if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);
          // }
        } else {
          dynamic result = await showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: AddNewFood(
                    date: apiDate!,
                    list: response.data!.carbsFats!.food,
                    edit: true,
                    id: item.id,
                    showAsDialog: true,
                  ),
                );
              });
          if (result == null) if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);

          // dynamic result = await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => AddNewFood(
          //               date: apiDate!,
          //               list: response.data!.carbsFats!.food,
          //               edit: true,
          //               id: item.id,
          //             )));

          // if (result == null) {
          //   setState(() {});
          //   if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);
          // }
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black87)),
                        child: kTextbody('${item.qty}', color: Colors.black, bold: false, size: 12),
                      ),
                      kTextbody('x', color: Colors.black, bold: false, size: 10),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black87)),
                          child: kTextbody('${item.unit}', color: Colors.black, bold: false, size: 12),
                        ),
                      )
                    ],
                  ),
                ),
                Container(width: MediaQuery.of(context).size.width / 3, padding: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey[500]!)), child: kTextbody('${item.quality}', color: Color(int.parse("0xFF${item.color}")), bold: false, size: 12)),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kTextbody('${item.calories}', color: Colors.black, bold: false, size: 16),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void onClick() async {
  //   Permission permission = Permission.storage;
  //   bool status = await permission.status.isGranted;
  //   if (status) {
  //     downloadFile('${response.data!.pdf}');
  //     // _showProgressNotification();
  //   } else {
  //     print('Permission is granted: $status');
  //     final requestStatus = permission.request();
  //     print('Request Status: ${await requestStatus.isGranted}');
  //   }
  // }

  void downloadFile(String url) async {
    // try {
    //   Dio dio = Dio();
    //   List<Directory>? directories = await getExternalStorageDirectories();
    //   directories!.forEach((element) {
    //     print(element.path);
    //   });
    //   // print(directory!.path);
    //   String filePath = '/sdcard/download/${url.split("/").last}.pdf';
    //   await dio.download(url, filePath, onReceiveProgress: (received, total) {
    //     String progress = ((received / total) * 100).toStringAsFixed(0) + "%";
    //     print('Progress: $progress');
    Navigator.push(context, MaterialPageRoute(builder: (context) => PDFPreview(res: "$url", name: "Calories Calculator")));
    // });
    // } catch (e) {
    //   print(e);
    // }
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
              kTextHeader('${item!.caloriesTotal!.taken} / ${item.caloriesTotal!.imposed}', bold: false, size: 20, color: Colors.black),
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
                width: MediaQuery.of(context).size.width * (item.caloriesTotal!.progress!.percentage!.toDouble() / 100),
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
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xFF414042),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Center(child: kTextbody('Quantity', color: Colors.white, bold: true, size: 16)),
          ),
          Container(width: MediaQuery.of(context).size.width / 3, child: Center(child: kTextbody('Quality', color: Colors.white, bold: true, size: 16))),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(width: ,),
                kTextbody('Cal.', color: Colors.white, bold: true, size: 16),
                InkWell(
                  onTap: () async {
                    if (type == 1) {
                      dynamic result = await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: AddNewFood(
                                date: apiDate!,
                                list: response.data!.proteins!.food,
                                edit: false,
                                showAsDialog: true,
                              ),
                            );
                          });
                      if (result == null) if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);

                      // dynamic result = await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AddNewFood(
                      //               date: apiDate!,
                      //               list: response.data!.proteins!.food,
                      //               edit: false,
                      //             )));
                      // if (result == null) if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);
                    } else {
                      dynamic result = await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: AddNewFood(
                                date: apiDate!,
                                list: response.data!.carbsFats!.food,
                                edit: false,
                                showAsDialog: true,
                              ),
                            );
                          });
                      if (result == null) if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);

                      // dynamic result = await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AddNewFood(
                      //               date: apiDate!,
                      //               list: response.data!.carbsFats!.food,
                      //               edit: false,
                      //             )));
                      // if (result == null) if (lastSelectedDate != null) getDiaryData(lastSelectedDate!);
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: kColorPrimary),
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.black87,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPobUp(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: SelectableText(
                    "${text}",
                    // textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                )),
          );
        });
  }

  void _launchURL(_url) async => await launch(_url);
}
