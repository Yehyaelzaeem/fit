import 'package:app/app/modules/cart/views/web_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/orientation/controllers/orientation_controller.dart';
import 'package:app/app/modules/videos/vimeo_player_widget.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class OrientationView extends GetView<OrientationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      HomeAppbar(type: null),
      SizedBox(height: 12),
      Row(
        children: [
          PageLable(name: "Orientation"),
        ],
      ),
      SizedBox(height: 12),
      GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VimeoPlayerWidget(link:data[index].link)));
                    },
                    child: Container(
                      height: Get.height * 0.18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                              image: NetworkImage(data[index].photo),
                              fit: BoxFit.cover)),
                      child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              Icons.play_circle,
                              color: kColorPrimary,
                            )),
                      ),
                    ),
                  ),
                  Center(child: FittedBox(
                    child: kTextbody(data[index].title),)),
                ],
              ),
            );
          }),
    ]));
  }

  List<OrientationModel> data = [
    OrientationModel(
        id: 1,
        link: "786197180",
        photo:
            "https://webassets-prod.ultimateperformance.com/uploads/2021/04/27132605/Ultimate-Performance-Manchester-Roy-Front.jpg",
        title: "Video title"),
    OrientationModel(
        id: 2,
        link: "786512844",
        photo:
            "https://assets.upfitness.com/uploads/ckeditor/pictures/2396/content_Chris_16-week_transformation.jpg",
        title: "Video title"),
    OrientationModel(
        id: 3,
        link: "786197180",
        photo:
            "https://uploads-ssl.webflow.com/5e60ebb6df9df888b4ecc31e/62e9def2d891039fca71b96b_1.jpg",
        title: "Video title"),
    OrientationModel(
        id: 4,
        link: "786512844",
        photo:
            "https://www.boredpanda.com/blog/wp-content/uploads/2017/05/before-after-body-building-fitness-transformation-1-5912d6a730c00__700.jpg",
        title: "Video title"),
    OrientationModel(
        id: 5,
        link: "786197180",
        photo:
            "https://s.yimg.com/ny/api/res/1.2/N0mlmhCrv4DIR1aEBUIHHw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTY0MDtoPTU5MA--/https://media.zenfs.com/en/homerun/feed_manager_auto_publish_494/689797ce6c970a2e2eca03d5749f538d",
        title: "Video title"),
    OrientationModel(
        id: 6,
        link: "786512844",
        photo:
            "https://assets.gqindia.com/photos/5dc162026cce8200089fc9f2/4:3/w_1439,h_1079,c_limit/How%20to%20lose%20weight%20like%20this%20guy%20who%20lost%2033%20kgs%20to%20look%20as%20fit%20as%20Superman%20for%20his%20daughter.jpg",
        title: "Video title"),
  ];
}

class OrientationModel {
  final int id;
  final String link;
  final String photo;
  final String title;

  OrientationModel({
    required this.id,
    required this.link,
    required this.photo,
    required this.title,
  });
}
