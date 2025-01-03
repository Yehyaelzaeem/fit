// import 'dart:convert';

// import 'package:app/app/models/day_details_reposne.dart';
// import 'package:app/app/modules/home/home_appbar.dart';
// import 'package:app/app/network_util/api_provider.dart';
// import 'package:app/app/utils/theme/app_colors.dart';
// import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
// import 'package:app/app/widgets/default/app_buttons.dart';
// import 'package:app/app/widgets/default/edit_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

// class AddNewFood extends StatefulWidget {
//   final String? date;
//   final bool? edit;
//   final int? id;
//   final bool showAsDialog;

//   final List<Food>? list;

//   const AddNewFood({Key? key, this.list, required this.showAsDialog, this.date, this.edit, this.id = 0}) : super(key: key);

//   @override
//   _AddNewFoodState createState() => _AddNewFoodState();
// }

// class _AddNewFoodState extends State<AddNewFood> {
//   String food = "Choose Food";
//   bool ShowLoader = false;
//   int? foodId;
//   double? quantity;

//   GlobalKey<FormState> key = GlobalKey();
//   String? unit = "";
//   double? calories = 0;
//   List<Food> searchResult = [];
//   List<Food>? data;
//   late String keyword;

//   void search(String keyWord) {
//     for (int i = 0; i < widget.list!.length; i++) {
//       if (widget.list![i].title!.toUpperCase().contains(keyWord.toUpperCase())) {
//         setState(() {
//           searchResult.add(widget.list![i]);
//         });
//       }
//     }
//     print(json.encode(searchResult));
//     setState(() {
//       data = searchResult;
//     });
//   }

//   @override
//   void initState() {
//     data = widget.list;
//     super.initState();
//   }

