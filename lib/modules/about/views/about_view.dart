import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../core/models/about_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';

class AboutView extends StatefulWidget {
const AboutView({Key? key}) : super(key: key);

@override
State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {

  AboutResponse? aboutResponse;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData()async{
    aboutResponse = await ApiProvider().getAboutData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      HomeAppbar(type: null),
      SizedBox(height: 12),
      PageLable(name: "About us"),

      //* phone
      Obx(() {
        if (aboutResponse!.success == true) {
          AboutResponse response = aboutResponse!;
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
        return SizedBox(
            height: 32,
            width: 48,
            child: CircularLoadingWidget());
      }),
      SizedBox(height: Get.width / 14),
    ]));
  }
}
