import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/modules/orientation_register/views/orientation_register_view.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app/modules/home/home_slider.dart';

// import 'app/modules/orientation_register/views/orientation_register_view.dart';
import 'app/network_util/api_provider.dart';
import 'app/utils/theme/app_colors.dart';
import 'app/widgets/default/text.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  HomePageResponse ress = HomePageResponse();
  bool isLoading = true;
  List<String> homeSliderList = [];
  int pageIndex = 0;
  int serviceIndex = 0;

  void getHomeData() async {
    await ApiProvider().getHomeData().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          isLoading = false;
          ress.data!.slider!.forEach((element) {
            homeSliderList.add(element.image!);
          });
        });
        print(homeSliderList);
      } else {
        Fluttertoast.showToast(msg: "$value");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getHomeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? CircularLoadingWidget()
        : ListView(
            children: [
              HomeSlider(sliders: homeSliderList),
              SizedBox(
                height: 16,
              ),
              Container(
                decoration:
                    BoxDecoration(color: ACCENT_COLOR, borderRadius: BorderRadius.circular(50)),
                height: 45,
                child: ListView.builder(
                    itemCount: ress.data!.services!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            pageIndex = index;
                            serviceIndex = 0;
                          });
                          print(index);
                        },
                        child: Material(
                          elevation: pageIndex == index ? 10 : 0,
                          shadowColor: pageIndex == index ? kColorPrimary : ACCENT_COLOR,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            // padding: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: pageIndex == index ? Colors.white : ACCENT_COLOR,
                              borderRadius: BorderRadius.circular(64),
                            ),
                            child: Center(
                              child: kTextHeader(
                                "${ress.data!.services![index].title}",
                                color: pageIndex == index ? kColorPrimary : Colors.white,
                                bold: pageIndex == index,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 120,
                child: ListView.builder(
                    itemCount: ress.data!.services![pageIndex].items!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            serviceIndex = index;
                          });
                        },
                        child: Container(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: serviceIndex == index ? kColorPrimary : Colors.black87,
                                    width: serviceIndex == index ? 1 : 0.02,
                                  ),
                                  boxShadow: [
                                    if (serviceIndex == index)
                                      BoxShadow(
                                        color: kColorPrimary,
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, 0),
                                      ),
                                    if (serviceIndex != index)
                                      BoxShadow(
                                        color: const Color(0xFF414042).withOpacity(0.35),
                                        offset: Offset(0, 1.0),
                                        blurRadius: 6.0,
                                      ),
                                  ],
                                ),
                                child: Image.network(
                                  "${ress.data!.services![pageIndex].items![index].image}",
                                  width: 50,
                                  height: 40,
                                ),
                              ),
                              Expanded(
                                child: kTextbody(
                                  ress.data!.services![pageIndex].items![index].title ?? "",
                                  color: serviceIndex == index ? kColorPrimary : Colors.black87,
                                  bold: serviceIndex == index,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment(-0.14, -1.0),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                    width: MediaQuery.of(context).size.width / 1.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(64.0),
                      ),
                      color: kColorAccent,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF414042).withOpacity(0.35),
                          offset: Offset(0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${ress.data!.services![pageIndex].items![serviceIndex].title}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(8),
                    // color: Colors.grey[300],
                    width: double.infinity,
                    child: kTextbody('${ress.data!.services![pageIndex].items![serviceIndex].text}',
                        align: TextAlign.start , size: 15),
                  ),
                  ress.data!.services![pageIndex].items![serviceIndex].cover!.type == "image"
                      ? CachedNetworkImage(
                          width: double.infinity,
                          imageUrl:
                              '${ress.data!.services![pageIndex].items![serviceIndex].cover!.content}',
                          fadeInDuration: Duration(seconds: 2),
                          // errorWidget: (vtx, url, obj) {
                          //   return Image.network(
                          //     "https://img.pikbest.com/png-images/qianku/404-error-model_2369179.png",
                          //     width: double.infinity,
                          //     height: Get.height / 4,
                          //     fit: BoxFit.fitWidth,
                          //   );
                          // },
                          placeholder: (ctx, url) {
                            return CircularLoadingWidget();
                          },
                          fit: BoxFit.contain,
                        )
                      : ress.data!.services![pageIndex].items![serviceIndex].cover!.type == "video"
                          ? Container(
                              child: Html(
                              shrinkWrap: true,
                              data:
                                  """${ress.data!.services![pageIndex].items![serviceIndex].cover!.content} """,
                            ))
                          : Center(
                              child: Text(
                                " Sorry ,, No Media Available",
                                style: TextStyle(color: kColorPrimary, fontWeight: FontWeight.bold),
                              ),
                            ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OrientationRegisterView()));
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),

                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            color: kColorPrimary,
                            borderRadius: BorderRadius.circular(64),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ]),
                        child: kTextHeader('Orientation Registration',
                            size: 16, color: Colors.white, bold: true, paddingH: 16, paddingV: 4),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ],
          );
  }
}
