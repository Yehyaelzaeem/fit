import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
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
            HomeAppbar(),
            Expanded(
              child:link.contains('vimeo')? AspectRatio(
                aspectRatio: 16/9,
                child: VimeoPlayer(
                  videoId: link.split('/').last,
                ),
              ):Center(
                child: kTextHeader('No Vimeo Video Attached',color: kColorPrimary,bold: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
