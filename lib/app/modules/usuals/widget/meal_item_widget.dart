import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/default/text.dart';
import 'calories_type_item_widget.dart';

class MealItemWidget extends StatelessWidget {
  const MealItemWidget(
      {Key? key, required this.mealName, required this.mealCalories})
      : super(key: key);
  final String mealName;
  final String mealCalories;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kTextbody(mealName,
                  size: 18,
                  color: kColorPrimary,
                  align: TextAlign.start,
                  bold: true),
              SizedBox(
                height: 4,
              ),
              kTextbody(
                "($mealCalories Cal.)",
                size: 14,
                color: kColorAccent,
                align: TextAlign.start,
              ),
            ],
          )),
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                icon: Icons.fastfood,
                iconColor: Colors.brown,
                title: '    Add to diary',
                onTap: () {
                  Get.back();
                },
              ),
              PullDownMenuItem(
                icon: Icons.remove_red_eye,
                iconColor: kColorPrimary,
                title: '    View',
                onTap: () {
                  appDialog(
                      title: "$mealName \n ($mealCalories Cal.)",
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          CaloriesTypeItemWidget(
                              caloriesTypeName: 'Proteins',
                              totalCalories: "200"),
                          CaloriesTypeItemWidget(
                              caloriesTypeName: 'Carbs', totalCalories: "400"),
                          CaloriesTypeItemWidget(
                              caloriesTypeName: 'Fats', totalCalories: "300"),
                          SizedBox(
                            height: 18,
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kColorPrimary,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '    Close    ',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              ),
              PullDownMenuItem(
                icon: Icons.edit,
                iconColor: Colors.blue,
                title: '    Edit',
                onTap: () {
                  Get.toNamed(Routes.MALEAMEAL);
                },
              ),
              PullDownMenuItem(
                iconColor: Colors.red,
                icon: Icons.delete,
                title: '    Delete',
                isDestructive: true,
                onTap: () {
                  appDialog(
                    title: "Do you want to delete $mealName?",
                    image: Icon(Icons.delete, size: 24, color: Colors.red),
                    cancelAction: () {
                      Get.back();
                    },
                    cancelText: "No",
                    confirmAction: () {
                      Get.back();
                    },
                    confirmText: "Yes",
                  );
                },
              ),
            ],
            buttonBuilder: (context, showMenu) => CupertinoButton(
              pressedOpacity: 0.2,
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.ellipsis_circle,
                size: 30,
              ),
            ),
          ),
/*
          GestureDetector(
            onTap: (){

            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF414042),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
*/
          SizedBox(
            width: 8,
          )
          /*    GestureDetector(
            onTap: ()  {},
            child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Icon(
                  Icons.settings,
                  size: 18,
                )),
          ),*/
        ],
      ),
    );
  }
}
