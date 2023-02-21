import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/pdf_viewr.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';

class DiaryController extends GetxController {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController textEditController = TextEditingController();
  RxList<SingleImageItem> waterBottlesList = RxList();
  RxList<CaloriesDetails> caloriesDetails = RxList();
  RxList<CaloriesDetails> carbsDetails = RxList();
  RxList<CaloriesDetails> fatsDetails = RxList();
  final response = DayDetailsResponse().obs;
  FocusNode workoutTitleDescFocus = FocusNode();
  final isLoading = false.obs;
  final refreshLoadingProtine = false.obs;
  final refreshLoadingCarbs = false.obs;
  final refreshLoadingFats = false.obs;
  final isToday = false.obs;
  final noSessions = false.obs;
  final showLoader = false.obs;
  final lastSelectedDate = ''.obs;
  final date = ''.obs;
  final apiDate = ''.obs;
  final workOutData = ''.obs;
  final qtyProtine = ''.obs;
  final foodProtine = ''.obs;
  String? workDesc;
  final length = 0.obs;
  final workOut = 0.obs;

  getNotifications()async{
    if(await Permission.accessNotificationPolicy.isPermanentlyDenied&&await Permission.accessNotificationPolicy.isDenied&&await Permission.accessNotificationPolicy.isRestricted){
        Permission.notification.request();
    }
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
    await Permission.notification.isRestricted.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });   await Permission.notification.isPermanentlyDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }
  @override
  void onInit() {
    super.onInit();
    getNotifications();
    getFromCash();
    //   _initData();
  }

  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  final isLogggd = false.obs;

  void getFromCash() async {
    isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    if (isLogggd.value != true) {
      // Navigator.pushAndRemoveUntil(
      //     Get.context!,
      //     MaterialPageRoute(
      //       builder: (context) => UnAuthView(),
      //     ),
      //     (Route<dynamic> route) => false);
    } else {
      getDiaryData(DateTime.now().toString().substring(0, 10));
    }
  }

  void getDiaryDataRefreshResponse(String _date) async {
    isLoading.value = true;
    try {
      await ApiProvider().getDiaryView(_date).then((value) {
        if (value.success == false && value.data == null) {
          noSessions.value = true;
        } else {
          response.value = value;
        }
      });
    } catch (e) {}
    isLoading.value = false;
  }

  void getDiaryData(String _date) async {
    if (isLoading.value) return;
    if (refreshLoadingProtine.value) return;
    if (refreshLoadingCarbs.value) return;
    if (refreshLoadingFats.value) return;
    Echo('getDiaryData');
    lastSelectedDate.value = _date;
    isLoading.value = true;
    caloriesDetails.clear();
    carbsDetails.clear();
    fatsDetails.clear();
    Echo("====> Gittng Day $_date Info ");

    await ApiProvider().getDiaryView(_date).then((value) {
      if (value.success == false && value.data == null) {
      //  isLoading.value = false;
      //  noSessions.value = true;
        SharedHelper().logout();
        Get.offAllNamed(Routes.LOGIN);
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        if (value.data != null) {
          response.value = value;
          isLoading.value = false;
          showLoader.value = false;
          length.value = response.value.data!.water! + 3;
          workOut.value = response.value.data!.workouts![0].id!;
          workDesc = response.value.data!.dayWorkouts == null
              ? " "
              : response.value.data!.dayWorkouts!.workoutDesc!;
          textEditController.text = response.value.data!.dayWorkouts == null
              ? " "
              : response.value.data!.dayWorkouts!.workoutDesc!;
          workOutData.value = response.value.data!.dayWorkouts == null
              ? " "
              : response.value.data!.dayWorkouts!.workoutType!;
          waterBottlesList.clear();

          if (response.value.data!.days![0].active == true) {
            isToday.value = true;
          } else {
            isToday.value = false;
          }
          for (int i = 0; i < response.value.data!.days!.length; i++) {
            if (response.value.data!.days![i].active == true) {
              date.value = response.value.data!.days![i].dateFormat!;
              apiDate.value = response.value.data!.days![i].date!;
            } else {}
          }

          for (int i = 1; i <= length.value; i++) {
            if (i <= response.value.data!.water!) {
              waterBottlesList.add(
                SingleImageItem(
                    id: i,
                    imagePath: 'assets/img/im_holder1.png',
                    selected: true),
              );
            } else {
              waterBottlesList.add(
                SingleImageItem(
                    id: i,
                    imagePath: 'assets/img/im_holder1.png',
                    selected: false),
              );
            }
          }
          Echo(
              "Percentage ${response.value.data!.proteins!.caloriesTotal!.progress!.percentage!.toDouble()} For ${response.value.data!.proteins!.caloriesTotal!.taken} / ${response.value.data!.proteins!.caloriesTotal!.imposed}");
        } else {
          if (lastSelectedDate.value.isNotEmpty) {
            getDiaryData(lastSelectedDate.value);
          } else {
            getDiaryData(DateTime.now().toString().substring(0, 10));
          }
          response.value = value;
          isLoading.value = false;
          showLoader.value = false;
          date.value = _date;
          Echo("error");
        }
        // caloriesDetails.clear();
        // carbsAndFats.clear();
        refreshCaloriesList(
            response.value.data!.proteins!.caloriesDetails ?? []);
        refreshCarbsList(response.value.data!.carbs!.caloriesDetails ?? []);
        refreshFatsList(response.value.data!.fats!.caloriesDetails ?? []);

        // caloriesDetails.addAll(response.value.data!.proteins!.caloriesDetails!);
        // carbsAndFats.addAll(response.value.data!.carbsFats!.caloriesDetails!);
      }
    });
  }

  void refreshDiaryData(String _date, String type) async {
    Echo('refreshDiaryData');
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;
    lastSelectedDate.value = _date;
    response.value = await ApiProvider().getDiaryView(_date);
    if (response.value.data!.proteins!.caloriesDetails!.isEmpty &&
        response.value.data!.carbs!.caloriesDetails!.isEmpty &&
        response.value.data!.fats!.caloriesDetails!.isEmpty) {
      if (type == 'proteins') refreshLoadingProtine.value = false;
      if (type == 'carbs') refreshLoadingCarbs.value = false;
      if (type == 'fats') refreshLoadingFats.value = false;
      return;
    } else {
      // caloriesDetails.removeWhere((element) => element.id == null);
      // carbsAndFats.removeWhere((element) => element.id == null);
      response.value.data!.proteins!.caloriesDetails!.forEach((element) {
        if (caloriesDetails
                .where((element2) => element.id == element2.id)
                .toList()
                .length >
            0) {
          caloriesDetails.forEach((item) {
            if (item.id == element.id) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          refreshCaloriesList(
              response.value.data!.proteins!.caloriesDetails ?? []);
        }
      });
      response.value.data!.carbs!.caloriesDetails!.forEach((element) {
        if (carbsDetails
                .where((element2) => element.id == element2.id)
                .toList()
                .length >
            0) {
          carbsDetails.forEach((item) {
            if (item.id == element.id) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          refreshCarbsList(response.value.data!.carbs!.caloriesDetails ?? []);
        }
      });

      response.value.data!.fats!.caloriesDetails!.forEach((element) {
        if (fatsDetails
                .where((element2) => element.id == element2.id)
                .toList()
                .length >
            0) {
          fatsDetails.forEach((item) {
            if (item.id == element.id) {
              item.quality = element.quality;
              item.qty = element.qty;
              item.calories = element.calories;
            }
          });
        } else {
          refreshFatsList(response.value.data!.fats!.caloriesDetails ?? []);
        }
      });
    }
    caloriesDetails.refresh();
    carbsDetails.refresh();
    fatsDetails.refresh();
    caloriesDetails.forEach((element) {});
    carbsDetails.forEach((element) {});
    carbsDetails.forEach((element) {});
    fatsDetails.forEach((element) {});
    if (type == 'proteins') refreshLoadingProtine.value = false;
    if (type == 'carbs') refreshLoadingCarbs.value = false;
    if (type == 'fats') refreshLoadingFats.value = false;
  }

  Future<void> deleteItemCalories(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        caloriesDetails.removeWhere((element) => element.id == id);
        refreshDiaryData(apiDate.value, type);
      } else {
        caloriesDetails.removeWhere((element) => element.id == id);
        refreshDiaryData(apiDate.value, type);
        Fluttertoast.showToast(msg: "${value.message}");
      }
    });
  }

  Future<void> deleteItemCarbs(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        carbsDetails.removeWhere((element) => element.id == id);
        refreshDiaryData(apiDate.value, type);
      } else {
        carbsDetails.removeWhere((element) => element.id == id);
        refreshDiaryData(apiDate.value, type);
        Fluttertoast.showToast(msg: "${value.message}");
      }
    });
  }

  Future<void> deleteItemFats(int id, String _date, String type) async {
    await ApiProvider()
        .deleteCalorie("delete_calories_details", id)
        .then((value) {
      if (value.success == true) {
        fatsDetails.removeWhere((element) => element.id == id);
        refreshDiaryData(apiDate.value, type);
      } else {
        fatsDetails.removeWhere((element) => element.id == id);
        refreshDiaryData(apiDate.value, type);
        Fluttertoast.showToast(msg: "${value.message}");
      }
    });
  }

  void updateWaterData(String water) async {
    showLoader.value = true;
    await ApiProvider()
        .createDiaryData(water: water, date: apiDate.value)
        .then((value) {
      if (value.success == true) {
        showLoader.value = false;
        getDiaryData(apiDate.value);
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        // Fluttertoast.showToast(msg: "${value.message}");
        Echo("error");
      }
    });
  }

  final workoutLoading = false.obs;

  void updateWork() async {
    workoutLoading.value = true;
    await ApiProvider().createDiaryData(
      workOut: workOut.value,
      workout_desc: workDesc,
      date: apiDate.value,
    ).then((value) {
      if (value.success == true) {
        workoutLoading.value = false;
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        workoutLoading.value = false;
        Fluttertoast.showToast(msg: "Server Error");
        Echo("error");
      }
    });
  }

  void downloadFile(String url) async {
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
            builder: (context) =>
                PDFPreview(res: "$url", name: "Calories Calculator")));
  }

  void showPobUp(String text) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return Dialog(
            child: Container(
                height: MediaQuery.of(Get.context!).size.height / 1.5,
                padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        "${text}",
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          );
        });
  }

  void launchURL(_url) async => await launch(_url);

  void createProtineData(int? food, double _quantity,
      {int? index, required String type}) async {
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;
    await ApiProvider().createDiaryData(
        foodProtine: food, qtyProtiene: _quantity, date: apiDate.value);
    refreshDiaryData(apiDate.value, type);
  }

  void updateProtineData(int? index, int? food, double _quantity,
      {required String type}) async {
    if (type == 'proteins') refreshLoadingProtine.value = true;
    if (type == 'carbs') refreshLoadingCarbs.value = true;
    if (type == 'fats') refreshLoadingFats.value = true;
    await ApiProvider().editDiaryData(
        foodProtine: food,
        qtyProtiene: _quantity,
        date: apiDate.value,
        id: index);
    refreshDiaryData(apiDate.value, type);
  }

  Color getColor(String title) {
    if (title == 'أنتويرب') return Colors.red;
    if (title == 'خقخل') return Colors.red;

    return Colors.black87;
  }

  void refreshCaloriesList(List<CaloriesDetails> list) {
    List<CaloriesDetails> emptyList = [];
    emptyList.addAll(
        caloriesDetails.where((element) => element.qty == null).toList());
    caloriesDetails.clear();
    caloriesDetails.addAll(list);
    caloriesDetails.addAll(emptyList);
    return;
    list.forEach((resItem) {
      if (caloriesDetails.where((item) {
            Echo('item ${item.quality} resItem${resItem.quality}');
            Echo('item ${item.qty} resItem${resItem.qty}');
            return item.quality == resItem.quality && item.qty == resItem.qty;
          }).length >
          0) {
        caloriesDetails.forEach((item) {
          if (item.quality == resItem.quality && item.qty == resItem.qty) {
            item.id = resItem.id;
            item.calories = resItem.calories;
            item.unit = resItem.unit;
          }
        });
      } else {
        caloriesDetails.add(resItem);
      }
    });
  }

  void refreshCarbsList(List<CaloriesDetails> list) {
    List<CaloriesDetails> emptyList = [];
    emptyList
        .addAll(carbsDetails.where((element) => element.qty == null).toList());
    carbsDetails.clear();
    carbsDetails.addAll(list);
    carbsDetails.addAll(emptyList);
    return;
    list.forEach((resItem) {
      if (carbsDetails.where((item) {
            Echo('item ${item.quality} resItem${resItem.quality}');
            Echo('item ${item.qty} resItem${resItem.qty}');
            return item.quality == resItem.quality && item.qty == resItem.qty;
          }).length >
          0) {
        carbsDetails
          ..forEach((item) {
            if (item.quality == resItem.quality && item.qty == resItem.qty) {
              item.id = resItem.id;
              item.calories = resItem.calories;
              item.unit = resItem.unit;
            }
          });
      } else {
        carbsDetails..add(resItem);
      }
    });
  }

  void refreshFatsList(List<CaloriesDetails> list) {
    List<CaloriesDetails> emptyList = [];
    emptyList
        .addAll(fatsDetails.where((element) => element.qty == null).toList());
    fatsDetails.clear();
    fatsDetails.addAll(list);
    fatsDetails.addAll(emptyList);
    return;
    list.forEach((resItem) {
      if (fatsDetails.where((item) {
            Echo('item ${item.quality} resItem${resItem.quality}');
            Echo('item ${item.qty} resItem${resItem.qty}');
            return item.quality == resItem.quality && item.qty == resItem.qty;
          }).length >
          0) {
        fatsDetails
          ..forEach((item) {
            if (item.quality == resItem.quality && item.qty == resItem.qty) {
              item.id = resItem.id;
              item.calories = resItem.calories;
              item.unit = resItem.unit;
            }
          });
      } else {
        fatsDetails..add(resItem);
      }
    });
  }
}

class SingleImageItem {
  int id;
  String imagePath;
  bool selected;

  SingleImageItem(
      {required this.id, required this.imagePath, required this.selected});
}
