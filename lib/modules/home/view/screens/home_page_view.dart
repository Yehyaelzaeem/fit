
import 'package:app/core/resources/app_colors.dart';
import 'package:app/core/resources/app_values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../../config/navigation/navigation_services.dart';
import '../../../../config/navigation/routes.dart';
import '../../../../core/models/home_page_response.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../../orientation_register/views/orientation_register_view.dart';
import '../../cubits/home_cubit.dart';
import '../widgets/home_slider.dart';
import 'home_screen.dart';


class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final HomeCubit homeCubit;


  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.loadHomePage();
    // getHomeData();
    super.initState();
  }

  // bool isLoading = true;
  // List<String> homeCubit.homeSliderList = [];
  int pageIndex = 0;
  int serviceIndex = 0;

  // void getHomeData() async {
  //   await ApiProvider().getHomeData().then((value) async{
  //     if (value.success == true) {
  //       homeCubit.homeResponse! = value;
  //       isLoading = false;
  //       homeCubit.homeResponse!.data!.slider!.forEach((element) {
  //         homeCubit.homeSliderList.add(element.image!);
  //       });
  //       setState(() {});
  //       globalIsIosInReview = (homeCubit.homeResponse!.data!.subscriptionStatus == false);
  //     } else {
  //       await ApiProvider().getHomeData(notLogged:true).then((value) {
  //         if (value.success == true) {
  //           homeCubit.homeResponse! = value;
  //           isLoading = false;
  //           homeCubit.homeResponse!.data!.slider!.forEach((element) {
  //             homeCubit.homeSliderList.add(element.image!);
  //           });
  //           setState(() {});
  //           globalIsIosInReview = (homeCubit.homeResponse!.data!.subscriptionStatus == false);
  //         }else{
  //
  //           Fluttertoast.showToast(msg: "$value");
  //           // Fluttertoast.showToast(msg: "AAAXL");
  //         }
  //       });
  //       // isLoading = false;
  //       // setState(() {
  //       //
  //       // });
  //       print("error");
  //     }
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is HomePageFailureState) {
            Alerts.showToast(state.failure.message);
          }

        },
        builder: (context, state) => state is HomePageLoadingState
            ? CircularLoadingWidget()
        : ListView(
            children: [
              HomeSlider(sliders: homeCubit.homeSliderList),
              SizedBox(
                height: 16,
              ),
              if (!globalIsIosInReview) ...[
                Container(
                  decoration: BoxDecoration(color: AppColors.ACCENT_COLOR, borderRadius: BorderRadius.circular(50)),
                  height: 45,
                  child: ListView.builder(
                      itemCount: homeCubit.homeResponse!.data!.services!.length,
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
                            shadowColor: pageIndex == index ? kColorPrimary : AppColors.ACCENT_COLOR,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              // padding: EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: pageIndex == index ? Colors.white : AppColors.ACCENT_COLOR,
                                borderRadius: BorderRadius.circular(64),
                              ),
                              child: Center(
                                child: kTextHeader(
                                  "${homeCubit.homeResponse!.data!.services![index].title}",
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
                      itemCount: homeCubit.homeResponse!.data!.services![pageIndex].items!.length,
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
                                      color: serviceIndex == index ? kColorPrimary : Colors.transparent,
                                      width: serviceIndex == index ? 1 : 1,
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
                                          offset: Offset(1, 1.0),
                                          blurRadius: 3.0,
                                        ),
                                    ],
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:"${homeCubit.homeResponse!.data!.services![pageIndex].items![index].image}",
                                    width: 50,
                                    height: 40,
                                    cacheManager: DefaultCacheManager(), // Use the default cache manager
                                    placeholder: (ctx, url) {
                                      return CircularLoadingWidget();
                                    },
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3.2,
                                  child: Text(
                                    homeCubit.homeResponse!.data!.services![pageIndex].items![index].title!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: serviceIndex == index ? kColorPrimary : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
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
                      color: AppColors.ACCENT_COLOR,
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
                        '${homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].title}',
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
                    child: kTextbody('${homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].text}', align: TextAlign.start, size: 15),
                  ),
                  homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].cover!.type == "image"
                      ? CachedNetworkImage(
                          width: double.infinity,
                          imageUrl: '${homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].cover!.content}',
                          fadeInDuration: Duration(seconds: 2),
                    cacheManager: DefaultCacheManager(), // Use the default cache manager

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
                      : homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].cover!.type == "video"
                          ? Container(
                              child: Html(
                              shrinkWrap: true,
                              data: """${homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].cover!.content} """,
                            ))
                          : Center(
                              child: SizedBox(),
                            ),
                  SizedBox(
                    height: 50,
                  ),
                  homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].hasOrientation == true
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrientationRegisterView(id: homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].id!)));
                          },
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              margin: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(64), boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ]),
                              child: kTextHeader('Orientation Registration', size: 16, color: Colors.white, bold: true, paddingH: 16, paddingV: 4),
                            ),
                          ),
                        )
                      : homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].hasOrientation == false && homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].link != null
                          ? GestureDetector(
                              onTap: () {
                                _launchURL(homeCubit.homeResponse!.data!.services![pageIndex].items![serviceIndex].link);
                              },
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(64), boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: kTextHeader(
                                      "Details ",
                                      size: 16,
                                      color: Colors.white,
                                      bold: true,
                                      paddingH: 12,
                                      paddingV: 4,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                  homeCubit.homeResponse!.data!.subscriptionStatus == true
                      ? GestureDetector(
                          onTap: () async{
                            final result = await Connectivity().checkConnectivity();
                            if (result != ConnectivityResult.none) {
                              NavigationService.push(context,
                                Routes.subscribeView,
                              );
                            }else{
                              Fluttertoast.showToast(msg: "Please connect the internet",toastLength: Toast.LENGTH_LONG);

                            }

                          },
                          child: Center(
                            child: Container(
                              width: deviceWidth / 2,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              margin: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(color: Color(0xffFFB62B), borderRadius: BorderRadius.circular(64), boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/premium.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  kTextHeader('Subscribe', size: 16, color: Colors.white, bold: true, paddingH: 16, paddingV: 4),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ],
          ));
  }

  void _launchURL(_url) async => await launch(_url);
// await canLaunch(_url) == false ?  : throw 'Could not launch $_url';
}
