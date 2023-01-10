import 'package:app/app/modules/home/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeoPlayerWidget extends StatelessWidget {
  const VimeoPlayerWidget({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeAppbar(type: null),
            Expanded(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: VimeoPlayer(
                  videoId: link,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
