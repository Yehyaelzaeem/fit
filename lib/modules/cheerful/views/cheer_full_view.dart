
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/navigation/routes.dart';
import '../../../core/models/cheerful_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/utils/shared_helper.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../../core/view/widgets/text_inside_rec.dart';
import 'cheer_full_slider.dart';

class CheerFullView extends StatefulWidget {
  @override
  State<CheerFullView> createState() => _CheerFullViewState();
}

class _CheerFullViewState extends State<CheerFullView> {
  final GlobalController globalController =
  Get.find<GlobalController>(tag: 'global');

  final response = MealFeatureHomeResponse().obs;
  final error = ''.obs;
  final loading = false.obs;
  final isLoading = true.obs;
  bool isGuest = false;
  bool isGuestSaved = false;
  String userId = "";
  CheerfulSocialsResponse cheerfulSocialsResponse = CheerfulSocialsResponse();

  void getData() async {
    await ApiProvider().getCheerfulSocialsResponse().then((value) {
      if (value.success == true) {
        cheerfulSocialsResponse = value;
        isLoading.value = false;
      } else {
        Fluttertoast.showToast(msg: "Something went wrong!");
        print("error");
      }
    });
  }

  @override
  void onInit() async {
    getNetworkData();
    getData();
    userId = await SharedHelper().readString(CachingKey.USER_ID);
    isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
    isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    super.onInit();
  }


  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {
      response.value = await ApiProvider().getMealFeaturesHome();
      globalController.mealFeatureHomeResponse.value = response.value;
    } catch (e) {
      Echo('error response $e');
      error.value = '$e';
    }
    loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(
              () {
                if (controller.loading.value)
                  return Center(child: CircularLoadingWidget());
                if (controller.isLoading.value)
                  return Center(child: CircularLoadingWidget());

                if (controller.error.value.isNotEmpty)
                  return errorHandler(controller.error.value, controller);

                return SizedBox(
                  height: Get.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //App bar
                        appBar(),
                        //Slider
                        CheerFullSlider(sliders: [
                          ...controller.response.value.data!.sliders!
                              .map((e) => e.image!)
                              .toList(),
                        ]),
                        TextInsideRec(
                          text: controller.response.value.data!.info!.about!,
                        ),
                        SizedBox(height: 20),
                        kButtonWithIcon('Make My Meals', marginH: Get.width / 6,
                            func: () {
                              Get.toNamed(Routes.MY_MEALS);
                        }),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (controller.isGuestSaved) {
                              Get.toNamed(Routes.ORDERS);
                            } else if (controller.userId.isNotEmpty) {
                              Get.toNamed(Routes.ORDERS);
                            } else if (!controller.isGuestSaved&& controller.userId.isEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NonUserSubscribeView(
                                      isGuest: true,toOrders:true
                                    )),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin:
                                EdgeInsets.symmetric(horizontal: Get.width / 6),
                            padding: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200.0),
                              color: const Color(0xFFF1F1F1),
                              border: Border.all(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            child: kTextHeader('My Orders'),
                          ),
                        ),
                        SizedBox(height: 20),
                        controller.cheerfulSocialsResponse.data!.isEmpty
                            ? Container()
                            : Container(
                                height: Get.height * 0.12,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller
                                        .cheerfulSocialsResponse.data!.length,
                                    itemBuilder: (context, index) {
                                      return socialMediaItem(controller
                                          .cheerfulSocialsResponse
                                          .data![index]);
                                    }),
                              ),
                      ],
                    ),
                  ),
                );
              },
            )),
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
            child: Image.asset(kLogoChellFullRow, height: 60),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Widget socialMediaItem(CheerfulData data) {
    return InkWell(
      onTap: () async {
        String fallbackUrl = '${data.link}';
        try {
          bool launched = await launch(fallbackUrl, forceSafariVC: false);
          if (!launched) {
            await launch(fallbackUrl, forceSafariVC: false);
          }
        } catch (e) {
          await launch(fallbackUrl, forceSafariVC: false);
        }
      },
      child: buildImage("${data.image}"),
    );
  }

  Widget buildImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Image.network(
        "$path",
        width: 50,
        height: 50,
      ),
    );
  }
}
