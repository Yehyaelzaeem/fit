
import 'package:app/core/resources/app_assets.dart';
import 'package:app/modules/shippingDetails/views/pick_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/models/mymeals_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/edit_text.dart';
import '../../../core/view/widgets/default/text.dart';
import '../cubits/shipping_details_cubit.dart';

class ShippingDetailsView extends StatefulWidget {

  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String detailedAddress;
  final List<SingleMyMeal> meals;

  const ShippingDetailsView({Key? key,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.detailedAddress,
    required this.meals,
  }) : super(key: key);


  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<ShippingDetailsView> {
  late final ShippingDetailsCubit shippingDetailsCubit;


  @override
  void initState() {
    super.initState();
    shippingDetailsCubit = BlocProvider.of<ShippingDetailsCubit>(context);
    shippingDetailsCubit.onInit();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Obx(
          () => Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: shippingDetailsCubit.key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    appBar(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //First name
                          Row(
                            children: [
                              Icon(Icons.person, color: kColorPrimary),
                              kTextbody('First Name', size: 18, bold: true),
                            ],
                          ),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: EditText(
                              value: shippingDetailsCubit.name.value,
                              hint: '',
                              radius: 4,
                              noBorder: true,
                              background: Color(0xffeeeeee),
                              updateFunc: (String text) {
                                shippingDetailsCubit.name.value = text;
                              },
                              validateFunc: (text) {
                                if (text.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              type: TextInputType.name,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //First name
                          Row(
                            children: [
                              Icon(Icons.person, color: kColorPrimary),
                              kTextbody('Last Name', size: 18, bold: true),
                            ],
                          ),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: EditText(
                              value: shippingDetailsCubit.lastName.value,
                              hint: '',
                              radius: 4,
                              noBorder: true,
                              background: Color(0xffeeeeee),
                              updateFunc: (String text) {
                                shippingDetailsCubit.lastName.value = text;
                              },
                              validateFunc: (text) {
                                if (text.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              type: TextInputType.name,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),

                    //* Email
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.email, color: kColorPrimary),
                                    kTextbody('Email', size: 18, bold: true),
                                  ],
                                ),
                                Container(
                                  color: Color(0xffeeeeee),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: EditText(
                                    value: shippingDetailsCubit.email.value,
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {
                                      shippingDetailsCubit.email.value = text;
                                    },
                                    validateFunc: (text) {
                                      if (text != null &&
                                          !text.toString().contains("@")) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.emailAddress,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //* Mobile Number
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.phone_iphone,
                                        color: kColorPrimary),
                                    kTextbody('Mobile Number',
                                        size: 18, bold: true),
                                  ],
                                ),
                                Container(
                                  color: Color(0xffeeeeee),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: EditText(
                                    value: shippingDetailsCubit.phone.value,
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {
                                      shippingDetailsCubit.phone.value = text;
                                    },
                                    validateFunc: (text) {
                                      if (text.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.number,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //* DetailedAddress
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.location_city,
                                        color: kColorPrimary),
                                    kTextbody('Detailed delivery address',
                                        size: 18, bold: true),
                                  ],
                                ),
                                Container(
                                  color: Color(0xffeeeeee),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: EditText(
                                    value: shippingDetailsCubit.detailedAddress.value,
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {
                                      shippingDetailsCubit.detailedAddress.value = text;
                                    },
                                    validateFunc: (text) {
                                      if (text.isEmpty) {
                                        return 'Please enter your address';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.text,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //* Location
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed, color: kColorPrimary),
                                    kTextbody('Current location',
                                        size: 18, bold: true),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (shippingDetailsCubit.mapLoading.value == true)
                                      return;
                                    shippingDetailsCubit.mapLoading.value = true;
                                    await shippingDetailsCubit.requestPermission();
                                    Get.dialog(PickMap());
                                    shippingDetailsCubit.mapLoading.value = false;
                                  },
                                  child: Container(
                                    color: Color(0xffeeeeee),
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    width: Get.width,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        if (shippingDetailsCubit
                                                .textController.text.isEmpty &&
                                            shippingDetailsCubit
                                                .latitude.value.isNotEmpty)
                                          Expanded(
                                            child: kTextbody(
                                              "${shippingDetailsCubit.latitude.value}, ${shippingDetailsCubit.longitude.value}",
                                            ),
                                          ),
                                        if (shippingDetailsCubit
                                            .textController.text.isNotEmpty)
                                          Expanded(
                                            child: kTextbody(
                                              "${shippingDetailsCubit.textController.text}",
                                            ),
                                          ),
                                        if (shippingDetailsCubit
                                                .textController.text.isEmpty &&
                                            shippingDetailsCubit.latitude.value.isEmpty)
                                          kTextbody("Choose location",
                                              paddingH: 12, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          kButtonDefault(
                            'Submit',
                            marginH: MediaQuery.of(context).size.width / 4,
                            paddingV: 0,
                            func: () {
                              if (!shippingDetailsCubit.key.currentState!.validate()) {
                                return;
                              } else {
                                shippingDetailsCubit.submit();
                              }
                            },
                            shadow: true,
                            paddingH: 16,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 14),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
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
              height: 80,
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
}
