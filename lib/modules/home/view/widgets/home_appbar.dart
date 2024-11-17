
import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/resources.dart';
import 'package:app/core/utils/globals.dart';
import 'package:app/core/view/views.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/navigation/routes.dart';
import '../../../../core/models/user_response.dart';
import '../../../../core/services/api_provider.dart';
import '../../../profile/cubits/profile_cubit.dart';
import '../../cubits/home_cubit.dart';


class HomeAppbar extends StatefulWidget {
  final bool removeNotificationsCount;
  final String? type;
  final Function? onBack;
  final bool? fromInvoice;

  const HomeAppbar({
    Key? key,
    this.type,
    this.removeNotificationsCount = false,
    this.fromInvoice = false,
    this.onBack,
  }) : super(key: key);

  @override
  _HomeAppbarState createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  // UserResponse ress = UserResponse();
  late int newMessage = 0;
  var isPortrait;

  late final ProfileCubit profileCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    getUserData();
    super.initState();
  }

  void getUserData() async {
    await profileCubit.getProfile().then((value) {
      if (currentUser?.success == true) {
        setState(() {
          newMessage = currentUser!.data!.newMessages!;
        });

      }
    });

    // await ApiProvider().getProfile().then((value) {
    //   if (value.success == true) {
    //     setState(() {
    //       ress = value;
    //       newMessage = ress.data!.newMessages!;
    //     });
    //     if (ress.data != null && ress.data!.image != null) {
    //       BlocProvider.of<HomeCubit>(context).avatar.value = ress.data!.image!;
    //       Echo(' getUserData avatart  ${BlocProvider.of<HomeCubit>(context).avatar.value}');
    //     } else {
    //       Echo(' getUserData avatart nulls');
    //     }
    //   } else {
    //     Echo(' getUserData error ');
    //   }
    // });


  }

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.landscape;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(bottom:8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
              color: AppColors.white,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(AppSize.s16),bottomLeft: Radius.circular(AppSize.s16),),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ]
          ),
          child: isPortrait
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.14,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onBack == null) {
                            Navigator.pop(context);
                          } else {
                            widget.fromInvoice == true
                                ? NavigationService.pushReplacement(context,Routes.myPackagesView)
                                : NavigationService.pushReplacementAll(context,Routes.homeScreen);
                            BlocProvider.of<HomeCubit>(context).currentIndex.value = 0;
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 30,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        AppImages.kLogoRow,
                        height: 54,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.14,
                      child: Row(
                        children: [
                          currentUser?.data == null
                              ? SizedBox(
                                  width: 50,
                                )
                              : Container(
                                  width: 50,
                                  child: GestureDetector(
                                    onTap: () {
                                      newMessage = 0;
                                      setState(() {});
                                      NavigationService.push(context,Routes.notificationScreen);
                                    },
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          color: Colors.black87,
                                          size: 30,
                                        ),
                                        Positioned(
                                          top: 4,
                                          left: 16,
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text(
                                                widget.removeNotificationsCount
                                                    ? "0"
                                                    : "$newMessage",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          HorizontalSpace(AppSize.s40),
                          currentUser?.data == null
                              ? SizedBox(
                                  width: 40,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    if (currentUser!=null)
                                      NavigationService.push(context,Routes.profile);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: CachedNetworkImage(
                                        imageUrl: "${currentUser?.data?.image}",
                                        fit: BoxFit.cover,
                                        placeholder: (ctx, url) {
                                          return profileImageHolder();
                                        },
                                        errorWidget: (context, url, error) {
                                          return profileImageHolder();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.type == null
                        ? GestureDetector(
                            onTap: () {
                              if (widget.onBack == null) {
                                Navigator.pop(context);
                              } else {
                                widget.fromInvoice == true
                                    ? NavigationService.pushReplacement(context,Routes.myPackagesView)
                                    : NavigationService.pushReplacementAll(context,Routes.homeScreen);
                                BlocProvider.of<HomeCubit>(context).currentIndex.value = 0;
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                                color: Colors.black87,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              // Scaffold.of(context).openDrawer();
                              NavigationService.push(context, Routes.homeDrawer);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                AppIcons.drawerIcon,
                              ),
                            ),
                          ),
                    SizedBox(
                      width: AppSize.s24,
                    ),
                    SvgPicture.asset(
                      AppImages.logoAppbar,
                      height: 50,
                    ),

                    Row(
                      children: [
                        currentUser?.data == null
                            ? SizedBox(
                                width: AppSize.s48,
                              )
                            : Container(
                          width: AppSize.s48,
                                child: GestureDetector(
                                  onTap: () {
                                    newMessage = 0;
                                    setState(() {});
                                    NavigationService.push(context,Routes.notificationScreen);
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(AppSize.s4),
                                        child: SvgPicture.asset(
                                          AppIcons.messages,
                                          width: AppSize.s28,
                                          color: AppColors.customBlack,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 8,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              widget.removeNotificationsCount
                                                  ? "0"
                                                  : "$newMessage",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: FontSize.s14),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFF6466),
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        HorizontalSpace(AppSize.s20),

                        currentUser?.data == null
                            ? SizedBox(
                                width: 40,
                              )
                            : GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  if (currentUser!=null)
                                    NavigationService.push(context,Routes.profile);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: CachedNetworkImage(
                                      imageUrl: "${currentUser!.data!.image}",
                                      fit: BoxFit.cover,
                                      placeholder: (ctx, url) {
                                        return profileImageHolder();
                                      },
                                      errorWidget: (context, url, error) {
                                        return profileImageHolder();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget profileImageHolder() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueGrey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.person, size: 16, color: Colors.grey[200]),
      ),
    );
  }
}
