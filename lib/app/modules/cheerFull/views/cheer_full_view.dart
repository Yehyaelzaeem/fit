import 'package:app/app/models/cheerful_response.dart';
import 'package:app/app/modules/cheerFull/views/cheer_full_slider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/text_inside_rec.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/cheer_full_controller.dart';

class CheerFullView extends GetView<CheerFullController> {
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
                            Get.toNamed(Routes.ORDERS);
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
