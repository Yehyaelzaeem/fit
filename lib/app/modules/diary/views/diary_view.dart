import 'package:app/app/models/day_details_reposne.dart';
import 'package:app/app/modules/diary/add_new_food.dart';
import 'package:app/app/modules/diary/controllers/diary_controller.dart';
import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/custom_bottom_sheet.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../main_un_auth.dart';

class DiaryView extends GetView<DiaryController> {
  @override
  final controller = Get.find(tag: 'diary');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Obx(() => Container(key: Key('drawer_${controller.isLogggd.value}'), child: HomeDrawer())),
        body: Obx(() {
          if (!controller.isLogggd.value) return MainUnAuth();
          if (controller.showLoader.value || controller.isLoading.value) return Container(child: CircularLoadingWidget(), color: Colors.white);

          if (!controller.isLoading.value && controller.noSessions.value == true)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(
                child: Text(
                  "Book Your Next Session",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17),
                ),
              ),
            );

          return ListView(
            children: [
              //* Header + eye Icon
              header(),

              Column(
                children: [
                  SizedBox(height: 16),
                  //* Diary Dates
                  diaryDatesOptions(),
                  SizedBox(height: 16),
                  //*Water Header
                  waterHeader(),
                  //*Water Bottles
                  waterBottles(),
                  Divider(thickness: 2),
                  rowWithProgressBar("Proteins", controller.response.value.data!.proteins),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        if (controller.refreshLoadingProtine.value)
                          Container(
                            child: LinearProgressIndicator(
                              color: kColorPrimary,
                            ),
                          ),
                        staticBar(1),
                        if (controller.caloriesDetails.isEmpty) SizedBox(height: 20),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.caloriesDetails.length,
                            itemBuilder: (context, indedx) {
                              return rowItem(controller.caloriesDetails[indedx], 1);
                            }),
                      ],
                    ),
                  ),
                  Divider(thickness: 2),
                  rowWithProgressBar("Carbs & Fats", controller.response.value.data!.carbsFats),
                  if (controller.refreshLoadingCarbs.value)
                    Container(
                      child: LinearProgressIndicator(color: kColorPrimary),
                    ),
                  staticBar(2),
                  if (controller.carbsAndFats.isEmpty) SizedBox(height: 20),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.carbsAndFats.length,
                      itemBuilder: (context, indedx) {
                        return rowItem(controller.carbsAndFats[indedx], 2);
                      }),
                  SizedBox(height: 12),
                  Divider(),
                  diaryFooter(),
                ],
              )
            ],
          );
        }));
  }

  Widget rowItem(CaloriesDetails item, int type) {
    return Container(
      height: 40,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 8,
                        child: GestureDetector(
                          onTap: () {
                            showQualityDialog(
                              type == 1 ? controller.response.value.data!.proteins!.food! : controller.response.value.data!.carbsFats!.food!,
                              item,
                              type == 1,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            height: 34,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              key: Key('foodName_${item.id}_${item.qty}'),
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(fontSize: 12),
                                labelStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(color: kColorPrimary, width: 1),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                                ),
                                contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 2),
                              ),
                              style: TextStyle(fontSize: 12.0, height: 1, color: Colors.black),
                              initialValue: item.qty == null ? '' : item.qty.toString(),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (text) {
                                if (text.isEmpty) return;
                                try {
                                  double qty = double.parse(text);
                                  int foodId = 0;
                                  if (type == 1) {
                                    foodId = controller.response.value.data!.proteins!.food!.firstWhere((element) => element.title == item.quality).id!;
                                  } else {
                                    foodId = controller.response.value.data!.carbsFats!.food!.firstWhere((element) => element.title == item.quality).id!;
                                  }
                                  controller.updateProtineData(
                                    item.id,
                                    foodId,
                                    qty,
                                    typeIsProtine: type == 1,
                                  );
                                } catch (e) {}
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            child: kTextbody(
                              item.unit == null ? '' : '${item.unit}',
                              color: Colors.black,
                              bold: false,
                              size: 12,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: double.infinity,
                  height: 34,
                  child: GestureDetector(
                    onTap: () {
                      showQualityDialog(
                        type == 1 ? controller.response.value.data!.proteins!.food! : controller.response.value.data!.carbsFats!.food!,
                        item,
                        type == 1,
                      );
                    },
                    child: itemWidget(
                      title: item.quality == null ? '' : '${item.quality}',
                      showDropDownArrow: item.quality == null || '${item.quality}'.isEmpty,
                      color: item.color,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: kTextbody(
                    item.calories == null ? '' : '${item.calories}',
                    color: Colors.black,
                    bold: false,
                    size: 16,
                  ),
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
              Expanded(
                flex: 1,
                child: DeleteItemWidget(
                  controller: controller,
                  item: item,
                  typeIsCalories: type == 1,
                ),
              ),
              Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
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
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 20,
                width: MediaQuery.of(Get.context!).size.width * (item.caloriesTotal!.progress!.percentage!.toDouble() / 100),
                decoration: BoxDecoration(
                  color: Color(int.parse("0xFF${item.caloriesTotal!.progress!.bg}")),
                  borderRadius: BorderRadius.circular(4),
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
      height: 40,
      color: Color(0xFF414042),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: Center(
                child: kTextbody('Quantity', color: Colors.white, bold: true, size: 16),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: Center(
                child: kTextbody('Quality', color: Colors.white, bold: true, size: 16),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 2,
            child: kTextbody('Cal.', color: Colors.white, bold: true, size: 16),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                FocusScope.of(Get.context!).requestFocus(FocusNode());
                if (type == 1) {
                  controller.caloriesDetails.add(CaloriesDetails());
                } else {
                  controller.carbsAndFats.add(CaloriesDetails());
                }
              },
              child: Center(
                child: Container(
                    width: 26,
                    height: 26,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: kColorPrimary),
                    child: Icon(
                      Icons.add,
                      color: Colors.black87,
                      size: 18,
                    )),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
        ],
      ),
    );
  }

  Widget header() {
    return Row(
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
                SizedBox(height: 2),
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
            FocusScope.of(Get.context!).requestFocus(FocusNode());
            controller.downloadFile(controller.response.value.data!.pdf!);
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
    );
  }

  Widget diaryDatesOptions() {
    Widget dayButton = InkWell(
      onTap: () {
        FocusScope.of(Get.context!).requestFocus(FocusNode());
        if (!controller.isToday.value) {
          controller.getDiaryData(controller.response.value.data!.days![0].date!);
        } else {
          controller.getDiaryData(controller.response.value.data!.days![1].date!);
        }
      },
      child: Container(
        width: MediaQuery.of(Get.context!).size.width / 4,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: kTextHeader(controller.isToday.value ? 'Yesterday' : 'Today', color: Colors.white, bold: true, size: 14),
        ),
      ),
    );
    Widget dateDisplay = Container(
      width: MediaQuery.of(Get.context!).size.width / 1.5,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
      child: Center(
        child: kTextHeader('${controller.date.value}', color: Colors.black87, bold: true, size: 14),
      ),
    );
    return controller.isToday.value == true
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dayButton,
              dateDisplay,
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateDisplay,
              dayButton,
            ],
          );
  }

  Widget waterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Water : ${controller.response.value.data!.water ?? "0"}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          // SizedBox(),
          Icon(Icons.swap_vert, size: 25, color: kColorPrimary)
        ],
      ),
    );
  }

  Widget waterBottles() {
    return Container(
        width: double.infinity,
        child: GridView.builder(
          itemCount: controller.length.value,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  FocusScope.of(Get.context!).requestFocus(FocusNode());
                  controller.updateWaterData("${index + 1}");
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(controller.waterBottlesList[index].imagePath), fit: BoxFit.cover)),
                    ),
                    controller.waterBottlesList[index].selected == false
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
        ));
  }

  Widget diaryFooter() {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
                Get.context!,
                MaterialPageRoute(
                    builder: (context) => MyOtherCalories(
                          canGoBack: true,
                        )));

            if (result == null) {
              if (controller.lastSelectedDate.value.isNotEmpty) controller.getDiaryData(controller.lastSelectedDate.value);
            }
            FocusScope.of(Get.context!).requestFocus(FocusNode());
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xffF1F9E3),
            ),
            child: kButtonDefault(
              'My other calories',
              marginH: MediaQuery.of(Get.context!).size.width / 6,
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
            FocusScope.of(Get.context!).requestFocus(FocusNode());
            if (controller.response.value.data!.workoutDetailsType == "") {
              Fluttertoast.showToast(msg: "Nothing To Show ");
            } else if (controller.response.value.data!.workoutDetailsType == "link") {
              controller.launchURL(controller.response.value.data!.workoutDetails);
            } else {
              controller.showPobUp(controller.response.value.data!.workoutDetails!);
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
        SizedBox(height: MediaQuery.of(Get.context!).size.width / 14),
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
          onTap: () async {
            CustomSheet(
                context: Get.context!,
                widget: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                      itemCount: controller.response.value.data!.workouts!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(Get.context!);
                            controller.workOutData.value = controller.response.value.data!.workouts![index].title!;
                            controller.workOut.value = controller.response.value.data!.workouts![index].id!;
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: Text(
                                  "${controller.response.value.data!.workouts![index].title}",
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
                      "${controller.workOutData.value}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          width: MediaQuery.of(Get.context!).size.width,
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
                      value: '${controller.workDesc.value}',
                      // hint: '${controller.workDesc.value}',
                      updateFunc: (text) {
                        controller.workDesc.value = text;
                        Echo("$controller.workDesc.value");
                      },
                      validateFunc: (text) {},
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: kButtonDefault(
                        'Save',
                        marginH: MediaQuery.of(Get.context!).size.width / 5,
                        paddingV: 0,
                        func: () {
                          FocusScope.of(Get.context!).requestFocus(FocusNode());
                          if (controller.workDesc.value.trim() == "" || controller.workOut.value == null) {
                            Fluttertoast.showToast(msg: "Enter Workout Description");
                          } else {
                            controller.updateWork();
                          }
                        },
                        shadow: true,
                        paddingH: 50,
                        loading: controller.workoutLoading.value,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemWidget({required String title, bool showDropDownArrow = false, String? color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey, width: 1),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            key: Key('title$title'),
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: AutoSizeText(
              '$title',
              style: TextStyle(fontSize: 12, color: color != null ? Color(int.parse("0xFF$color")) : Colors.black87, height: 1.2),
              textAlign: TextAlign.center,
              minFontSize: 8,
              maxLines: 2,
            ),
          )),
          if (showDropDownArrow)
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
        ],
      ),
    );
  }

  void showQualityDialog(List<Food> food, CaloriesDetails item, bool typeIsProtine) async {
    // show screen dialog
    dynamic result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return Dialog(
            child: AddNewFood(
              date: controller.apiDate.value,
              list: food,
            ),
          );
        });
    if (result != null) {
      Food food = result as Food;
      item.quality = food.title;
      item.qty = food.qty;
      item.color = food.color;

      controller.caloriesDetails.refresh();
      controller.carbsAndFats.refresh();
      if (item.id == null) {
        controller.createProtineData(food.id, food.qty!, typeIsProtine: typeIsProtine);
      } else {
        controller.updateProtineData(item.id, food.id, food.qty!, typeIsProtine: typeIsProtine);
      }
    }
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }
}

