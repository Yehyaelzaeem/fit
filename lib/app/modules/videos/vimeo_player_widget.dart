import 'package:app/app/modules/home/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeoPlayerWidget extends StatelessWidget {
  const VimeoPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeAppbar(type: null),
            Center(
              child: Container(
                height: Get.height*0.5,
                child: VimeoPlayer(
                  videoId: '786197180',
                ),
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
