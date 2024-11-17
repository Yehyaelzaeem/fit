
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/resources/app_colors.dart';
import 'package:app/core/resources/app_values.dart';
import 'package:app/core/resources/font_manager.dart';
import 'package:app/core/utils/globals.dart';
import 'package:app/core/utils/shared_helper.dart';
import 'package:app/core/view/views.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../config/navigation/routes.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/strings.dart';
import '../../../../core/view/widgets/app_dialog.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../../auth/cubit/auth_cubit/auth_cubit.dart';
import '../../../general/cubits/general_data_cubit.dart';
import '../../cubits/home_cubit.dart';
import '../screens/home_screen.dart';

class HomeDrawer extends StatefulWidget {
const HomeDrawer({Key? key}) : super(key: key);

@override
State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
late final HomeCubit homeCubit;
late final GeneralDataCubit generalDataCubit;


@override
void initState() {
super.initState();
homeCubit = BlocProvider.of<HomeCubit>(context);
generalDataCubit = BlocProvider.of<GeneralDataCubit>(context);
// homeCubit.onInit(BlocProvider.of<DiaryCubit>(context));
checkIfUserIsLogged();
}
//
// final homeCubit = Get.find<HomeController>(tag: 'home');
//   final GlobalController globalController =
//       Get.find<GlobalController>(tag: 'global');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {
        if (state is SendReportFailureState) {
          Alerts.showToast(state.failure.message);
        }
      
      },
      builder: (context, state) => state is GetHomeLoadingState
      ?  Container()
          : itemBuilder()
          ),
    );
  }

  Widget itemBuilder() {
    SharedHelper prefs = SharedHelper();

    return Container(
      // width: deviceWidth / 1.5,
      height: double.infinity,
      color: Colors.white,
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
      if (state is SendReportFailureState) {
        Alerts.showToast(state.failure.message);
      }

    },
    builder: (context, state) => state is GetHomeLoadingState
    ?  Container()
        :SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(width: deviceWidth,height: deviceHeight,),
            Positioned(
              top: -100,
              child: Container(
                padding: EdgeInsets.all(AppSize.s32),
                width: deviceWidth,
                height: deviceWidth,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1)
                ),
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(AppSize.s32),
                  width: deviceWidth - AppSize.s56,
                  height: deviceWidth - AppSize.s56,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1)
                  ),
                  child: Container(
                    padding: EdgeInsets.all(AppSize.s40),
                    width: deviceWidth - AppSize.s100,
                    height: deviceWidth - AppSize.s100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.1)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSize.s32),
                      width: deviceWidth - AppSize.s100,
                      height: deviceWidth - AppSize.s100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1)
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Column(
              children: <Widget>[

                if(currentUser?.data == null)
                  VerticalSpace(AppSize.s24),
                
                // if (prefs.getUserId() != null)
                currentUser?.data == null
                    ? Padding(
                      padding:
                      const EdgeInsets.symmetric( horizontal: AppSize.s16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: AppSize.s64,
                          ),  Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSize.s20),
                            child: Image.asset(
                              AppImages.kImgLogoWhiteNoBk,
                              width: deviceWidth / 3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:AppSize.s16,vertical: AppSize.s24),
                            child: InkWell(
                                onTap: (){
                                  NavigationService.goBack(context);
                                },
                                child: Icon(Icons.close)),
                          ),

                        ],
                      ),
                    )
                    : Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          children: [
                            SizedBox(
                              height: AppSize.s32 - 2,
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: AppSize.s56,),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(250),
                                    // ignore: unnecessary_null_comparison
                                    child: CachedNetworkImage( 
                                      imageUrl: '${currentUser?.data?.image}',
                                      fit: BoxFit.cover,

                                      height: AppSize.s100,
                                      width: AppSize.s100,

                                      placeholder: (ctx, url) {
                                        return profileImageHolder();
                                      },
                                      errorWidget: (context, url, error) {
                                        return profileImageHolder();
                                      },
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:AppSize.s16,vertical: AppSize.s16),
                                  child: InkWell(
                                      onTap: (){
                                        NavigationService.goBack(context);
                                      },
                                      child: Icon(Icons.close)),
                                ),

                              ],
                            )
                            // if (prefs.getName() != null && prefs.getName()!.isNotEmpty)
                            // Text(prefs.getName()!)
                            ,
                            SizedBox(
                              height: AppSize.s6,
                            ),
                             CustomText(
                                 '${currentUser?.data?.name}',
                                  fontSize: FontSize.s20,
                               fontWeight: FontWeightManager.semiBold,
                             ),
                            CustomText('ID : ${currentUser?.data?.id}',
                                fontSize: FontSize.s16, fontWeight: FontWeightManager.regular, ),
                            SizedBox(
                              height: 30,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Icon(Icons.circle, size: 13, color: kColorPrimary),
                            //     kTextfooter(' Active', color: kColorPrimary, size: 14, paddingV: 0),
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Icon(Icons.circle, size: 13, color: kColorPrimary),
                            //     kTextfooter(' Active', color: kColorPrimary, size: 14, paddingV: 0),
                            //   ],
                            // ),
                          ],
                        )),

                VerticalSpace(AppSize.s82),

                if(currentUser?.data == null)
                  VerticalSpace(AppSize.s64),
                if (!globalIsIosInReview)
                  singleDrawerItem(
                      action: () {
                        NavigationService.push(context,Routes.myPackagesView);
                      },
                      title: "My Packages",
                      image: "assets/icons/crown.svg"),
            
                // //Profile
                currentUser?.data == null
                    ? SizedBox()
                    : singleDrawerItem(
                        title: 'Profile',
                    image: 'assets/icons/user.svg',
                        action: () {
                          NavigationService.push(context,Routes.profile);
                        }),
            
                //Messages
                currentUser?.data == null
                    ? SizedBox()
                    : singleDrawerItem(
                        title: 'Messages',
                    image: 'assets/icons/messages.svg',
                        action: () {
                          NavigationService.push(context,Routes.notificationScreen);
                        }),
                //Messages
            
                currentUser?.data == null
                    ? SizedBox()
                    : homeCubit.faqStatus == false
                        ? SizedBox()
                        : singleDrawerItem(
                            title: 'FAQ',
                    image: 'assets/icons/faq.svg',
                            action: () {
                              NavigationService.push(context,Routes.faqs);
                            }),
                //FAQ
                /*    FutureBuilder<bool>(
                  future: getFaqStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) if (snapshot.data!)
                      return singleDrawerItem(
                          title: 'FAQ',
                          image: 'assets/icons/faq.svg',
                          action: () {
                            NavigationService.push(context,Routes.FAQ);
                          });
                    return Container();
                  },
                ),*/
                //Transformation
                singleDrawerItem(
                    title: 'Transformations',
                    image: 'assets/icons/transformation.svg',
                    action: () async{
                final result = await Connectivity().checkConnectivity();
                if (result != ConnectivityResult.none) {
                  NavigationService.push(context,Routes.transformView);
                }else{
                  Fluttertoast.showToast(msg: "Please connect the internet",toastLength: Toast.LENGTH_LONG);
                }
                    }),
                currentUser == null
                    ? SizedBox()
                    : homeCubit.orientationStatus == false
                        ? SizedBox()
                        : singleDrawerItem(
                            title: 'Orientation',
                    image: 'assets/icons/orientation.svg',
                            action: () async{
                              final result = await Connectivity().checkConnectivity();
                              if (result != ConnectivityResult.none) {
                                NavigationService.push(context,Routes.orientation);
                              }else{
                                Fluttertoast.showToast(msg: "Please connect the internet",toastLength: Toast.LENGTH_LONG);
            
                              }
                            }),
                //CHEER_FULL
                //
                if (!globalIsIosInReview)
                  homeCubit.cheerfulResponse.value.data?.isActive == false
                      ? SizedBox()
                      : singleDrawerItem(
                          title: "Cheer-Full",
                      image: 'assets/icons/cheer.svg',
                action: () async{
                final result = await Connectivity().checkConnectivity();
                if (result != ConnectivityResult.none) {
                NavigationService.push(context,Routes.cheerful);
                }else{
                Fluttertoast.showToast(msg: "Please connect the internet",toastLength: Toast.LENGTH_LONG);
            
                }
                }
                          ),
                /*      FutureBuilder<bool>(
                  future: getCheerFullStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) if (snapshot.data!)
                      return singleDrawerItem(
                          title: "Cheer-Full",
                          image: 'assets/icons/cheer.svg',
                          action: () {
                            NavigationService.push(context,Routes.CHEER_FULL);
                          });
                    return Container();
                  },
                ),*/
                //Orders
                // singleDrawerItem(
                //     title: "My Orders",
                //     image: 'assets/img/ic_orders.png',
                //     action: () {
                //       NavigationService.push(context,Routes.ORDERS);
                //     }),
                //Contact
                singleDrawerItem(
                    title: 'Contact us',
                    image: 'assets/icons/contact.svg',
                action: () async{
                final result = await Connectivity().checkConnectivity();
                if (result != ConnectivityResult.none) {
                NavigationService.push(context,Routes.contactUs);
                }else{
                Fluttertoast.showToast(msg: "Please connect the internet",toastLength: Toast.LENGTH_LONG);
            
                }
                }),
                //About
                singleDrawerItem(
                    title: "About us",
                    image: 'assets/icons/about_us.svg',
                    action: () async{
                final result = await Connectivity().checkConnectivity();
                if (result != ConnectivityResult.none) {
                  NavigationService.push(context,Routes.about);
                }else{
                Fluttertoast.showToast(msg: "Please connect the internet",toastLength: Toast.LENGTH_LONG);
            
                }
                }),
                currentUser?.data == null
                    ? singleDrawerItem(
                    isDifferent:true,
                        title: "Login",
                    image: "assets/icons/logout.svg",
                        action: () {
                          NavigationService.pushReplacementAll(context,Routes.authScreen);
                        })
                    : singleDrawerItem(
                  isDifferent:true,
                        title: 'Logout',
                    image: "assets/icons/logout.svg",
                        action: () {
                          appDialog(
                            title: "Logout",
                            context: context,
                            image: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset("assets/icons/logout.svg",
                                  width: AppSize.s32, color: Colors.red),
                            ),
                            cancelAction: () {
                              NavigationService.goBack(context);
                            },
                            cancelText: "No",
                            confirmAction: () {
                              // prefs.logout();
                              BlocProvider.of<AuthCubit>(context).logout();
                              loadingHome=null;
                              NavigationService.pushReplacementAll(context,Routes.splashScreen);
                            },
                            confirmText: "Yes",
                          );
                        }),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget profileImageHolder() {
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.person, size: 40, color: Colors.grey[200]),
      ),
    );
  }

  Widget singleDrawerItem(
      { bool isDifferent = false,required String title, required String image, var action}) {
    return InkWell(
      onTap: action,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: isDifferent?MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              SizedBox(width: AppSize.s24),
              image.contains('png')?Image.asset(
                image,
                width: 25,
                color: isDifferent
                    ? AppColors.grey
                    : title == "My Packages"
                        ? null
                        : AppColors.PRIMART_COLOR,
              ):SvgPicture.asset(
                image,
                width: 25,
                color: isDifferent
                    ? AppColors.grey
                    : title == "My Packages"
                        ? null
                        : AppColors.PRIMART_COLOR,
              ),
              SizedBox(width: AppSize.s12),
              Text(
                title,
                style: TextStyle(color: isDifferent?AppColors.grey:Colors.black, fontSize: FontSize.s18,fontWeight: FontWeight.w600),
              ),
              SizedBox(width: AppSize.s24),
            ],
          ),
          SizedBox(height: 22),
        ],
      ),
    );
  }