//   TextEditingController _controller = new TextEditingController();
//   TextEditingController _controller2 = new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         child: Scaffold(
//           body: Form(
//             key: key,
//             child: Stack(
//               children: [
//                 ListView(
//                   children: [
//                     if (!widget.showAsDialog)
//                       HomeAppbar(
//                         onBack: null,
//                       ),
//                     EditText(
//                       controller: _controller,
//                       updateFunc: (val) {
//                         setState(() {
//                           searchResult.clear();
//                         });
//                         search(val.toString());
//                         // print(val);
//                         // widget.list!.forEach((element) {
//                         //   if (element.title!.contains(val.toString())) {
//                         //     print("Got One ${element.id} - ${element.title}");
//                         //     searchResult.add(element);
//                         //     setState(() {});
//                         //   }
//                         // });
//                       },
//                       value: null,
//                       hint: 'Search',
//                       suffixData: Icon(Icons.search),
//                       radius: 12,
//                       type: TextInputType.text,
//                     ),
//                     // foodId == null
//                     //     ? SizedBox()
//                     //     : Padding(
//                     //         padding: const EdgeInsets.symmetric(horizontal: 10),
//                     //         child: EditText(
//                     //           value: '',
//                     //           hint: 'Enter Quantity',
//                     //           suffixData: Padding(
//                     //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     //             child: Column(
//                     //               children: [
//                     //                 Text("${unit}"),
//                     //                 Text("${calories} Calories"),
//                     //               ],
//                     //             ),
//                     //           ),
//                     //           radius: 12,
//                     //           type: TextInputType.phone,
//                     //           updateFunc: (text) {
//                     //             setState(() {
//                     //               quantity = int.parse(text);
//                     //             });
//                     //             print(quantity);
//                     //           },
//                     //           validateFunc: (text) {
//                     //             if (text.toString().isEmpty) {
//                     //               return "Enter Quantity";
//                     //             }
//                     //           },
//                     //         ),
//                     //       ),
//                     ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: searchResult.isEmpty ? data!.length : searchResult.length,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: () {
//                               for (int i = 0; i < data!.length; i++) {
//                                 setState(() {
//                                   data![i].isSellected = false;
//                                 });
//                               }
//                               setState(() {
//                                 data![index].isSellected = true;
//                                 food = data![index].title!;
//                                 foodId = data![index].id!;
//                                 unit = data![index].unit;
//                                 calories = data![index].caloriePerUnit;
//                               });
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "${data![index].title}",
//                                         style: TextStyle(color: Color(int.parse("0xFF${data![index].color}")), fontSize: 17),
//                                       ),
//                                       Icon(
//                                         data![index].isSellected == true ? Icons.radio_button_checked : Icons.radio_button_off,
//                                         color: kColorPrimary,
//                                       )
//                                     ],
//                                   ),
//                                   Text(
//                                     "${data![index].caloriePerUnit} Per ${data![index].unit}",
//                                     style: TextStyle(color: Color(int.parse("0xFF${data![index].color}")), fontSize: 12, fontWeight: FontWeight.bold),
//                                   ),
//                                   Divider(),
//                                   data![index].isSellected == true
//                                       ? Padding(
//                                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                                           child: Column(
//                                             children: [
//                                               EditText(
//                                                 controller: _controller2,
//                                                 value: null,
//                                                 hint: 'Enter Quantity',
//                                                 suffixData: Padding(
//                                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                                   child: Column(
//                                                     children: [
//                                                       Text("${unit}"),
//                                                       Text("${calories} Calories"),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 radius: 12,
//                                                 type: TextInputType.numberWithOptions(decimal: true),
//                                                 updateFunc: (String text) {
//                                                   setState(() {
//                                                     quantity = double.tryParse(text);
//                                                   });
//                                                   print(quantity);
//                                                 },
//                                                 validateFunc: (text) {
//                                                   if (text.toString().isEmpty) {
//                                                     return "Enter Quantity";
//                                                   }
//                                                 },
//                                               ),
//                                               quantity == null
//                                                   ? SizedBox()
//                                                   : Padding(
//                                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                                                       child: Text(
//                                                         "Total Calories : ${quantity! * calories!} Calories",
//                                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                                       ),
//                                                     ),
//                                               quantity == null
//                                                   ? SizedBox()
//                                                   : kButtonDefault(
//                                                       '  Save  ',
//                                                       marginH: MediaQuery.of(context).size.width / 4.5,
//                                                       paddingV: 0,
//                                                       func: () {
//                                                         if (!key.currentState!.validate()) {
//                                                           return;
//                                                         } else {
//                                                           updateProtineData(foodId, quantity!, index: index);
//                                                         }
//                                                       },
//                                                       shadow: true,
//                                                       paddingH: 30,
//                                                     ),
//                                             ],
//                                           ),
//                                         )
//                                       : SizedBox()
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                   ],
//                 ),
//                 ShowLoader == false
//                     ? SizedBox()
//                     : Container(
//                         child: Center(child: CircularLoadingWidget()),
//                         width: double.infinity,
//                         height: double.infinity,
//                         color: Colors.black.withOpacity(.9),
//                       )
//               ],
//             ),
//           ),
//         ),
//         onWillPop: _willPopCallback);
//   }

//   Future<bool> _willPopCallback() async {
//     Get.back();
//     // Get.offAllNamed(Routes.HOME);
//     // controller.currentIndex.value = 0;
//     return Future.value(false);
//   }

//   void updateProtineData(int? food, double _quantity, {int? index}) async {
//     setState(() => ShowLoader = true);
//     if (widget.edit == false) {
//       await ApiProvider().updateDiaryData(foodProtine: food, qtyProtiene: _quantity, date: widget.date!).then((value) {
//         if (value.success == true) {
//           setState(() {
//             ShowLoader = false;
//             foodId = null;
//             quantity == null;
//           });
//           _controller.clear();
//           _controller2.clear();
//           if (index != null) {
//             data![index].isSellected = false;
//           }
//           Fluttertoast.showToast(msg: "${value.message}");
//         } else {
//           setState(() {
//             ShowLoader = false;
//           });
//           Fluttertoast.showToast(msg: "Server Error");
//           print("error");
//         }
//       });
//     } else {
//       await ApiProvider().editDiaryData(foodProtine: food, qtyProtiene: _quantity, date: widget.date!, id: widget.id).then((value) {
//         if (value.success == true) {
//           setState(() {
//             ShowLoader = false;
//             foodId = null;
//             quantity == null;
//           });
//           _controller.clear();
//           _controller2.clear();
//           if (index != null) {
//             data![index].isSellected = false;
//           }
//           Fluttertoast.showToast(msg: "${value.message}");
//         } else {
//           setState(() {
//             ShowLoader = false;
//           });
//           Fluttertoast.showToast(msg: "Server Error");
//           print("error");
//         }
//       });
//     }
//   }
// }
