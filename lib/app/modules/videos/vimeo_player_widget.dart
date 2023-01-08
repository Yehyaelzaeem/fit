import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeoPlayerWidget extends StatelessWidget {
  const VimeoPlayerWidget({Key? key,required this.link}) : super(key: key);
final String link;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width,
              height: 65,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
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
                      GestureDetector(
                    onTap: () {
                        Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Image.asset(
                      kLogoRow,
                      height: 54,
                    ),
                  ),
               Expanded(child: SizedBox(),)
                ],
              ),
            ),
            Expanded(
              child: VimeoPlayer(
                videoId: link,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
