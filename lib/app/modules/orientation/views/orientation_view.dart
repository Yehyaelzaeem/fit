import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/orientation/controllers/orientation_controller.dart';
import 'package:app/app/modules/videos/vimeo_player_widget.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helper/assets_path.dart';

class OrientationView extends GetView<OrientationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(
      () {
        if (controller.loading.value)
          return Center(child: CircularLoadingWidget());
        if (controller.error.value.isNotEmpty)
          return errorHandler(controller.error.value, controller);

        return ListView(children: [
          HomeAppbar(type: null),
          SizedBox(height: 12),
          Row(
            children: [
              PageLable(name: "Orientation"),
            ],
          ),
          SizedBox(height: 12),
          controller.orientationVideosResponse.data == null
              ? Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.2),
                  child: Column(
                    children: [
                      Image.asset(
                        kEmptyPackage,
                        scale: 5,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      kTextbody("  Empty!  ", size: 16),
                    ],
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.92,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: controller.orientationVideosResponse.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => VimeoPlayerWidget(
                                          link: controller
                                                  .orientationVideosResponse
                                                  .data?[index]
                                                  .videoUrl ??
                                              "")));
                            },
                            child: Container(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? Get.height * 0.6
                                  : Get.height * 0.18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  image: DecorationImage(
                                      image: NetworkImage(controller
                                              .orientationVideosResponse
                                              .data?[index]
                                              .image ??
                                          ""),
                                      fit: MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? BoxFit.fill
                                          : BoxFit.cover)),
                              child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.play_circle,
                                      color: kColorPrimary,
                                    )),
                              ),
                            ),
                          ),
                          Center(
                              child: kTextbody(
                                  controller.orientationVideosResponse
                                          .data?[index].name ??
                                      "",
                                  size: 12)),
                        ],
                      ),
                    );
                  }),
        ]);
      },
    ));
  }
}
