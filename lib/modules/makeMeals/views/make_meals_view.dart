
import 'package:app/core/resources/app_assets.dart';
import 'package:app/modules/makeMeals/cubits/make_meals_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/meal_food_list_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/edit_text.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../subscribe/views/non_user_subscribe_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakeMealsView extends StatefulWidget {
  const MakeMealsView({Key? key}) : super(key: key);

  @override
  _MakeMealsViewState createState() => _MakeMealsViewState();
}

class _MakeMealsViewState extends State<MakeMealsView> {
  late final MakeMealsCubit makeMealsCubit;


  @override
  void initState() {
    super.initState();
    makeMealsCubit = BlocProvider.of<MakeMealsCubit>(context);
    makeMealsCubit.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(() {
              if (makeMealsCubit.loading.value)
                return Center(child: CircularLoadingWidget());

              if (makeMealsCubit.error.value.isNotEmpty)
                return errorHandler(makeMealsCubit.error.value, makeMealsCubit);

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
                              controller: makeMealsCubit.mealNameController,
                              updateFunc: (value) {
                                makeMealsCubit.mealName.value = value;
                              },
                              contentPaddingV: 0,
                              padding: 0,
                              noBorder: true,
                              radius: 4,
                            ),
                          ),
                          SizedBox(height: 12),

                          SizedBox(height: 12),
                          ...makeMealsCubit.meals.map((meal) {
                            return Column(
                              children: [
                                header(
                                    '${meal.title}',
                                    GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        makeMealsCubit.selectedFood.add(Food(
                                            amounts: [],
                                            mealTitle: meal.title ?? "",
                                            title: '',
                                            selectedAmount: Amount(
                                              id: 0,
                                              calories: "",
                                              name: "",
                                              price: "",
                                            )));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Icon(
                                          Icons.add_box,
                                          color: kColorPrimary,
                                          size: 30,
                                        ),
                                      ),
                                    )),
                                SizedBox(height: 12),
                                body([
                                  Expanded(
                                      flex: 5,
                                      child: kTextbody("Quality",
                                          color: kColorPrimary)),
                                  Expanded(
                                      flex: 4,
                                      child: kTextbody("Quantity",
                                          color: kColorPrimary)),
                                  Expanded(
                                      flex: 4,
                                      child: kTextbody("Calories",
                                          color: kColorPrimary)),
                                  Expanded(
                                      flex: 4,
                                      child: kTextbody("Price",
                                          color: kColorPrimary)),
                                  Expanded(
                                      flex: 2,
                                      child:
                                          kTextbody("", color: kColorPrimary)),
                                ], color: Color(0xFFE5E5E5)),
                                ...makeMealsCubit.selectedFood
                                    .where((selectedFood) =>
                                        selectedFood.mealTitle == meal.title)
                                    .map((e) {
                                  return body([
                                    Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          Get.dialog(Dialog(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 16),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Select Quality",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    if (meal.food.length > 0)
                                                      SizedBox(height: 12),
                                                    ...meal.food.map((item) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const SizedBox(),
                                                          GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              e.id = item.id;
                                                              e.title =
                                                                  item.title;
                                                              e.selectedAmount =
                                                                  Amount(
                                                                id: 0,
                                                                name:
                                                                    "select...",
                                                                calories: "",
                                                                price: "",
                                                              );
                                                              makeMealsCubit
                                                                  .selectedFood
                                                                  .refresh();
                                                              Get.back();
                                                            },
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8),
                                                              child: Text(
                                                                item.title,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                              thickness: 1.2),
                                                        ],
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                        },
                                        child: item(
                                          title: e.title == null
                                              ? "Select..."
                                              : "${e.title}",
                                          showDropDownArrow: true,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (meal.food
                                              .where((element) =>
                                                  element.id == e.id)
                                              .isEmpty) return;
                                          if (meal.food
                                              .firstWhere((element) =>
                                                  element.id == e.id)
                                              .amounts
                                              .isEmpty) return;
                                          Get.dialog(Dialog(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 16),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Select Quantity",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    if (meal.food.length > 0)
                                                      SizedBox(height: 12),
                                                    ...meal.food
                                                        .firstWhere((element) =>
                                                            element.id == e.id)
                                                        .amounts
                                                        .map((item) {
                                                      return Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              e.selectedAmount =
                                                                  Amount(
                                                                id: item.id,
                                                                name: item.name,
                                                                calories: item
                                                                    .calories,
                                                                price:
                                                                    item.price,
                                                              );
                                                              makeMealsCubit
                                                                  .selectedFood
                                                                  .refresh();
                                                              Get.back();
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8),
                                                              width: double
                                                                  .infinity,
                                                              color: Colors
                                                                  .transparent,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                item.name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                              thickness: 1.2),
                                                        ],
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
                                          showDropDownArrow:
                                              e.selectedAmount.name.isNotEmpty,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: item(
                                            title:
                                                "${double.tryParse(e.selectedAmount.calories)?.round() ?? ""}",
                                            showDropDownArrow: false)),
                                    Expanded(
                                        flex: 4,
                                        child: item(
                                            title: e.selectedAmount.price
                                                    .isEmpty
                                                ? ""
                                                : "${double.tryParse(e.selectedAmount.price)?.round() ?? ""} L.E",
                                            showDropDownArrow: false)),
                                    Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            makeMealsCubit.selectedFood.remove(e);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                        )),
                                  ]);
                                }).toList(),
                              ],
                            );
                          }),

                          // header(
                          //     'Protein',
                          //     GestureDetector(
                          //       onTap: () {
                          //         FocusScope.of(context).requestFocus(FocusNode());
                          //         makeMealsCubit.proteinSelected.add(Food(
                          //             amounts: [],
                          //             selectedAmount: Amount(
                          //               id: 0,
                          //               calories: "",
                          //               name: "",
                          //               price: "",
                          //             )));
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.all(6),
                          //         margin: EdgeInsets.symmetric(horizontal: 12),
                          //         child: Icon(
                          //           Icons.add_box,
                          //           color: kColorPrimary,
                          //           size: 30,
                          //         ),
                          //       ),
                          //     )),
                          // SizedBox(height: 12),
                          // body([
                          //   Expanded(flex: 5, child: kTextbody("Quality", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Quantity", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Calories", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Price", color: kColorPrimary)),
                          //   Expanded(flex: 2, child: kTextbody("", color: kColorPrimary)),
                          // ], color: Color(0xFFE5E5E5)),
                          // ...makeMealsCubit.proteinSelected.map((e) {
                          //   return body([
                          //     Expanded(
                          //       flex: 5,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           FocusScope.of(context).requestFocus(FocusNode());
                          //           Get.dialog(Dialog(
                          //             child: Container(
                          //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          //               child: SingleChildScrollView(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text(
                          //                       "Select Quality",
                          //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //                     ),
                          //                     if (makeMealsCubit.protein.length > 0) SizedBox(height: 12),
                          //                     ...makeMealsCubit.protein.map((item) {
                          //                       return GestureDetector(
                          //                         onTap: () {
                          //                           FocusScope.of(context).requestFocus(FocusNode());
                          //                           e.id = item.id;
                          //                           e.title = item.title;
                          //                           e.selectedAmount = Amount(
                          //                             id: 0,
                          //                             name: "select...",
                          //                             calories: "",
                          //                             price: "",
                          //                           );
                          //                           makeMealsCubit.proteinSelected.refresh();
                          //                           Get.back();
                          //                         },
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 8),
                          //                           child: Text(
                          //                             item.title!,
                          //                             style: TextStyle(fontSize: 16),
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //         },
                          //         child: item(
                          //           title: e.title == null ? "Select..." : "${e.title}",
                          //           showDropDownArrow: true,
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       flex: 4,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           FocusScope.of(context).requestFocus(FocusNode());
                          //           if (makeMealsCubit.protein.where((element) => element.id == e.id).isEmpty) return;
                          //           if (makeMealsCubit.protein.firstWhere((element) => element.id == e.id).amounts == null) return;
                          //           if (makeMealsCubit.protein.firstWhere((element) => element.id == e.id).amounts.isEmpty) return;
                          //           Get.dialog(Dialog(
                          //             child: Container(
                          //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          //               child: SingleChildScrollView(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text(
                          //                       "Select Quantity",
                          //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //                     ),
                          //                     if (makeMealsCubit.protein.length < 1) SizedBox(height: 12),
                          //                     ...makeMealsCubit.protein.firstWhere((element) => element.id == e.id).amounts.map((item) {
                          //                       return GestureDetector(
                          //                         onTap: () {
                          //                           FocusScope.of(context).requestFocus(FocusNode());
                          //                           e.selectedAmount = Amount(
                          //                             id: item.id,
                          //                             name: item.name,
                          //                             calories: item.calories,
                          //                             price: item.price,
                          //                           );
                          //                           makeMealsCubit.proteinSelected.refresh();
                          //                           Get.back();
                          //                         },
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 8),
                          //                           child: Text(
                          //                             item.name,
                          //                             style: TextStyle(fontSize: 16),
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //         },
                          //         child: item(
                          //           title: "${e.selectedAmount.name}",
                          //           showDropDownArrow: e.selectedAmount.name.isNotEmpty,
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(flex: 4, child: item(title: "${e.selectedAmount.calories}", showDropDownArrow: false)),
                          //     Expanded(flex: 4, child: item(title: e.selectedAmount.price.isEmpty ? "" : "${e.selectedAmount.price} L.E", showDropDownArrow: false)),
                          //     Expanded(
                          //         flex: 2,
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             FocusScope.of(context).requestFocus(FocusNode());
                          //             makeMealsCubit.proteinSelected.remove(e);
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(6.0),
                          //             child: Icon(Icons.delete, color: Colors.red),
                          //           ),
                          //         )),
                          //   ]);
                          // }).toList(),
                          // SizedBox(height: 12),
                          // header(
                          //     "Carb",
                          //     GestureDetector(
                          //       onTap: () {
                          //         FocusScope.of(context).requestFocus(FocusNode());
                          //         makeMealsCubit.carbSelected.add(Food(
                          //             amounts: [],
                          //             selectedAmount: Amount(
                          //               id: 0,
                          //               calories: "",
                          //               name: "",
                          //               price: "",
                          //             )));
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.all(6),
                          //         margin: EdgeInsets.symmetric(horizontal: 12),
                          //         child: Icon(
                          //           Icons.add_box,
                          //           color: kColorPrimary,
                          //           size: 30,
                          //         ),
                          //       ),
                          //     )),
                          // SizedBox(height: 12),
                          // body([
                          //   Expanded(flex: 5, child: kTextbody("Quality", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Quantity", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Calories", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Price", color: kColorPrimary)),
                          //   Expanded(flex: 2, child: kTextbody("", color: kColorPrimary)),
                          // ], color: Color(0xFFE5E5E5)),
                          // ...makeMealsCubit.carbSelected.map((e) {
                          //   return body([
                          //     Expanded(
                          //       flex: 5,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           FocusScope.of(context).requestFocus(FocusNode());
                          //           Get.dialog(Dialog(
                          //             child: Container(
                          //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          //               child: SingleChildScrollView(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text(
                          //                       "Select Quality",
                          //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //                     ),
                          //                     if (makeMealsCubit.carb.length > 0) SizedBox(height: 12),
                          //                     ...makeMealsCubit.carb.map((item) {
                          //                       return GestureDetector(
                          //                         onTap: () {
                          //                           FocusScope.of(context).requestFocus(FocusNode());
                          //                           e.id = item.id;
                          //                           e.title = item.title;
                          //                           e.selectedAmount = Amount(
                          //                             id: 0,
                          //                             name: "select...",
                          //                             calories: "",
                          //                             price: "",
                          //                           );
                          //                           makeMealsCubit.carbSelected.refresh();
                          //                           Get.back();
                          //                         },
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 8),
                          //                           child: Text(
                          //                             item.title!,
                          //                             style: TextStyle(fontSize: 16),
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //         },
                          //         child: item(
                          //           title: e.title == null ? "Select..." : "${e.title}",
                          //           showDropDownArrow: true,
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       flex: 4,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           FocusScope.of(context).requestFocus(FocusNode());
                          //           if (makeMealsCubit.carb.where((element) => element.id == e.id).isEmpty) return;
                          //           if (makeMealsCubit.carb.firstWhere((element) => element.id == e.id).amounts == null) return;
                          //           if (makeMealsCubit.carb.firstWhere((element) => element.id == e.id).amounts.isEmpty) return;
                          //           Get.dialog(Dialog(
                          //             child: Container(
                          //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          //               child: SingleChildScrollView(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text(
                          //                       "Select Quantity",
                          //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //                     ),
                          //                     if (makeMealsCubit.carb.length < 1) SizedBox(height: 12),
                          //                     ...makeMealsCubit.carb.firstWhere((element) => element.id == e.id).amounts.map((item) {
                          //                       return GestureDetector(
                          //                         onTap: () {
                          //                           FocusScope.of(context).requestFocus(FocusNode());
                          //                           e.selectedAmount = Amount(
                          //                             id: item.id,
                          //                             name: item.name,
                          //                             calories: item.calories,
                          //                             price: item.price,
                          //                           );
                          //                           makeMealsCubit.carbSelected.refresh();
                          //                           Get.back();
                          //                         },
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 8),
                          //                           child: Text(
                          //                             item.name,
                          //                             style: TextStyle(fontSize: 16),
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //         },
                          //         child: item(
                          //           title: "${e.selectedAmount.name}",
                          //           showDropDownArrow: e.selectedAmount.name.isNotEmpty,
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(flex: 4, child: item(title: "${e.selectedAmount.calories}", showDropDownArrow: false)),
                          //     Expanded(flex: 4, child: item(title: e.selectedAmount.price.isEmpty ? "" : "${e.selectedAmount.price} L.E", showDropDownArrow: false)),
                          //     Expanded(
                          //         flex: 2,
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             FocusScope.of(context).requestFocus(FocusNode());
                          //             makeMealsCubit.carbSelected.remove(e);
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(6.0),
                          //             child: Icon(Icons.delete, color: Colors.red),
                          //           ),
                          //         )),
                          //   ]);
                          // }).toList(),
                          // SizedBox(height: 12),
                          // header(
                          //     "Fat",
                          //     GestureDetector(
                          //       onTap: () {
                          //         FocusScope.of(context).requestFocus(FocusNode());
                          //         makeMealsCubit.fatSelected.add(Food(
                          //             amounts: [],
                          //             selectedAmount: Amount(
                          //               id: 0,
                          //               calories: "",
                          //               name: "",
                          //               price: "",
                          //             )));
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.all(6),
                          //         margin: EdgeInsets.symmetric(horizontal: 12),
                          //         child: Icon(
                          //           Icons.add_box,
                          //           color: kColorPrimary,
                          //           size: 30,
                          //         ),
                          //       ),
                          //     )),
                          // SizedBox(height: 12),
                          // body([
                          //   Expanded(flex: 5, child: kTextbody("Quality", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Quantity", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Calories", color: kColorPrimary)),
                          //   Expanded(flex: 4, child: kTextbody("Price", color: kColorPrimary)),
                          //   Expanded(flex: 2, child: kTextbody("", color: kColorPrimary)),
                          // ], color: Color(0xFFE5E5E5)),
                          // ...makeMealsCubit.fatSelected.map((e) {
                          //   return body([
                          //     Expanded(
                          //       flex: 5,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           FocusScope.of(context).requestFocus(FocusNode());
                          //           Get.dialog(Dialog(
                          //             child: Container(
                          //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          //               child: SingleChildScrollView(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text(
                          //                       "Select Quality",
                          //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //                     ),
                          //                     if (makeMealsCubit.fat.length > 0) SizedBox(height: 12),
                          //                     ...makeMealsCubit.fat.map((item) {
                          //                       return GestureDetector(
                          //                         onTap: () {
                          //                           FocusScope.of(context).requestFocus(FocusNode());
                          //                           e.id = item.id;
                          //                           e.title = item.title;
                          //                           e.selectedAmount = Amount(
                          //                             id: 0,
                          //                             name: "select...",
                          //                             calories: "",
                          //                             price: "",
                          //                           );
                          //                           makeMealsCubit.fatSelected.refresh();
                          //                           Get.back();
                          //                         },
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 8),
                          //                           child: Text(
                          //                             item.title!,
                          //                             style: TextStyle(fontSize: 16),
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //         },
                          //         child: item(
                          //           title: e.title == null ? "Select..." : "${e.title}",
                          //           showDropDownArrow: true,
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       flex: 4,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           FocusScope.of(context).requestFocus(FocusNode());
                          //           if (makeMealsCubit.carb.where((element) => element.id == e.id).isEmpty) return;
                          //           if (makeMealsCubit.carb.firstWhere((element) => element.id == e.id).amounts == null) return;
                          //           if (makeMealsCubit.carb.firstWhere((element) => element.id == e.id).amounts.isEmpty) return;
                          //           Get.dialog(Dialog(
                          //             child: Container(
                          //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          //               child: SingleChildScrollView(
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     Text(
                          //                       "Select Quantity",
                          //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //                     ),
                          //                     if (makeMealsCubit.carb.length < 1) SizedBox(height: 12),
                          //                     ...makeMealsCubit.carb.firstWhere((element) => element.id == e.id).amounts.map((item) {
                          //                       return GestureDetector(
                          //                         onTap: () {
                          //                           FocusScope.of(context).requestFocus(FocusNode());
                          //                           e.selectedAmount = Amount(
                          //                             id: item.id,
                          //                             name: item.name,
                          //                             calories: item.calories,
                          //                             price: item.price,
                          //                           );
                          //                           makeMealsCubit.fatSelected.refresh();
                          //                           Get.back();
                          //                         },
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 8),
                          //                           child: Text(
                          //                             item.name,
                          //                             style: TextStyle(fontSize: 16),
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //         },
                          //         child: item(
                          //           title: "${e.selectedAmount.name}",
                          //           showDropDownArrow: e.selectedAmount.name.isNotEmpty,
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(flex: 4, child: item(title: "${e.selectedAmount.calories}", showDropDownArrow: false)),
                          //     Expanded(flex: 4, child: item(title: e.selectedAmount.price.isEmpty ? "" : "${e.selectedAmount.price} L.E", showDropDownArrow: false)),
                          //     Expanded(
                          //         flex: 2,
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             FocusScope.of(context).requestFocus(FocusNode());
                          //             makeMealsCubit.fatSelected.remove(e);
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(6.0),
                          //             child: Icon(Icons.delete, color: Colors.red),
                          //           ),
                          //         )),
                          //   ]);
                          // }).toList(),
                          SizedBox(height: 12),
                          header(
                              "Total Price",
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: kTextbody(
                                    "${makeMealsCubit.totalPrice()} L.E",
                                    color: Colors.white,
                                  ))),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            child: kTextbody("Note",
                                align: TextAlign.start, paddingH: 12),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: EditText(
                              hint: '',
                              hintColor: Color(0xff8D8D8D),
                              background: Color(0xffF1F1F1),
                              controller: makeMealsCubit.noteController,
                              updateFunc: (value) {
                                makeMealsCubit.note.value = value;
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
                                func: () async {
                                  if (makeMealsCubit.mealName.isEmpty) {
                                    Get.snackbar(
                                        "Error", "Please enter meal name");
                                    return;
                                  }
                                  if (makeMealsCubit.selectedFood.isEmpty) {
                                    Get.snackbar("Error", "No food selected!");
                                    return;
                                  }
                                  bool canContinue = true;
                                  if (makeMealsCubit.selectedFood.isNotEmpty) {
                                    for (int i = 0;
                                        i < makeMealsCubit.selectedFood.length;
                                        i++) {
                                      if (makeMealsCubit.selectedFood[i]
                                          .selectedAmount.calories.isEmpty) {
                                        if (canContinue) canContinue = false;
                                        if (makeMealsCubit
                                            .selectedFood[i].title.isEmpty) {
                                          Get.snackbar(
                                              "Error", "Please select amount");
                                        } else {
                                          Get.snackbar("Error",
                                              "Please select amount for ${makeMealsCubit.selectedFood[i].title}");
                                        }
                                      }
                                    }
                                  }
                                  if (!canContinue) return;
                                  if (canContinue) {
                                    if (makeMealsCubit.isGuestSaved ||
                                        makeMealsCubit.userId.isNotEmpty) {
                                      makeMealsCubit.saveMeal();
                                    } else if (!makeMealsCubit.isGuestSaved &&
                                        makeMealsCubit.userId.isEmpty) {
                                      bool result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NonUserSubscribeView(
                                                  isGuest: makeMealsCubit.isGuest,
                                                  save: true,
                                                )),
                                      );
                                      if (result == true) {
                                        makeMealsCubit.saveMeal();
                                      } else {}
                                    }
                                  }
                                },
                                loading: makeMealsCubit.saveLoading.value,
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
          Expanded(
              child: Container(
                  child: kTextbody(
            '$title',
            size: 12,
            maxLines: 5,
            paddingH: 1,
          ))),
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
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
              AppImages.kLogoChellFullRow,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
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
            child: Center(
                child: kTextbody(title,
                    color: Colors.white, bold: true, size: 16)),
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
