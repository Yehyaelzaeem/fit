import 'package:app/app/models/meal_food_list_response.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/make_meals_controller.dart';

class MakeMealsView extends GetView<MakeMealsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(() {
              if (controller.loading.value) return Center(child: CircularLoadingWidget());

              if (controller.error.value.isNotEmpty) return errorHandler(controller.error.value, controller);

              return Column(
                children: [
                  //App bar
                  appBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: EditText(
                              hint: 'Meal name',
                              hintColor: Color(0xff8D8D8D),
                              background: Color(0xffF1F1F1),
                              controller: controller.mealNameController,
                              updateFunc: (value) {
                                controller.mealName.value = value;
                              },
                              contentPaddingV: 0,
                              padding: 0,
                              noBorder: true,
                              radius: 4,
                            ),
                          ),
                          SizedBox(height: 12),
                          header(
                              'Protein',
                              GestureDetector(
                                onTap: () {
                                  controller.proteinSelected.add(Food(
                                      amounts: [],
                                      selectedAmount: Amount(
                                        id: 0,
                                        calories: "",
                                        name: "",
                                        price: "",
                                      )));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(
                                    Icons.add_box,
                                    color: kColorPrimary,
                                  ),
                                ),
                              )),
                          SizedBox(height: 12),
                          body([
                            Expanded(flex: 2, child: kTextbody("Quality", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Quantity", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Calories", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Price", color: kColorPrimary)),
                            Expanded(flex: 1, child: kTextbody("", color: kColorPrimary)),
                          ], color: Color(0xFFE5E5E5)),
                          ...controller.proteinSelected.map((e) {
                            return body([
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.dialog(Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Select Quality",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 12),
                                              ...controller.protein.map((item) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    e.id = item.id;
                                                    e.title = item.title;
                                                    e.selectedAmount = Amount(
                                                      id: 0,
                                                      name: "select...",
                                                      calories: "",
                                                      price: "",
                                                    );
                                                    controller.proteinSelected.refresh();
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                    child: Text(
                                                      item.title!,
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: item(
                                    title: e.title == null ? "Select..." : "${e.title}",
                                    showDropDownArrow: true,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.protein.where((element) => element.id == e.id).isEmpty) return;
                                    if (controller.protein.firstWhere((element) => element.id == e.id).amounts == null) return;
                                    if (controller.protein.firstWhere((element) => element.id == e.id).amounts.isEmpty) return;
                                    Get.dialog(Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Select Quantity",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 12),
                                              ...controller.protein.firstWhere((element) => element.id == e.id).amounts.map((item) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    e.selectedAmount = Amount(
                                                      id: item.id,
                                                      name: item.name,
                                                      calories: item.calories,
                                                      price: item.price,
                                                    );
                                                    controller.proteinSelected.refresh();
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                    child: Text(
                                                      item.name,
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: item(
                                    title: "${e.selectedAmount.name}",
                                    showDropDownArrow: e.selectedAmount.name.isNotEmpty,
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: item(title: "${e.selectedAmount.calories}", showDropDownArrow: false)),
                              Expanded(flex: 2, child: item(title: e.selectedAmount.price.isEmpty ? "" : "${e.selectedAmount.price} L.E", showDropDownArrow: false)),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.proteinSelected.remove(e);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(Icons.delete, color: Colors.red),
                                    ),
                                  )),
                            ]);
                          }).toList(),
                          SizedBox(height: 12),
                          header(
                              "Carb",
                              GestureDetector(
                                onTap: () {
                                  controller.carbSelected.add(Food(
                                      amounts: [],
                                      selectedAmount: Amount(
                                        id: 0,
                                        calories: "",
                                        name: "",
                                        price: "",
                                      )));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(
                                    Icons.add_box,
                                    color: kColorPrimary,
                                  ),
                                ),
                              )),
                          SizedBox(height: 12),
                          body([
                            Expanded(flex: 2, child: kTextbody("Quality", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Quantity", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Calories", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Price", color: kColorPrimary)),
                            Expanded(flex: 1, child: kTextbody("", color: kColorPrimary)),
                          ], color: Color(0xFFE5E5E5)),
                          ...controller.carbSelected.map((e) {
                            return body([
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.dialog(Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Select Quality",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 12),
                                              ...controller.carb.map((item) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    e.id = item.id;
                                                    e.title = item.title;
                                                    e.selectedAmount = Amount(
                                                      id: 0,
                                                      name: "select...",
                                                      calories: "",
                                                      price: "",
                                                    );
                                                    controller.carbSelected.refresh();
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                    child: Text(
                                                      item.title!,
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: item(
                                    title: e.title == null ? "Select..." : "${e.title}",
                                    showDropDownArrow: true,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.carb.where((element) => element.id == e.id).isEmpty) return;
                                    if (controller.carb.firstWhere((element) => element.id == e.id).amounts == null) return;
                                    if (controller.carb.firstWhere((element) => element.id == e.id).amounts.isEmpty) return;
                                    Get.dialog(Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Select Quantity",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 12),
                                              ...controller.carb.firstWhere((element) => element.id == e.id).amounts.map((item) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    e.selectedAmount = Amount(
                                                      id: item.id,
                                                      name: item.name,
                                                      calories: item.calories,
                                                      price: item.price,
                                                    );
                                                    controller.carbSelected.refresh();
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                    child: Text(
                                                      item.name,
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: item(
                                    title: "${e.selectedAmount.name}",
                                    showDropDownArrow: e.selectedAmount.name.isNotEmpty,
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: item(title: "${e.selectedAmount.calories}", showDropDownArrow: false)),
                              Expanded(flex: 2, child: item(title: e.selectedAmount.price.isEmpty ? "" : "${e.selectedAmount.price} L.E", showDropDownArrow: false)),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.carbSelected.remove(e);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(Icons.delete, color: Colors.red),
                                    ),
                                  )),
                            ]);
                          }).toList(),
                          SizedBox(height: 12),
                          header(
                              "Fat",
                              GestureDetector(
                                onTap: () {
                                  controller.fatSelected.add(Food(
                                      amounts: [],
                                      selectedAmount: Amount(
                                        id: 0,
                                        calories: "",
                                        name: "",
                                        price: "",
                                      )));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(
                                    Icons.add_box,
                                    color: kColorPrimary,
                                  ),
                                ),
                              )),
                          SizedBox(height: 12),
                          body([
                            Expanded(flex: 2, child: kTextbody("Quality", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Quantity", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Calories", color: kColorPrimary)),
                            Expanded(flex: 2, child: kTextbody("Price", color: kColorPrimary)),
                            Expanded(flex: 1, child: kTextbody("", color: kColorPrimary)),
                          ], color: Color(0xFFE5E5E5)),
                          ...controller.fatSelected.map((e) {
                            return body([
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.dialog(Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Select Quality",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 12),
                                              ...controller.fat.map((item) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    e.id = item.id;
                                                    e.title = item.title;
                                                    e.selectedAmount = Amount(
                                                      id: 0,
                                                      name: "select...",
                                                      calories: "",
                                                      price: "",
                                                    );
                                                    controller.fatSelected.refresh();
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                    child: Text(
                                                      item.title!,
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: item(
                                    title: e.title == null ? "Select..." : "${e.title}",
                                    showDropDownArrow: true,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.carb.where((element) => element.id == e.id).isEmpty) return;
                                    if (controller.carb.firstWhere((element) => element.id == e.id).amounts == null) return;
                                    if (controller.carb.firstWhere((element) => element.id == e.id).amounts.isEmpty) return;
                                    Get.dialog(Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Select Quantity",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 12),
                                              ...controller.carb.firstWhere((element) => element.id == e.id).amounts.map((item) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    e.selectedAmount = Amount(
                                                      id: item.id,
                                                      name: item.name,
                                                      calories: item.calories,
                                                      price: item.price,
                                                    );
                                                    controller.fatSelected.refresh();
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                    child: Text(
                                                      item.name,
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  },
                                  child: item(
                                    title: "${e.selectedAmount.name}",
                                    showDropDownArrow: e.selectedAmount.name.isNotEmpty,
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: item(title: "${e.selectedAmount.calories}", showDropDownArrow: false)),
                              Expanded(flex: 2, child: item(title: e.selectedAmount.price.isEmpty ? "" : "${e.selectedAmount.price} L.E", showDropDownArrow: false)),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.fatSelected.remove(e);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(Icons.delete, color: Colors.red),
                                    ),
                                  )),
                            ]);
                          }).toList(),
                          SizedBox(height: 12),
                          header(
                              "Total Price",
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: kTextbody(
                                    "${controller.totalPrice()} L.E",
                                    color: Colors.white,
                                  ))),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            child: kTextbody("Note", align: TextAlign.start, paddingH: 12),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: EditText(
                              hint: '',
                              hintColor: Color(0xff8D8D8D),
                              background: Color(0xffF1F1F1),
                              controller: controller.noteController,
                              updateFunc: (value) {
                                controller.note.value = value;
                              },
                              noBorder: true,
                              radius: 4,
                              lines: 3,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              kButton(
                                "     Save     ",
                                paddingH: 12,
                                paddingV: 4,
                                func: () {
                                  if (controller.mealName.isEmpty) {
                                    Get.snackbar("Error", "Please enter meal name");
                                    return;
                                  }
                                  if (controller.fatSelected.isEmpty && controller.carbSelected.isEmpty && controller.proteinSelected.isEmpty) {
                                    Get.snackbar("Error", "No food selected!");
                                    return;
                                  }

                                  if (controller.proteinSelected.isNotEmpty) {
                                    controller.proteinSelected.forEach((element) {
                                      if (element.selectedAmount.calories.isEmpty) {
                                        Get.snackbar("Error", "Please select amount for ${element.title}");
                                        return;
                                      }
                                    });
                                  }
                                  if (controller.carbSelected.isNotEmpty) {
                                    controller.carbSelected.forEach((element) {
                                      if (element.selectedAmount.calories.isEmpty) {
                                        Get.snackbar("Error", "Please select amount for ${element.title}");
                                        return;
                                      }
                                    });
                                  }
                                  if (controller.fatSelected.isNotEmpty) {
                                    controller.fatSelected.forEach((element) {
                                      if (element.selectedAmount.calories.isEmpty) {
                                        Get.snackbar("Error", "Please select amount for ${element.title}");
                                        return;
                                      }
                                    });
                                  }

                                  controller.saveMeal();
                                },
                                loading: controller.saveLoading.value,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                ],
              );
            })),
      ),
    );
  }

  Widget item({required String title, bool showDropDownArrow = false}) {
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
          Expanded(child: kTextbody('$title', size: 12, maxLines: 1)),
          if (showDropDownArrow)
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: MediaQuery.of(Get.context!).size.width,
      height: 65,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          blurRadius: 2,
          spreadRadius: 2,
          offset: Offset(0, 0),
        ),
      ]),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              kLogoChellFullRow,
              height: 44,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 26,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header(String title, Widget action) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0),
      color: Color(0xFF414042),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Center(child: kTextbody(title, color: Colors.white, bold: true, size: 16)),
          ),
          action,
        ],
      ),
    );
  }

  Widget body(List<Widget> widgets, {Color color = Colors.white}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [...widgets],
      ),
    );
  }
}
