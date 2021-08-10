import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppbar extends StatelessWidget {
  final String? type;

  const HomeAppbar({Key? key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 8),
        width: MediaQuery.of(context).size.width,
        height: 56,
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
          children: [
            type == null
                ? GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
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
                      ),
                    ),
                  ),
            Expanded(
              child: Image.asset(
                kLogoRow,
                height: 44,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.NOTIFICATIONS);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                kAvatar,
                height: 32,
                width: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
