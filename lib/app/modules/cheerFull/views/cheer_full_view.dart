import 'package:app/app/modules/cheerFull/views/cheer_full_slider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                if (controller.loading.value) return Center(child: CircularLoadingWidget());

                if (controller.error.value.isNotEmpty) return errorHandler(controller.error.value, controller);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      //App bar
                      appBar(),
                      //Slider
                      CheerFullSlider(sliders: [
                        ...controller.response.value.data!.sliders!.map((e) => e.image!).toList(),
                      ]),
                      // Group: Group 809
                      Container(
                        alignment: Alignment(0.0, 0.12),
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        height: 155.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          color: const Color(0xFFF1F1F1),
                        ),
                        child: SizedBox(
                          width: 307.0,
                          height: 155.0,
                          child: Column(
                            children: <Widget>[
                              Spacer(flex: 23),
                              Align(
                                alignment: Alignment(-0.09, 0.0),
                                child: Text(
                                  controller.response.value.data!.info!.about!,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    height: 1.38,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  launch(controller.response.value.data!.info!.location!);
                                },
                                child: Container(
                                  alignment: Alignment(-0.04, -0.33),
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  height: 39.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    color: const Color(0xFFF1F1F1),
                                    border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xFF7FC902),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 307.0,
                                    height: 36.0,
                                    child: Row(
                                      children: <Widget>[
                                        Spacer(flex: 103),
                                        Align(
                                          alignment: Alignment(0.0, 0.1),
                                          child: SvgPicture.string(
                                            // Icon material-location-on
                                            '<svg viewBox="130.4 401.0 11.2 16.0" ><path transform="translate(122.9, 398.0)" d="M 13.10000038146973 3 C 10.00399971008301 3 7.5 5.504000186920166 7.5 8.600000381469727 C 7.5 12.80000019073486 13.10000038146973 19 13.10000038146973 19 C 13.10000038146973 19 18.70000076293945 12.80000019073486 18.70000076293945 8.600000381469727 C 18.70000076293945 5.504000186920166 16.19600105285645 3 13.10000038146973 3 Z M 13.10000038146973 10.60000038146973 C 11.99600028991699 10.60000038146973 11.10000038146973 9.703999519348145 11.10000038146973 8.600000381469727 C 11.10000038146973 7.49600076675415 11.99600028991699 6.600000381469727 13.10000038146973 6.600000381469727 C 14.20400047302246 6.600000381469727 15.10000038146973 7.49600076675415 15.10000038146973 8.600000381469727 C 15.10000038146973 9.703999519348145 14.20400047302246 10.60000038146973 13.10000038146973 10.60000038146973 Z" fill="#7fc902" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                            width: 11.2,
                                            height: 16.0,
                                          ),
                                        ),
                                        Spacer(flex: 10),
                                        Text(
                                          'Location',
                                          style: GoogleFonts.cairo(
                                            fontSize: 19.0,
                                            color: const Color(0xFF7FC902),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Spacer(flex: 112),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 18),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      kButtonWithIcon('Make My Meals', marginH: Get.width / 6, func: () {
                        Get.toNamed(Routes.MY_MEALS);
                      }),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget appBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        children: [
          Center(
            child: Image.asset(kLogoChellFullRow, height: 44),
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
}
