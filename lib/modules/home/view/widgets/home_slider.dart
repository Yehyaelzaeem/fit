import 'package:app/core/resources/app_values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';

class HomeSlider extends StatefulWidget {
  final List<String> sliders;

  HomeSlider({required this.sliders});

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  var _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical:AppSize.s12),
            child: CarouselSlider(
              items: widget.sliders.map((singleSlider) {
                return Container(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s12),
                    child: CachedNetworkImage(
                      imageUrl: singleSlider,
                      fadeInDuration: Duration(seconds: 2),
                      fit: BoxFit.cover,
                      errorWidget: (vtx, url, obj) {
                        return Container();
                      },
                      placeholder: (ctx, url) {
                        return CircularLoadingWidget();
                      },
                      // fit: BoxFit.c,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: deviceWidth*0.8,
                aspectRatio: 2.6,

                viewportFraction: 0.8,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 650),
                enlargeCenterPage: true,
                disableCenter: false,
                scrollDirection: Axis.horizontal,
                // to see it like cards
                initialPage: _currentPage,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
            //              height: 500,
                onPageChanged: (pageNo, reason) {
                  setState(() {
                    _currentPage = pageNo;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     ...widget.sliders.map((singleString) {
          //       var index = widget.sliders.indexOf(singleString);
          //       return Container(
          //           width: 8.0,
          //           height: 8.0,
          //           margin:
          //               EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               color: _currentPage == index
          //                   ? kColorPrimary
          //                   : Colors.grey));
          //     }),
          //   ],
          // ),
        ],
      ),
    );
  }
}
