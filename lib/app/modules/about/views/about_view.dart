import 'package:app/app/models/about_response.dart';
import 'package:app/app/modules/about/controllers/about_controller.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class AboutView extends GetView<AboutController> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      HomeAppbar(type: null),
      SizedBox(height: 12),
      PageLable(name: "About us"),

      //* phone
      Obx(() {
        if (controller.aboutResponse.value.success == true) {
          AboutResponse response = controller.aboutResponse.value;
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: response.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "${response.data![index].title}",
                              style: TextStyle(
                                  color: kColorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  width: Get.width,
                                  child: Html(
                                      data:
                                          """${response.data![index].text}""")),
                              Container(
                                width: Get.width,
                                child: CachedNetworkImage(
                                  imageUrl: "${response.data![index].image}",
                                  fadeInDuration: Duration(seconds: 2),
                                  errorWidget: (vtx, url, obj) {
                                    return Container();
                                  },
                                  placeholder: (ctx, url) {
                                    return CircularLoadingWidget();
                                  },
                                  fit: BoxFit.contain,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                  ],
                );
              });
        }
        return Center(child: CircularLoadingWidget());
      }),
      SizedBox(height: Get.width / 14),
    ]));
  }
}
