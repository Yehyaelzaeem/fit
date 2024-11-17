import 'dart:io';

import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/resources/app_values.dart';
import 'package:app/core/resources/font_manager.dart';
import 'package:app/core/view/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/models/day_details_reposne.dart';
import '../../core/resources/app_colors.dart';
import '../../core/view/widgets/default/app_buttons.dart';
import '../../core/view/widgets/default/edit_text.dart';
import 'cubits/diary_cubit.dart';

class AddNewFood extends StatefulWidget {
  final String? date;
  final List<Food> list;

  const AddNewFood({
    Key? key,
    required this.list,
    this.date,
  }) : super(key: key);

  @override
  _AddNewFoodState createState() => _AddNewFoodState();
}

class _AddNewFoodState extends State<AddNewFood> {
  String food = "Choose Food";
  Food? selectedFood;
  double? quantity;
  int? foodId;

  String? unit = "";
  double? calories = 0;
  List<Food> searchResult = [];
  List<Food>? data;
  late String keyword;



  void search(String keyWord) {
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.list[i].title!.toUpperCase().contains(keyWord.toUpperCase())) {
        setState(() {
          searchResult.add(widget.list[i]);
        });
      }
    }
    // print(json.encode(searchResult));
    setState(() {
      data = searchResult;
    });
  }

  @override
  void initState() {
    data = widget.list;
    super.initState();
    data?.forEach((element) {
      element.isSellected = false;
    });
  }

  TextEditingController _controller = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.s12),
        child: Form(
          child: Column(
            children: [
              EditText(
                autofocus: true,
                controller: _controller,
                updateFunc: (val) {
                  setState(() {
                    searchResult.clear();
                  });
                  search(val.toString());
                },
                value: null,
                hint: 'Search',
                suffixData: Icon(Icons.search),
                radius: 12,
                type: TextInputType.text,
              ),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                      itemCount: searchResult.isEmpty
                          ? data!.length
                          : searchResult.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            for (int i = 0; i < data!.length; i++) {
                              setState(() {
                                data![i].isSellected = false;
                              });
                            }
                            setState(() {
                              data![index].isSellected = true;
                              food = data![index].title!;
                              foodId = data![index].id??9999;
                              unit = data![index].unit;
                              calories = data![index].caloriePerUnit;
                              selectedFood = data![index];
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:AppSize.s8,horizontal: AppSize.s4),
                                  child: (data![index].isFavourite)??false?InkWell(
                                      onTap: (){
                                        BlocProvider.of<DiaryCubit>(context).deleteFavoriteCalorie(data![index].id!);
                                        data![index].isFavourite = false;
                                        data!.sort((a, b) {
                                          // Prioritize isFavourite items
                                          if (a.isFavourite != b.isFavourite) {
                                            return a.isFavourite! ? -1 : 1;
                                          }
                                          // Then sort alphabetically by title
                                          return a.title!.compareTo(b.title!);
                                        });

                                        setState(() {

                                        });
                                      },
                                      child: SvgPicture.asset(AppIcons.heart,)):
                                  InkWell(
                                      onTap: (){
                                        BlocProvider.of<DiaryCubit>(context).addFavoriteCalorie(data![index].id!);
                                        data![index].isFavourite = true;

                                        data!.sort((a, b) {
                                          // Prioritize isFavourite items
                                          if (a.isFavourite != b.isFavourite) {
                                            return a.isFavourite! ? -1 : 1;
                                          }
                                          // Then sort alphabetically by title
                                          return a.title!.compareTo(b.title!);
                                        });

                                        setState(() {
                                        });
                                      },
                                      child: SvgPicture.asset(AppIcons.heartEmpty,)),
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            "${data![index].title}",

                                                color: Color(int.parse(
                                                    "0xFF${data![index].color}")),
                                                fontSize: FontSize.s16,
                                            fontWeight: FontWeightManager.medium,
                                          ),
                                          Icon(
                                            data![index].isSellected == true
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: kColorPrimary,
                                          )
                                        ],
                                      ),
                                      CustomText(
                                        "${data![index].caloriePerUnit} Per ${data![index].unit}",
                                            color: Color(int.parse(
                                                "0xFF${data![index].color}")),
                                            fontSize: FontSize.s12,
                                            fontWeight: FontWeightManager.medium,
                                      ),
                                      Divider(),
                                      data![index].isSellected == true
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Column(
                                                children: [
                                                  EditText(
                                                    controller: _controller2,
                                                    value: null,
                                                    hint: 'Enter Quantity',
                                                    suffixData: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 8),
                                                      child: Column(
                                                        children: [
                                                          Text("${unit}"),
                                                          Text(
                                                              "${calories} Calories"),
                                                        ],
                                                      ),
                                                    ),
                                                    radius: 12,
                                                    type: Platform.isIOS
                                                        ? TextInputType
                                                            .numberWithOptions(
                                                                signed: true,
                                                                decimal: true)
                                                        : TextInputType
                                                            .numberWithOptions(
                                                                decimal: true,
                                                                signed: false),
                                                    updateFunc: (String text) {
                                                      setState(() {
                                                        quantity =
                                                            double.tryParse(text);
                                                      });
                                                      print(quantity);
                                                    },
                                                    validateFunc: (text) {
                                                      if (text.toString().isEmpty) {
                                                        return "Enter Quantity";
                                                      }
                                                    },
                                                  ),
                                                  quantity == null
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 16,
                                                              vertical: 16),
                                                          child: Text(
                                                            "Total Calories : ${(quantity! * calories!).toStringAsFixed(2)} Calories",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                  quantity == null
                                                      ? SizedBox()
                                                      : kButtonDefault(
                                                          '  Select  ',
                                                          marginH:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  4.5,
                                                          paddingV: 0,
                                                          func: () {
                                                            selectedFood?.qty =
                                                                quantity;
                                                            data![index].isSellected = false;
                                                            NavigationService.goBack(context,

                                                                    selectedFood);
                                                          },
                                                          shadow: true,
                                                          paddingH: 30,
                                                        ),
                                                ],
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
