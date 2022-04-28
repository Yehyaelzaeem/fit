import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                //App bar
                appBar(),
                SizedBox(height: 20),
                header(),
                SizedBox(height: 4),
                for (int i = 0; i < 3; i++) singleItem(id: i, title: "Meal", price: "120 L.E"),
                SizedBox(height: 12),
                header2("Total Price", Container(margin: EdgeInsets.symmetric(horizontal: 12), child: kTextbody("560 L.E", color: Colors.white))),

                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: kTextbody("Instructions", size: 18, align: TextAlign.start, paddingH: 12),
                ),
                SizedBox(height: 6),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: EditText(
                    value: "Lorem ipsum dolor sit amet, consectetur  elit, sed do eiusmod tempor incididunt ut labore adipiscing",
                    hintColor: Color(0xff8D8D8D),
                    enable: false,
                    background: Color(0xffF1F1F1),
                    updateFunc: (value) {},
                    noBorder: true,
                    radius: 4,
                    lines: 3,
                  ),
                ),
                SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                        child: kButtonDefault("Delivery", func: () {
                      Get.toNamed(Routes.CART);
                    })),
                    Expanded(
                        child: kButtonDefault(
                      "Pick up ",
                      color: Color(0xffF1F1F1),
                      textColor: Colors.black,
                      border: Border.all(color: Color(0xffF1F1F1), width: 1),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      children: [
        PageLable(name: "Cart"),
        Expanded(child: SizedBox(width: 10)),
      ],
    );
  }

  Widget header2(String title, Widget action) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
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

  Widget appBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              kLogoChellFullRow,
              height: 44,
            ),
          ),
          GestureDetector(
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
          )
        ],
      ),
    );
  }

  Widget singleItem({
    required int id,
    required String title,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffF1F1F1),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (val) {}),
          Expanded(child: kTextbody("$title $id", color: kColorPrimary, align: TextAlign.start, bold: true)),
          kTextbody(price, color: Colors.black),
          Container(padding: EdgeInsets.all(6), margin: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.edit, size: 18)),
        ],
      ),
    );
  }
}