class DeleteItemWidget extends StatefulWidget {
  final CaloriesDetails item;
  final DiaryController controller;
  final bool typeIsCalories;
  DeleteItemWidget({
    Key? key,
    required this.item,
    required this.controller,
    required this.typeIsCalories,
  }) : super(key: key);
  @override
  State<DeleteItemWidget> createState() => _DeleteItemWidgetState();
}

class _DeleteItemWidgetState extends State<DeleteItemWidget> {
  bool deleteItem = false;
  @override
  Widget build(BuildContext context) {
    if (deleteItem)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.4,
            ),
          ),
        ],
      );
    return InkWell(
      onTap: () async {
        deleteItem = true;
        setState(() {});
        if (widget.item.id == null) {
          if (widget.typeIsCalories)
            await widget.controller.caloriesDetails.remove(widget.item);
          else
            await widget.controller.carbsAndFats.remove(widget.item);
        } else {
          if (widget.typeIsCalories)
            await widget.controller.deleteItemCalories(widget.item.id!, widget.controller.lastSelectedDate.value, widget.typeIsCalories);
          else
            await widget.controller.deleteItemCarbs(widget.item.id!, widget.controller.lastSelectedDate.value, widget.typeIsCalories);

          await widget.controller.carbsAndFats.remove(widget.item);
        }

        deleteItem = false;
        setState(() {});
        FocusScope.of(Get.context!).requestFocus(FocusNode());
      },
      child: Icon(
        Icons.delete,
        color: Colors.redAccent,
        size: 26,
      ),
    );
  }
}
