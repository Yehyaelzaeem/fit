
import 'package:app/core/resources/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/models/orientation_videos_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../../videos/video_player_widget.dart';


class OrientationView extends StatefulWidget {
  @override
  State<OrientationView> createState() => _OrientationViewState();
}

class _OrientationViewState extends State<OrientationView> {
  final loading = true.obs;
  final response = OrientationVideosResponse().obs;
  final error = ''.obs;
  OrientationVideosResponse orientationVideosResponse =
  OrientationVideosResponse();




  void getData() async {
    await ApiProvider().getOrientationVideos().then((value) {
      if (value.success == true) {
        orientationVideosResponse = value;
        loading.value = false;
      } else {
        Fluttertoast.showToast(msg: "$value");
        print("error");
      }
    });
  }

  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {
      response.value = await ApiProvider().getOrientationVideos();
    } catch (e) {
      error.value = '$e';
    }
    loading.value = false;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(
      () {
        if (loading.value)
          return Center(child: CircularLoadingWidget());
        if (error.value.isNotEmpty)
          return errorHandler(error.value, null);

        return ListView(children: [
          HomeAppbar(type: null),
          SizedBox(height: 12),
          Row(
            children: [
              PageLable(name: "Orientation"),
            ],
          ),
          SizedBox(height: 12),
          orientationVideosResponse.data == null
              ? Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.2),
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.kEmptyPackage,
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
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: orientationVideosResponse.data?.length,
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
                                      builder: (_) => VideoPlayerWidget(
                                          link: orientationVideosResponse
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
                                      image: NetworkImage(orientationVideosResponse
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
                                  orientationVideosResponse
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
