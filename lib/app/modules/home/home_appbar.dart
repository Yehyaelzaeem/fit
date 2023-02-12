import 'package:app/app/models/user_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeAppbar extends StatefulWidget {
  final bool removeNotificationsCount;
  final String? type;
  final Function? onBack;

  const HomeAppbar({
    Key? key,
    this.type,
    this.removeNotificationsCount = false,
    this.onBack,
  }) : super(key: key);

  @override
  _HomeAppbarState createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  UserResponse ress = UserResponse();
  late int newMessage = 0;
  var isPortrait;

  void getUserData() async {
    Echo('getUserData');
    await ApiProvider().getProfile().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          newMessage = ress.data!.newMessages!;
        });
        if (ress.data != null && ress.data!.image != null) {
          final controller = Get.find<HomeController>(tag: 'home');
          controller.avatar.value = ress.data!.image!;
          Echo(' getUserData avatart  ${controller.avatar.value}');
        } else {
          Echo(' getUserData avatart nulls');
        }
      } else {
        Echo(' getUserData error ');
      }
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.landscape;
    final controller = Get.find<HomeController>(tag: 'home');

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 8),
        width: MediaQuery.of(context).size.width,
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
                          Get.offAllNamed(Routes.HOME);
                          controller.currentIndex.value = 0;
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
                      kLogoRow,
                      height: 54,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.14,
                    child: Row(
                      children: [
                        ress.data == null
                            ? SizedBox(
                                width: 50,
                              )
                            : Container(
                                width: 50,
                                child: GestureDetector(
                                  onTap: () {
                                    newMessage = 0;
                                    setState(() {});
                                    Get.toNamed(Routes.NOTIFICATIONS);
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
                        ress.data == null
                            ? SizedBox(
                                width: 40,
                              )
                            : GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  if (controller.isLogggd.value)
                                    Get.toNamed(Routes.PROFILE);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: CachedNetworkImage(
                                      imageUrl: "${ress.data!.image}",
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
                              Get.offAllNamed(Routes.HOME);
                              controller.currentIndex.value = 0;
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
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.menu,
                              color: Colors.black87,
                              size: 30,
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 25,
                  ),
                  Image.asset(
                    kLogoRow,
                    height: 54,
                  ),
                  Row(
                    children: [
                      ress.data == null
                          ? SizedBox(
                              width: 50,
                            )
                          : Container(
                              width: 50,
                              child: GestureDetector(
                                onTap: () {
                                  newMessage = 0;
                                  setState(() {});
                                  Get.toNamed(Routes.NOTIFICATIONS);
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
                      ress.data == null
                          ? SizedBox(
                              width: 40,
                            )
                          : GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                if (controller.isLogggd.value)
                                  Get.toNamed(Routes.PROFILE);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: CachedNetworkImage(
                                    imageUrl: "${ress.data!.image}",
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
