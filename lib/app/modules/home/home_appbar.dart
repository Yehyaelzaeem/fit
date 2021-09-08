import 'package:app/app/models/user_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeAppbar extends StatefulWidget {
  final String? type;
  final Function? onBack;

  const HomeAppbar({Key? key, this.type, this.onBack}) : super(key: key);

  @override
  _HomeAppbarState createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  UserResponse ress = UserResponse();
  late int newMessage = 0;

  void getUserData() async {
    await ApiProvider().getProfile().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          newMessage = ress.data!.newMessages!;
        });
      } else {
        print("error");
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
    final controller = Get.put(HomeController());

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 8),
        width: MediaQuery.of(context).size.width,
        height: 65,
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.type == null
                ? GestureDetector(
                    onTap: () {
                      if (widget.onBack == null) {
                        Navigator.pop(context);
                      } else {
                        Get.offAllNamed(Routes.HOME);
                        controller.currentIndex.value = 1;
                      }
                      ;
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black87,
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
                      ),
                    ),
                  ),
            SizedBox(
              width: 25,
            ),
            Image.asset(
              kLogoRow,
              height: 44,
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
                                top: 8,
                                left: 16,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "$newMessage",
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  decoration:
                                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage("${ress.data!.image}"), fit: BoxFit.cover)),
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