/*
  Future<bool> getCheerFullStatus() async {
    try {
      if (homeCubit.cheerFullStatus) return true;
      CheerFullResponse cheerFullResponse =
          await ApiProvider().getCheerFullStatus();
      homeCubit.cheerFullStatus =
          kDebugMode ? true : cheerFullResponse.data!.isActive!;
      globalController.delivery_option.value =
          cheerFullResponse.data!.delivery_option!;
      globalController.pickup_option.value =
          cheerFullResponse.data!.pickup_option!;
      return homeCubit.cheerFullStatus;
    } catch (e) {
      Echo('error response $e');
    }
    return true;
  }


  Future<bool> getFaqStatus() async {
    try {
      if (homeCubit.faqStatus) return true;
      CheerFullResponse cheerFullResponse = await ApiProvider().getFaqStatus();
      if (cheerFullResponse.data == null) return true;
      homeCubit.faqStatus =
          kDebugMode ? true : cheerFullResponse.data!.isFaqActive!;
      return homeCubit.faqStatus;
    } catch (e) {
      Echo('error response $e');
    }
    return true;
  }

  Future<bool> getOrientationStatus() async {
    try {
      if (controller.orientationStatus ?? true) return true;
      homeCubit.orientationStatus =
          await ApiProvider().getOrientationVideosStatusStatus();
      homeCubit.orientationStatus =
          kDebugMode ? true : homeCubit.orientationStatus;
      return controller.orientationStatus ?? true;
    } catch (e) {
      Echo('error response $e');
    }
    return true;
  }
*/
  Future checkIfUserIsLogged() async {
    // Get.putAsync(() async => await Get.put(HomeController()));
    // bool isLogged = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    homeCubit.refreshController(false);
    // return isLogged;
  }
}
